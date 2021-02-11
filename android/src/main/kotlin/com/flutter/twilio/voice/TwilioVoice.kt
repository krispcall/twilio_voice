package com.flutter.twilio.voice

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.chat.ChannelListener
import com.twilio.chat.ChatClient
import com.twilio.voice.*
import com.twilio.voice.Call.Listener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import java.util.*


/** TwilioVoice */

class TwilioVoice: FlutterPlugin, ActivityAware{
    private lateinit var methodChannel: MethodChannel

    private lateinit var chatChannel: EventChannel

    private lateinit var mediaProgressChannel: EventChannel

    private lateinit var loggingChannel: EventChannel

    private lateinit var notificationChannel: EventChannel

    private lateinit var handleMessageChannel: EventChannel

    private lateinit var onCallChannel: EventChannel


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

        @JvmStatic
        var chatClient: ChatClient? = null

        const val TAG="TwilioVoice"

        var mediaProgressSink: EventChannel.EventSink? = null

        var loggingSink: EventChannel.EventSink? = null

        var notificationSink: EventChannel.EventSink? = null

        var handleMessageSink: EventChannel.EventSink? = null

        var onCallSink: EventChannel.EventSink? = null

        var handler = Handler(Looper.getMainLooper())

        var nativeDebug: Boolean = false

        lateinit var chatListener: ChatListener

        var channelChannels: HashMap<String, EventChannel> = hashMapOf()
        var channelListeners: HashMap<String, ChannelListener> = hashMapOf()

        @JvmStatic
        lateinit var applicationContext: Context

        private var activeCall: Call? = null

        private var activeCallInvite: CallInvite? = null

        private var cancelledCallInvites: CancelledCallInvite? = null

        @JvmStatic
        fun debug(msg: String)
        {
            if (nativeDebug) {
                Log.d(TAG, msg)
                handler.post(Runnable {
                    loggingSink?.success(msg)
                })
            }
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        TwilioVoice.messenger = messenger
        TwilioVoice.applicationContext = applicationContext

        val pluginHandler = PluginHandler(applicationContext)
        methodChannel = MethodChannel(messenger, "TwilioVoice")
        methodChannel.setMethodCallHandler(pluginHandler)

        chatChannel = EventChannel(messenger, "TwilioVoice/room")
        chatChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => Chat eventChannel attached")
                chatListener.events = events
                chatClient?.setListener(chatListener)
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioVoice.onAttachedToEngine => Chat eventChannel detached")
                chatListener.events = null
            }
        })

        mediaProgressChannel = EventChannel(messenger, "TwilioVoice/media_progress")
        mediaProgressChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => MediaProgress eventChannel attached")
                mediaProgressSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioVoice.onAttachedToEngine => MediaProgress eventChannel detached")
                mediaProgressSink = null
            }
        })

        loggingChannel = EventChannel(messenger, "TwilioVoice/logging")
        loggingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => Logging eventChannel attached")
                loggingSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioVoice.onAttachedToEngine => Logging eventChannel detached")
                loggingSink = null
            }
        })

        notificationChannel = EventChannel(messenger, "TwilioVoice/notification")
        notificationChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => Notification eventChannel attached")
                notificationSink = events
            }

            override fun onCancel(arguments: Any) {
                debug("TwilioVoice.onAttachedToEngine => Notification eventChannel detached")
                notificationSink = null
            }
        })

        handleMessageChannel = EventChannel(messenger, "TwilioVoice/handleMessage")
        handleMessageChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => handleMessage eventChannel attached")
                handleMessageSink = events
            }

            override fun onCancel(arguments: Any) {
                debug("TwilioVoice.onAttachedToEngine => handleMessage eventChannel detached")
                handleMessageSink = null
            }
        })

        onCallChannel = EventChannel(messenger, "TwilioVoice/onCall")
        onCallChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioVoice.onAttachedToEngine => onCallChannel eventChannel attached")
                onCallSink = events
            }

            override fun onCancel(arguments: Any) {
                debug("TwilioVoice.onAttachedToEngine => onCallChannel eventChannel detached")
                onCallSink = null
            }
        })

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioVoice.onDetachedFromEngine")
        methodChannel.setMethodCallHandler(null)
        chatChannel.setStreamHandler(null)
        loggingChannel.setStreamHandler(null)
        notificationChannel.setStreamHandler(null)
        mediaProgressChannel.setStreamHandler(null)
        handleMessageChannel.setStreamHandler(null)
        onCallChannel.setStreamHandler(null)
    }

    fun makeCall(call: MethodCall, result: MethodChannel.Result)
    {
        val to = call.argument<String>("To") ?: return result.error("ERROR", "Missing To", null)
        val from = call.argument<String>("from") ?: return result.error("ERROR", "Missing from", null)
        val accessToken = call.argument<String>("accessToken") ?: return result.error("ERROR", "Missing accessToken", null)
        val displayName = call.argument<String>("displayName") ?: return result.error("ERROR", "Missing display name", null)
        try
        {

            val params = HashMap<String, String>()
            params["To"] = to
            params["from"] = from
            params["accessToken"] = accessToken
            params["displayName"] = displayName
            val connectOptions = ConnectOptions.Builder(accessToken)
                    .params(params)
                    .build()
            activeCall = Voice.connect(applicationContext, connectOptions, object:Listener {
                override fun onConnectFailure(call: Call, callException: CallException) {
                    Log.d(TAG, "onConnectFailure ${callException.message}")
                    debug("TwilioProgrammableChatPlugin.onConnectFailure => onConnectFailure")
                    sendEventHandleMessage("onConnectFailure", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onRinging(call: Call) {
                    Log.d(TAG, "onConnectFailure ${call.from}")
                    Log.d(TAG, "onConnectFailure ${call.to}")
                    Log.d(TAG, "onConnectFailure ${call.callQualityWarnings}")
                    Log.d(TAG, "onConnectFailure ${call.isOnHold}")
                    Log.d(TAG, "onConnectFailure ${call.isMuted}")
                    debug("TwilioProgrammableChatPlugin.onRinging => onRinging")
                    sendEventOnCall("onConnectFailure", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onConnected(call: Call) {
                    Log.d(TAG, "onConnected ${call.from}")
                    Log.d(TAG, "onConnected ${call.to}")
                    Log.d(TAG, "onConnected ${call.callQualityWarnings}")
                    Log.d(TAG, "onConnected ${call.isOnHold}")
                    Log.d(TAG, "onConnected ${call.isMuted}")
                    activeCall = call
                    debug("TwilioProgrammableChatPlugin.onConnected => onConnected")
                    sendEventOnCall("onConnected", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onReconnecting(call: Call, callException: CallException) {
                    Log.d(TAG, "onReconnecting ${call.from}")
                    Log.d(TAG, "onReconnecting ${call.to}")
                    Log.d(TAG, "onReconnecting ${call.callQualityWarnings}")
                    Log.d(TAG, "onReconnecting ${call.isOnHold}")
                    Log.d(TAG, "onReconnecting ${call.isMuted}")
                    Log.d(TAG, "onReconnecting ${callException.message}")
                    debug("TwilioProgrammableChatPlugin.onReconnecting => onReconnecting")
                    sendEventOnCall("onReconnecting", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onReconnected(call: Call) {
                    Log.d(TAG, "onReconnected ${call.from}")
                    Log.d(TAG, "onReconnected ${call.to}")
                    Log.d(TAG, "onReconnected ${call.callQualityWarnings}")
                    Log.d(TAG, "onReconnected ${call.isOnHold}")
                    Log.d(TAG, "onReconnected ${call.isMuted}")
                    debug("TwilioProgrammableChatPlugin.onReconnected => onReconnected")
                    sendEventOnCall("onReconnected", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onDisconnected(call: Call, callException: CallException?) {
                    Log.d(TAG, "onReconnecting ${call.from}")
                    Log.d(TAG, "onReconnecting ${call.to}")
                    Log.d(TAG, "onReconnecting ${call.callQualityWarnings}")
                    Log.d(TAG, "onReconnecting ${call.isOnHold}")
                    Log.d(TAG, "onReconnecting ${call.isMuted}")
                    Log.d(TAG, "onReconnecting ${callException.toString()}")
                    debug("TwilioProgrammableChatPlugin.onDisconnected => onDisconnected")
                    sendEventOnCall("onDisconnected", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onCallQualityWarningsChanged(call: Call, currentWarnings: MutableSet<Call.CallQualityWarning>, previousWarnings: MutableSet<Call.CallQualityWarning>) {
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.from}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.to}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.callQualityWarnings}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.isOnHold}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.isMuted}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${currentWarnings.toString()}")
                    debug("TwilioProgrammableChatPlugin.onDisconnected => onDisconnected")
                    if (previousWarnings.size > 1) {
                        val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                        currentWarnings.removeAll(previousWarnings)
                        intersection.retainAll(previousWarnings)
                        previousWarnings.removeAll(intersection)
                    }
                    sendEventOnCall("onCallQualityWarningsChanged", mapOf("data" to Mapper.callToMap(call)))
                }
            })

        }
        catch (e: Exception)
        {
            result.error("ERROR", e.toString(), e)
        }
    }

    fun rejectCall(call: MethodCall, result: MethodChannel.Result)
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

    fun disConnect(call: MethodCall, result: MethodChannel.Result)
    {
        activeCall?.disconnect()
    }

    fun mute(call: MethodCall, result: MethodChannel.Result)
    {
        if (activeCall != null)
        {
            val mute = !activeCall!!.isMuted
            Log.d(TAG, "mute: $mute")
            activeCall!!.mute(mute)
        }
    }

    fun handleMessage(call: MethodCall, result: MethodChannel.Result)
    {
        val notification = call.argument("notification") as? Map<String, Any>

        val bundle=createBundleFromMap(notification)
        Voice.handleMessage(applicationContext, bundle!!, object : MessageListener {
            override fun onCallInvite(callInvite: CallInvite)
            {
                Log.d(TAG, "onCallInvite: "+mapOf("data" to Mapper.callInviteToMap(callInvite)))
                activeCallInvite = callInvite
                debug("TwilioProgrammableChatPlugin.handleMessage => handleMessage onCallInvite ${callInvite.from}")
                sendEventHandleMessage("onCallInvite", mapOf("data" to Mapper.callInviteToMap(callInvite)))
            }

            override fun onCancelledCallInvite(cancelledCallInvite: CancelledCallInvite, callException: CallException?) {
                Log.d(TAG, "onCancelledCallInvite: "+mapOf("data" to Mapper.cancelledCallInviteToMap(cancelledCallInvite)))
                cancelledCallInvites = cancelledCallInvite
                debug("TwilioProgrammableChatPlugin.handleMessage => handleMessage onCancelledCallInvite ${cancelledCallInvite.from}")
                sendEventHandleMessage("onCancelledCallInvite", mapOf("data" to Mapper.cancelledCallInviteToMap(cancelledCallInvite)))
            }
        })
    }

    private fun createBundleFromMap(parameterMap: Map<String, Any>?): Bundle? {
        if (parameterMap == null)
        {
            return null
        }

        val bundle = Bundle()
        for (jsonParam in parameterMap.entries) {
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
            Log.d(TAG, "acceptCall: " + activeCallInvite!!.from)
            Log.d(TAG, "acceptCall: " + activeCallInvite!!.callerInfo)
            Log.d(TAG, "acceptCall: " + activeCallInvite!!.toString())
            activeCallInvite?.accept(applicationContext, object:Listener
            {
                override fun onConnectFailure(call: Call, callException: CallException) {
                    Log.d(TAG, "onConnectFailure ${callException.message}")
                    debug("TwilioProgrammableChatPlugin.onConnectFailure => onConnectFailure")
                    sendEventHandleMessage("onConnectFailure", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onRinging(call: Call) {
                    Log.d(TAG, "onConnectFailure ${call.from}")
                    Log.d(TAG, "onConnectFailure ${call.to}")
                    Log.d(TAG, "onConnectFailure ${call.callQualityWarnings}")
                    Log.d(TAG, "onConnectFailure ${call.isOnHold}")
                    Log.d(TAG, "onConnectFailure ${call.isMuted}")
                    debug("TwilioProgrammableChatPlugin.onRinging => onRinging")
                    sendEventOnCall("onConnectFailure", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onConnected(call: Call) {
                    Log.d(TAG, "onConnected ${call.from}")
                    Log.d(TAG, "onConnected ${call.to}")
                    Log.d(TAG, "onConnected ${call.callQualityWarnings}")
                    Log.d(TAG, "onConnected ${call.isOnHold}")
                    Log.d(TAG, "onConnected ${call.isMuted}")
                    activeCall = call
                    debug("TwilioProgrammableChatPlugin.onConnected => onConnected")
                    sendEventOnCall("onConnected", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onReconnecting(call: Call, callException: CallException) {
                    Log.d(TAG, "onReconnecting ${call.from}")
                    Log.d(TAG, "onReconnecting ${call.to}")
                    Log.d(TAG, "onReconnecting ${call.callQualityWarnings}")
                    Log.d(TAG, "onReconnecting ${call.isOnHold}")
                    Log.d(TAG, "onReconnecting ${call.isMuted}")
                    Log.d(TAG, "onReconnecting ${callException.message}")
                    debug("TwilioProgrammableChatPlugin.onReconnecting => onReconnecting")
                    sendEventOnCall("onReconnecting", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onReconnected(call: Call) {
                    Log.d(TAG, "onReconnected ${call.from}")
                    Log.d(TAG, "onReconnected ${call.to}")
                    Log.d(TAG, "onReconnected ${call.callQualityWarnings}")
                    Log.d(TAG, "onReconnected ${call.isOnHold}")
                    Log.d(TAG, "onReconnected ${call.isMuted}")
                    debug("TwilioProgrammableChatPlugin.onReconnected => onReconnected")
                    sendEventOnCall("onReconnected", mapOf("data" to Mapper.callToMap(call)))
                }

                override fun onDisconnected(call: Call, callException: CallException?) {
                    Log.d(TAG, "onDisconnected ${call.from}")
                    Log.d(TAG, "onDisconnected ${call.to}")
                    Log.d(TAG, "onDisconnected ${call.isOnHold}")
                    Log.d(TAG, "onDisconnected ${call.isMuted}")
                    debug("TwilioProgrammableChatPlugin.onDisconnected => onDisconnected")
                    sendEventOnCall("onDisconnected", mapOf("data" to Mapper.errorInfoToMap(callException)))
                }

                override fun onCallQualityWarningsChanged(call: Call, currentWarnings: MutableSet<Call.CallQualityWarning>, previousWarnings: MutableSet<Call.CallQualityWarning>) {
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.from}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.to}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.callQualityWarnings}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.isOnHold}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${call.isMuted}")
                    Log.d(TAG, "onCallQualityWarningsChanged ${currentWarnings.toString()}")
                    debug("TwilioProgrammableChatPlugin.onDisconnected => onDisconnected")
                    if (previousWarnings.size > 1)
                    {
                        val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                        currentWarnings.removeAll(previousWarnings)
                        intersection.retainAll(previousWarnings)
                        previousWarnings.removeAll(intersection)
                    }
                    sendEventOnCall("onCallQualityWarningsChanged", mapOf("data" to Mapper.callToMap(call)))
                }
            })
        }
        catch (error: Exception)
        {
            Log.d(TAG, "acceptCall: " + error.message)
        }
    }

    fun registerForNotification(call: MethodCall, result: MethodChannel.Result)
    {
        val token: String = call.argument<String>("token") ?: return result.error("MISSING_PARAMS", "The parameter 'token' was not given", null)
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error("MISSING_PARAMS", "The parameter 'accessToken' was not given", null)

        Voice.register(accessToken, Voice.RegistrationChannel.FCM, token, object : RegistrationListener {
            override fun onRegistered(accessToken: String, fcmToken: String) {
                Log.d(TAG, "Successfully Registered accessToken $accessToken fcmToken $fcmToken")
                debug("TwilioProgrammableChatPlugin.registerForNotification => registered with FCM $token")
                sendEventRegistration("registerForNotification", mapOf("result" to true))
                result.success(null)
            }

            override fun onError(registrationException: RegistrationException, accessToken: String, fcmToken: String) {
                val message = String.format(
                        Locale.US,
                        "Registration Error: %d, %s",
                        registrationException.errorCode,
                        registrationException.message)
                Log.e(TAG, message)
                Log.e(TAG, "FCM accessToken $accessToken")
                Log.e(TAG, "FCM token $fcmToken")
                debug("TwilioProgrammableChatPlugin.registerForNotification => failed to register with FCM")
                sendEventRegistration("registerForNotification", mapOf("result" to false), registrationException)
                result.error("FAILED", "Failed to register for FCM notifications", registrationException)
            }
        })
    }

    fun unregisterForNotification(call: MethodCall, result: MethodChannel.Result)
    {
        val token: String = call.argument<String>("token") ?: return result.error("MISSING_PARAMS", "The parameter 'token' was not given", null)
        val accessToken: String = call.argument<String>("accessToken") ?: return result.error("MISSING_PARAMS", "The parameter 'accessToken' was not given", null)

        Voice.unregister(accessToken, Voice.RegistrationChannel.FCM, token, object : UnregistrationListener {
            override fun onUnregistered(accessToken: String?, fcmToken: String?) {
                Log.d(TAG, "Successfully unRegistered accessToken $accessToken fcmToken $fcmToken")
                debug("TwilioVoice.unregisterForNotification => unregistered with FCM $token")
                sendEventRegistration("unregisterForNotification", mapOf("result" to true))
                result.success(null)
            }

            override fun onError(registrationException: RegistrationException, accessToken: String?, fcmToken: String?) {
                Log.d(TAG, " registrationException ${registrationException.errorCode} ${registrationException.message} accessToken $accessToken token $fcmToken")
                debug("TwilioVoice.unregisterForNotification => failed to unregister with FCM")
                sendEventRegistration("unregisterForNotification", mapOf("result" to false), registrationException)
                result.error("FAILED", "Failed to unregister for FCM notifications", registrationException)
            }
        })
    }

    private fun sendEventRegistration(name: String, data: Any?, e: RegistrationException? = null)
    {
        Log.d(TAG, "sendEventRegistration: "+data.toString())
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        notificationSink?.success(eventData)
    }

    private fun sendEventHandleMessage(name: String, data: Any?, e: CallException? = null)
    {
        Log.d(TAG, "sendEventHandleMessage: "+data.toString())
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        handleMessageSink?.success(eventData)
    }

    private fun sendEventOnCall(name: String, data: Any?, e: CallException? = null)
    {
        Log.d(TAG, "sendEventHandleMessage: "+data.toString())
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        onCallSink?.success(eventData)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding)
    {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}