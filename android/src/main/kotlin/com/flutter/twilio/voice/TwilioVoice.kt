package com.flutter.twilio.voice

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import com.twilio.chat.ChannelListener
import com.twilio.chat.ChatClient
import com.twilio.chat.ErrorInfo
import com.twilio.chat.StatusListener
import com.twilio.voice.*
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

        var handler = Handler(Looper.getMainLooper())

        var nativeDebug: Boolean = false

        lateinit var chatListener: ChatListener

        var channelChannels: HashMap<String, EventChannel> = hashMapOf()
        var channelListeners: HashMap<String, ChannelListener> = hashMapOf()

        @JvmStatic
        lateinit var applicationContext: Context

        private var activeCall: Call? = null

        private var activeCallInvite: CallInvite? = null

        private var cancelledCallIvites: CancelledCallInvite? = null

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
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Chat eventChannel attached")
                chatListener.events = events
                chatClient?.setListener(chatListener)
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Chat eventChannel detached")
                chatListener.events = null
            }
        })

        mediaProgressChannel = EventChannel(messenger, "TwilioVoice/media_progress")
        mediaProgressChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => MediaProgress eventChannel attached")
                mediaProgressSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => MediaProgress eventChannel detached")
                mediaProgressSink = null
            }
        })

        loggingChannel = EventChannel(messenger, "TwilioVoice/logging")
        loggingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Logging eventChannel attached")
                loggingSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Logging eventChannel detached")
                loggingSink = null
            }
        })

        notificationChannel = EventChannel(messenger, "TwilioVoice/notification")
        notificationChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Notification eventChannel attached")
                notificationSink = events
            }

            override fun onCancel(arguments: Any) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => Notification eventChannel detached")
                notificationSink = null
            }
        })

        handleMessageChannel = EventChannel(messenger, "TwilioVoice/handleMessage")
        handleMessageChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => handleMessage eventChannel attached")
                handleMessageSink = events
            }

            override fun onCancel(arguments: Any) {
                debug("TwilioProgrammableChatPlugin.onAttachedToEngine => handleMessage eventChannel detached")
                handleMessageSink = null
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
            activeCall = Voice.connect(applicationContext, connectOptions, callListener())

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
        Log.d(TAG, "handleMessage kt: " + call.argument("notification"))
        val notification = call.argument("notification") as? Map<String, Any>

        val bundle=createBundleFromMap(notification)
        Voice.handleMessage(applicationContext, bundle!!, object : MessageListener {
            override fun onCallInvite(callInvite: CallInvite)
            {
                Log.d(TAG, "onCallInvite: "+callInvite.callSid)
                Log.d(TAG, "onCallInvite: "+callInvite.callerInfo)
                Log.d(TAG, "onCallInvite: "+callInvite.to)
                Log.d(TAG, "onCallInvite: "+callInvite.from)
                Log.d(TAG, "onCallInvite: "+callInvite.customParameters.toString())
                Log.d(TAG, "onCallInvite: "+mapOf("data" to Mapper.callInviteToMap(callInvite)))

                activeCallInvite = callInvite
                debug("TwilioProgrammableChatPlugin.handleMessage => handleMessage onCallInvite ${callInvite.from}")
                sendEventHandleMessage("onCallInvite", mapOf("data" to Mapper.callInviteToMap(callInvite)))
                result.success(Mapper.callInviteToMap(callInvite))
            }

            override fun onCancelledCallInvite(cancelledCallInvite: CancelledCallInvite, @Nullable callException: CallException?)
            {
                Log.d(TAG, "onCancelledCallInvite: "+cancelledCallInvite.callSid)
                Log.d(TAG, "onCancelledCallInvite: "+cancelledCallInvite.to)
                Log.d(TAG, "onCancelledCallInvite: "+cancelledCallInvite.from)
                Log.d(TAG, "onCancelledCallInvite: "+cancelledCallInvite.customParameters.toString())
                Log.d(TAG, "onCallInvite: "+mapOf("data" to Mapper.cancelledCallInviteToMap(cancelledCallInvite)))
                cancelledCallIvites = cancelledCallInvite
                debug("TwilioProgrammableChatPlugin.handleMessage => handleMessage onCancelledCallInvite ${cancelledCallInvite.from}")
                sendEventHandleMessage("onCancelledCallInvite", mapOf("data" to Mapper.cancelledCallInviteToMap(cancelledCallInvite)))
                result.success(Mapper.cancelledCallInviteToMap(cancelledCallInvite))
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
            activeCallInvite?.accept(applicationContext, callListener())
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
                Log.d(TAG, "Successfully Registered accessToken $accessToken")
                Log.d(TAG, "Successfully Registered fcmToken $fcmToken")
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
                Log.d(TAG, "Successfully unRegistered accessToken $accessToken")
                Log.d(TAG, "Successfully unRegistered fcmToken $fcmToken")
                debug("TwilioVoice.unregisterForNotification => unregistered with FCM $token")
                sendEventRegistration("unregisterForNotification", mapOf("result" to true))
                result.success(null)
            }

            override fun onError(registrationException: RegistrationException, accessToken: String?, fcmToken: String?) {
                val message = String.format(
                        Locale.US,
                        "Registration Error: %d, %s",
                        registrationException.errorCode,
                        registrationException.message)
                Log.e(TAG, message)
                Log.e(TAG, "FCM accessToken $accessToken")
                Log.e(TAG, "FCM token $fcmToken")
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

    private fun callListener(): Call.Listener
    {
        return object : Call.Listener
        {
            /*
                 * This callback is emitted once before the Call.Listener.onConnected() callback when
                 * the callee is being alerted of a Call. The behavior of this callback is determined by
                 * the answerOnBridge flag provided in the Dial verb of your TwiML application
                 * associated with this client. If the answerOnBridge flag is false, which is the
                 * default, the Call.Listener.onConnected() callback will be emitted immediately after
                 * Call.Listener.onRinging(). If the answerOnBridge flag is true, this will cause the
                 * call to emit the onConnected callback only after the call is answered.
                 * See answeronbridge for more details on how to use it with the Dial TwiML verb. If the
                 * twiML response contains a Say verb, then the call will emit the
                 * Call.Listener.onConnected callback immediately after Call.Listener.onRinging() is
                 * raised, irrespective of the value of answerOnBridge being set to true or false
                 */
            override fun onRinging(call: Call)
            {
                Log.d(TAG, "Ringing")
                /*
                     * When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge)
                     * is enabled in the <Dial> TwiML verb, the caller will not hear the ringback while
                     * the call is ringing and awaiting to be accepted on the callee's side. The application
                     * can use the `SoundPoolManager` to play custom audio files between the
                     * `Call.Listener.onRinging()` and the `Call.Listener.onConnected()` callbacks.*/
//                 SoundPoolManager.getInstance(this@VoiceActivity).playRinging()
            }

            override fun onConnectFailure(call: Call, error: CallException)
            {
//            audioSwitch.deactivate()
//            SoundPoolManager.getInstance(this@VoiceActivity).stopRinging()
                val message = String.format(
                        Locale.US,
                        "Call Error: %d, %s",
                        error.errorCode,
                        error.message)
                Log.d(TAG, "Connect failure $message")
            }

            override fun onConnected(call: Call)
            {
//            audioSwitch.activate()
//            SoundPoolManager.getInstance(this@VoiceActivity).stopRinging()
//            Log.d(TAG, "Connected")
                activeCall = call
            }

            override fun onReconnecting(call: Call, callException: CallException) {
                Log.d(TAG, "onReconnecting")
            }

            override fun onReconnected(call: Call)
            {
                Log.d(TAG, "onReconnected")
            }

            override fun onDisconnected(call: Call, error: CallException?) {
//            audioSwitch.deactivate()
//            SoundPoolManager.getInstance(this@VoiceActivity).stopRinging()
                Log.d(TAG, "Disconnected")
                if (error != null) {
                    val message = String.format(
                            Locale.US,
                            "Call Error: %d, %s",
                            error.errorCode,
                            error.message)
                    Log.e(TAG, message)
                }
            }

            /*
                 * currentWarnings: existing quality warnings that have not been cleared yet
                 * previousWarnings: last set of warnings prior to receiving this callback
                 *
                 * Example:
                 *   - currentWarnings: { A, B }
                 *   - previousWarnings: { B, C }
                 *
                 * Newly raised warnings = currentWarnings - intersection = { A }
                 * Newly cleared warnings = previousWarnings - intersection = { C }
                 */
            override fun onCallQualityWarningsChanged(call: Call,
                                                      currentWarnings: MutableSet<Call.CallQualityWarning>,
                                                      previousWarnings: MutableSet<Call.CallQualityWarning>) {
                if (previousWarnings.size > 1) {
                    val intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
                    currentWarnings.removeAll(previousWarnings)
                    intersection.retainAll(previousWarnings)
                    previousWarnings.removeAll(intersection)
                }
                val message = String.format(
                        Locale.US,
                        "Newly raised warnings: $currentWarnings Clear warnings $previousWarnings")
                Log.e(TAG, message)
            }
        }
    }
}