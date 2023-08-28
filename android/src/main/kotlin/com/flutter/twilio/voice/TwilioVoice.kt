package com.flutter.twilio.voice

import android.content.Context
import android.os.Bundle
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.voice.*
import com.twilio.voice.Call.Listener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import java.util.*
import kotlin.concurrent.schedule

/** TwilioVoice */

class TwilioVoice: FlutterPlugin, ActivityAware {
    private lateinit var methodChannel: MethodChannel

    private lateinit var registrationChannel: EventChannel

    private lateinit var handleMessageChannel: EventChannel

    private lateinit var callOutGoingChannel: EventChannel

    private lateinit var callIncomingChannel: EventChannel

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object
    {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar)
        {
            instance = TwilioVoice()
            instance.onAttachedToEngine(registrar.context(), registrar.messenger())
        }

        lateinit var messenger: BinaryMessenger

        @JvmStatic
        lateinit var instance: TwilioVoice

        const val TAG="TwilioVoice"

        var notificationSink: EventChannel.EventSink? = null

        var handleMessageSink: EventChannel.EventSink? = null

        var callOutGoingSink: EventChannel.EventSink? = null

        var callIncomingSink: EventChannel.EventSink? = null


        @JvmStatic
        lateinit var applicationContext: Context

        private var activeCall: Call? = null

        private var activeCallInvite: CallInvite? = null

        private var cancelledCallInvites: CancelledCallInvite? = null
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        TwilioVoice.messenger = messenger
        TwilioVoice.applicationContext = applicationContext

        val pluginHandler = PluginHandler()
        methodChannel = MethodChannel(messenger, "TwilioVoice")
        methodChannel.setMethodCallHandler(pluginHandler)

        registrationChannel = EventChannel(messenger, "TwilioVoice/registrationChannel")

        registrationChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                notificationSink = events
            }

            override fun onCancel(arguments: Any) {
                notificationSink = null
            }
        })

        handleMessageChannel = EventChannel(messenger, "TwilioVoice/handleMessage")
        handleMessageChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                handleMessageSink = events
            }

            override fun onCancel(arguments: Any) {
                handleMessageSink = null
            }
        })

        callOutGoingChannel = EventChannel(messenger, "TwilioVoice/callOutGoingChannel")
        callOutGoingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                callOutGoingSink = events
            }

            override fun onCancel(arguments: Any) {
                callOutGoingSink = null
            }
        })

        callIncomingChannel = EventChannel(messenger, "TwilioVoice/callIncomingChannel")
        callIncomingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                callIncomingSink = events
            }

            override fun onCancel(arguments: Any) {
                callIncomingSink = null
            }
        })

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        registrationChannel.setStreamHandler(null)
        handleMessageChannel.setStreamHandler(null)
        callIncomingChannel.setStreamHandler(null)
        callOutGoingChannel.setStreamHandler(null)
    }

    fun makeCall(call: MethodCall, result: MethodChannel.Result)
    {
        val to: String = call.argument<String>("To") ?: return result.error("ERROR", "Missing To", null)
        val from: String = call.argument<String>("from") ?: return result.error("ERROR", "Missing from", null)
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error("ERROR", "Missing accessToken", null)
        val displayName: String = call.argument<String>("displayName") ?: return result.error("ERROR", "Missing display name", null)
        try
        {
            val params = HashMap<String, String>()
            params["To"] = to
            params["From"] = from
            params["accessToken"] = accessToken
            params["displayName"] = displayName
            val connectOptions = ConnectOptions.Builder(accessToken)
                .params(params)
                .build()
            activeCall = Voice.connect(applicationContext, connectOptions, object : Listener
            {
                override fun onConnectFailure(call: Call, callException: CallException)
                {
                    sendEventOutGoingCall("onConnectFailure", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onRinging(call: Call) {
                    sendEventOutGoingCall("onRinging", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onConnected(call: Call) {
                    activeCall = call
                    sendEventOutGoingCall("onConnected", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onReconnecting(call: Call, callException: CallException)
                {
                    sendEventOutGoingCall("onReconnecting", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onReconnected(call: Call)
                {
                    sendEventOutGoingCall("onReconnected", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onDisconnected(call: Call, callException: CallException?)
                {
                    sendEventOutGoingCall("onDisconnected", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onCallQualityWarningsChanged(call: Call, currentWarnings: MutableSet<Call.CallQualityWarning>, previousWarnings: MutableSet<Call.CallQualityWarning>) {
                    if (previousWarnings.size > 1)
                    {
                        val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                        currentWarnings.removeAll(previousWarnings)
                        intersection.retainAll(previousWarnings)
                        previousWarnings.removeAll(intersection)
                    }
                    sendEventOutGoingCall("onCallQualityWarningsChanged", mapOf("data" to Mapper.callToMap(call)), null)
                }
            })
        }
        catch (e: Exception)
        {
            result.error("ERROR", e.toString(), e)
        }
    }

    fun makeCallWithSid(call: MethodCall, result: MethodChannel.Result)
    {
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error("ERROR", "Missing accessToken", null)
        val to: String = call.argument<String>("To") ?: return result.error("ERROR", "Missing To", null)
        val from: String = call.argument<String>("from") ?: return result.error("ERROR", "Missing from", null)
        val workspaceSid: String = call.argument<String>("workspaceSid") ?: return result.error("ERROR", "Missing workspaceSid", null)
        val channelSid: String = call.argument<String>("channelSid") ?: return result.error("ERROR", "Missing channelSid", null)
        val agentId: String = call.argument<String>("agentId") ?: return result.error("ERROR", "Missing agentId", null)
        val hubspotClient: String = call.argument<String>("hubspotClient") ?: return result.error("ERROR", "Missing hubspotClient", null)
        val conversationSid: String = call.argument<String>("conversationSid") ?: return result.error("ERROR", "Missing conversationSid", null)
        try
        {
            val params = HashMap<String, String>()
            params["To"] = to
            params["From"] = from
            params["workspace_sid"] = workspaceSid
            params["channel_sid"] = channelSid
            params["agent_id"] = agentId
            params["platform"] = "mobile"
            params["hubspot_client"] = hubspotClient
            params["conversation_sid"] = conversationSid
            val connectOptions = ConnectOptions.Builder(accessToken)
                .params(params)
                .build()
            activeCall = Voice.connect(applicationContext, connectOptions, object : Listener
            {
                override fun onRinging(call: Call) {
                    sendEventOutGoingCall("onRinging", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onConnected(call: Call) {
                    activeCall = call
                    sendEventOutGoingCall("onConnected", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onConnectFailure(call: Call, callException: CallException)
                {
                    sendEventOutGoingCall("onConnectFailure", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onReconnecting(call: Call, callException: CallException)
                {
                    sendEventOutGoingCall("onReconnecting", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onReconnected(call: Call)
                {
                    sendEventOutGoingCall("onReconnected", mapOf("data" to Mapper.callToMap(call)), null)
                }

                override fun onDisconnected(call: Call, callException: CallException?)
                {
                    sendEventOutGoingCall("onDisconnected", mapOf("data" to Mapper.callToMap(call)), callException)
                }

                override fun onCallQualityWarningsChanged(call: Call, currentWarnings: MutableSet<Call.CallQualityWarning>, previousWarnings: MutableSet<Call.CallQualityWarning>) {
                    if (previousWarnings.size > 1)
                    {
                        val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                        currentWarnings.removeAll(previousWarnings)
                        intersection.retainAll(previousWarnings)
                        previousWarnings.removeAll(intersection)
                    }
                    sendEventOutGoingCall("onCallQualityWarningsChanged", mapOf("data" to Mapper.callToMap(call)), null)
                }
            })
        }
        catch (e: Exception)
        {
            result.error("ERROR", e.toString(), e)
        }
    }

    fun rejectCall()
    {
        if(activeCallInvite!=null)
        {
            activeCallInvite?.reject(applicationContext)
        }
        else
        {
            Log.d(TAG, "handleMessage kt: activeCallInvite is null. Pass handleMessage before invoking")
        }
    }

    fun disConnect()
    {
        activeCall?.disconnect()
    }

    fun mute()
    {
        if (activeCall != null)
        {
            val mute = !activeCall!!.isMuted
            activeCall!!.mute(mute)
        }
    }

    fun hold()
    {
        if (activeCall != null)
        {
            val hold = !activeCall!!.isOnHold
            activeCall!!.hold(hold)
        }
    }

    fun handleMessage(call: MethodCall, result: MethodChannel.Result)
    {
        val notification = call.argument("notification") as? Map<String, Any>

        val bundle=createBundleFromMap(notification)

        Voice.handleMessage(applicationContext, bundle!!, object : MessageListener
        {
            override fun onCallInvite(callInvite: CallInvite)
            {
                activeCallInvite = callInvite
                sendEventHandleMessage("onCallInvite", mapOf("data" to Mapper.callInviteToMap(callInvite)), null)
                result.success(mapOf("result" to Mapper.callInviteToMap(callInvite)))
            }

            override fun onCancelledCallInvite(cancelledCallInvite: CancelledCallInvite, callException: CallException?)
            {
                cancelledCallInvites = cancelledCallInvite
                sendEventHandleMessage("onCancelledCallInvite", mapOf("data" to Mapper.cancelledCallInviteToMap(cancelledCallInvite)), callException)
            }
        })
    }

    private fun createBundleFromMap(parameterMap: Map<String, Any>?): Bundle?
    {
        if (parameterMap == null)
        {
            return null
        }

        val bundle = Bundle()
        for (jsonParam in parameterMap.entries)
        {
            val value = jsonParam.value
            val key = jsonParam.key
            when (value) {
                is String -> bundle.putString(key, value)
                is Int -> bundle.putInt(key, value)
                is Long -> bundle.putLong(key, value)
                is Double -> bundle.putDouble(key, value)
                is Boolean -> bundle.putBoolean(key, value)
                is Map<*, *> -> {
                    val nestedBundle = createBundleFromMap(value as Map<String, Any>)
                    bundle.putBundle(key, nestedBundle as Bundle)
                }
                else -> throw IllegalArgumentException("Unsupported value type: $value")
            }
        }
        return bundle
    }

    fun acceptCall(call: MethodCall, result: MethodChannel.Result)
    {
        try
        {
            activeCallInvite?.accept(applicationContext, object : Listener {
                override fun onConnectFailure(call: Call, callException: CallException) {
                    sendEventIncomingCall("onConnectFailure", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), callException)
                }

                override fun onRinging(call: Call) {
                    sendEventIncomingCall("onRinging", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), null)
                }

                override fun onConnected(call: Call) {
                    activeCall = call
                    sendEventIncomingCall("onConnected", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), null)
                }

                override fun onReconnecting(call: Call, callException: CallException) {
                    sendEventIncomingCall("onReconnecting", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), callException)
                }

                override fun onReconnected(call: Call) {
                    sendEventIncomingCall("onReconnected", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), null)
                }

                override fun onDisconnected(call: Call, callException: CallException?) {
                    sendEventIncomingCall("onDisconnected", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), callException)
                }

                override fun onCallQualityWarningsChanged(call: Call, currentWarnings: MutableSet<Call.CallQualityWarning>, previousWarnings: MutableSet<Call.CallQualityWarning>) {
                    if (previousWarnings.size > 1) {
                        val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                        currentWarnings.removeAll(previousWarnings)
                        intersection.retainAll(previousWarnings)
                        previousWarnings.removeAll(intersection)
                    }
                    sendEventIncomingCall("onCallQualityWarningsChanged", mapOf("data" to Mapper.callInviteToMap(activeCallInvite!!)), null)
                }
            })
        }
        catch (error: Exception)
        {
            Log.d(TAG, "acceptCall: " + error.message)
        }
    }

    fun sendDigit(call: MethodCall, result: MethodChannel.Result)
    {
        val digit: String = call.argument<String>("digit") ?: return result.error("MISSING_PARAMS", "The parameter 'digit' was not given", null)
        activeCall?.sendDigits(digit)
    }

    fun registerForNotification(call: MethodCall, result: MethodChannel.Result) {
        val token: String = call.argument<String>("token") ?: return result.error(
            "MISSING_PARAMS",
            "The parameter 'token' was not given",
            null
        )
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error(
            "MISSING_PARAMS",
            "The parameter 'accessToken' was not given",
            null
        )

        Voice.register(
            accessToken,
            Voice.RegistrationChannel.FCM,
            token,
            object : RegistrationListener {
                override fun onRegistered(accessToken: String, fcmToken: String) {
                    sendEventRegistration(
                        "registerForNotification",
                        mapOf("result" to true, "errorCode" to "000000000", "errorMsg" to "")
                    )
                    result.success(
                        mapOf(
                            "result" to true,
                            "errorCode" to "000000000",
                            "errorMsg" to ""
                        )
                    )
                }

                override fun onError(
                    registrationException: RegistrationException,
                    accessToken: String,
                    fcmToken: String
                ) {
                    sendEventRegistration(
                        "registerForNotification",
                        mapOf(
                            "result" to false,
                            "errorCode" to registrationException.errorCode,
                            "errorMsg" to registrationException.message
                        ),
                        registrationException
                    )
                    result.success(
                        mapOf(
                            "result" to false,
                            "errorCode" to registrationException.errorCode,
                            "errorMsg" to registrationException.message
                        )
                    )
                }
            }
        )
    }

    fun unregisterForNotification(call: MethodCall, result: MethodChannel.Result)
    {
        val token: String = call.argument<String>("token") ?: return result.error("MISSING_PARAMS", "The parameter 'token' was not given", null)
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error("MISSING_PARAMS", "The parameter 'accessToken' was not given", null)

        Voice.unregister(accessToken, Voice.RegistrationChannel.FCM, token, object : UnregistrationListener {
            override fun onUnregistered(accessToken: String?, fcmToken: String?) {
                sendEventRegistration("unregisterForNotification", mapOf("result" to true, "errorCode" to "000000000", "errorMsg" to ""))
                result.success(mapOf("result" to true , "errorCode" to "000000000", "errorMsg" to ""))
            }

            override fun onError(registrationException: RegistrationException, accessToken: String?, fcmToken: String?) {
                sendEventRegistration("unregisterForNotification", mapOf("result" to false, "errorCode" to registrationException.errorCode, "errorMsg" to registrationException.message), registrationException)
                result.success(mapOf("result" to false, "errorCode" to registrationException.errorCode, "errorMsg" to registrationException.message))
            }
        })
    }

    private fun sendEventRegistration(name: String, data: Any?, e: RegistrationException? = null)
    {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        notificationSink?.success(eventData)
    }

    private fun sendEventHandleMessage(name: String, data: Any?, e: CallException? = null)
    {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        handleMessageSink?.success(eventData)
    }

    private fun sendEventOutGoingCall(name: String, data: Any?, e: CallException? = null)
    {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        callOutGoingSink?.success(eventData)
    }

    private fun sendEventIncomingCall(name: String, data: Any?, e: CallException? = null)
    {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        callIncomingSink?.success(eventData)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding)
    {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges()
    {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges: TwilioVoice.onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivity()
    {
        Log.d(TAG, "onDetachedFromActivity: TwilioVoice.onDetachedFromActivity")
    }
}