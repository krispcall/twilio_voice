package com.flutter.twilio.voice

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.app.NotificationManager
import android.content.*
import android.content.Intent.getIntent
import android.content.Intent.parseUri
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ProcessLifecycleOwner
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.twilio.voice.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.*


/** VoicePlugin */
class VoicePlugin: FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  @SuppressLint("StaticFieldLeak")
  private var instance: VoicePlugin? = null
  private var activity: Activity? = null
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var activeCall: Call? = null
  var registrationListener = registrationListener()
  var callListenerFlutter = callListener()
  private var isReceiverRegistered = false
    private val voiceBroadcastReceiver: VoiceBroadcastReceiver? = null
    private var alertDialog: AlertDialog? = null
    private var notificationManager: NotificationManager? = null
    private var eventSink: EventChannel.EventSink? = null
    private val TAG = "VoicePlugin"
    private val audioManager: AudioManager? = null
    private val MICPERMISSIONREQUESTCODE = 1
    private var activeCallInvite: CallInvite? = null
    private var activeCallNotificationId = 0
    private lateinit var fcmToken:String
    private lateinit var accessToken:String

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding)
  {
      Log.d(TAG, "onAttachedToEngine: ")
      if (instance == null)
      {
          instance = VoicePlugin()
      }
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "voice")
//      channel.setMethodCallHandler(this)
//      eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "voice")
//      eventChannel.setStreamHandler(instance)

      registerReceiver()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
      Log.d(TAG, "onMethodCall: " + call.method)
    when (call.method) {
        "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
        "makeCall" -> handleMakeCall(call, result)
        "receiveCalls" -> handleReceiveCalls(call, result)
        else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
      Log.d(TAG, "onDetachedFromEngine: ")
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      Log.d(TAG, "onAttachedToActivity: ")
      notificationManager = activity?.applicationContext?.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      this.activity = binding.activity
      if (!checkPermissionForMicrophone())
      {
          requestPermissionForMicrophone()
      }
      else
      {
          registerForCallInvites()
      }
  }

  override fun onDetachedFromActivityForConfigChanges()
  {
      activity=null
      SoundPoolManager.getInstance(this@VoicePlugin.activity!!)!!.release()
  }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        activity = null
        SoundPoolManager.getInstance(this@VoicePlugin.activity!!)!!.release()
    }

    private fun handleMakeCall(call: MethodCall, result: MethodChannel.Result)
    {

        val accessTokenUrl = call.argument("accessTokenUrl") as? String
        val from = call.argument("from") as? String
        val to = call.argument("To") as? String
        val toDisplayName = call.argument("toDisplayName") as? String
        this.fcmToken = (call.argument("fcmToken") as? String).toString()
        this.accessToken = (call.argument("accessTokenUrl") as? String).toString()

        if (!checkPermissionForMicrophone())
        {
            requestPermissionForMicrophone()
        }
        else
        {
            registerForCallInvites()
        }

        val params: HashMap<String, String?> = hashMapOf(
                "To" to to,
                "toDisplayName" to toDisplayName
        )

        //TODO main calling code

        val connectOptions: ConnectOptions = ConnectOptions.Builder(accessTokenUrl!!)
                .params(params)
                .build()
        activeCall = Voice.connect(this@VoicePlugin.activity!!, connectOptions, callListenerFlutter)
    }

    private fun handleReceiveCalls(call: MethodCall, result: MethodChannel.Result)
    {
        val clientIdentity = call.argument("clientIdentifier") as? String
        Log.d(TAG, "handleReceiveCalls: " + clientIdentity.toString())
    }

    private fun registerForCallInvites()
    {
        Voice.register(this.accessToken, Voice.RegistrationChannel.FCM, this.fcmToken, registrationListener!!)
    }

    private fun checkPermissionForMicrophone(): Boolean {
        val resultMic = ContextCompat.checkSelfPermission(this@VoicePlugin.activity!!, Manifest.permission.RECORD_AUDIO)
        return resultMic == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissionForMicrophone() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this@VoicePlugin.activity!!, Manifest.permission.RECORD_AUDIO))
        {
        }
        else
        {
            ActivityCompat.requestPermissions(
                    this@VoicePlugin.activity!!, arrayOf(Manifest.permission.RECORD_AUDIO),
                    MICPERMISSIONREQUESTCODE)
        }
    }

    private fun callListener(): Call.Listener {
        return object : Call.Listener {
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
                SoundPoolManager.getInstance(activity!!.applicationContext)!!.playRinging()
            }

            override fun onConnectFailure(call: Call, error: CallException) {
                SoundPoolManager.getInstance(activity!!.applicationContext)!!.stopRinging()
                setAudioFocus(false)
                Log.d(TAG, "Connect failure")
                val message = String.format(
                        Locale.US,
                        "Call Error: %d, %s",
                        error.errorCode,
                        error.toString(),
                        error.message)
                Log.e(TAG, message)
            }

            override fun onConnected(call: Call) {
                SoundPoolManager.getInstance(activity!!.applicationContext)!!.stopRinging()
                setAudioFocus(true)
                Log.d(TAG, "Connected " + call.sid)
                activeCall = call
            }

            override fun onReconnecting(call: Call, callException: CallException) {
                Log.d(TAG, "onReconnecting")
            }

            override fun onReconnected(call: Call) {
                Log.d(TAG, "onReconnected")
            }

            override fun onDisconnected(call: Call, error: CallException?) {
                SoundPoolManager.getInstance(activity!!.applicationContext)!!.stopRinging()
                setAudioFocus(false)
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
        }
    }

    private fun registrationListener(): RegistrationListener? {
        return object : RegistrationListener {
            override fun onRegistered(accessToken: String, token: String)
            {
                Log.d(TAG, "Successfully registered FCM $token")
                Log.d(TAG, "Successfully registered access token $accessToken")
            }

            override fun onError(error: RegistrationException,
                                 accessToken: String,
                                 fcmToken: String) {
                val message = String.format(
                        Locale.US,
                        "Registration Error: %d, %s",
                        error.errorCode,
                        error.message)
                Log.e(TAG, message)
            }
        }
    }

    private fun setAudioFocus(setFocus: Boolean) {
        if (audioManager != null) {
            if (setFocus) {
//                savedAudioMode = audioManager.getMode() TODO
                // Request audio focus before making any device switch.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val playbackAttributes = AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                            .build()
                    val focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                            .setAudioAttributes(playbackAttributes)
                            .setAcceptsDelayedFocusGain(true)
                            .setOnAudioFocusChangeListener { i: Int -> }
                            .build()
                    audioManager.requestAudioFocus(focusRequest)
                } else {
                    audioManager.requestAudioFocus(
                            AudioManager.OnAudioFocusChangeListener { },
                            AudioManager.STREAM_VOICE_CALL,
                            AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                }
                /*
                 * Start by setting MODE_IN_COMMUNICATION as default audio mode. It is
                 * required to be in this mode when playout and/or recording starts for
                 * best possible VoIP performance. Some devices have difficulties with speaker mode
                 * if this is not set.
                 */audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
            } else {
//                audioManager.mode = savedAudioMode TODO
                audioManager.abandonAudioFocus(null)
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?)
    {
        Log.d(TAG, "Broad Cast Call")
        this.eventSink = events!!
    }

    override fun onCancel(arguments: Any?)
    {
        unregisterReceiver()
    }

    private class VoiceBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            Log.d(VoicePlugin().TAG, "onReceive: ")
            val action = intent.action
            if (action != null && (action == Constants.ACTION_INCOMING_CALL || action == Constants.ACTION_CANCEL_CALL))
            {
                VoicePlugin().handleIncomingCallIntent(intent)
            }
        }
    }

    private fun registerReceiver() {
        Log.d(TAG, "registerReceiver: ")
        if (!isReceiverRegistered)
        {
            val intentFilter = IntentFilter()
            intentFilter.addAction(Constants.ACTION_INCOMING_CALL)
            intentFilter.addAction(Constants.ACTION_CANCEL_CALL)
            intentFilter.addAction(Constants.ACTION_FCM_TOKEN)
            voiceBroadcastReceiver?.let { LocalBroadcastManager.getInstance(this.activity!!.applicationContext).registerReceiver(it, intentFilter) }
            isReceiverRegistered = true
        }
    }

    private fun unregisterReceiver() {
        Log.d(TAG, "unregisterReceiver: ")
        if (isReceiverRegistered) {
            voiceBroadcastReceiver?.let { LocalBroadcastManager.getInstance(this.activity!!.applicationContext).unregisterReceiver(it) }
            isReceiverRegistered = false
        }
    }

     fun handleIncomingCallIntent(intent: Intent?) {
        if (intent != null && intent.action != null) {
            val action = intent.action
            activeCallInvite = intent.getParcelableExtra(Constants.INCOMING_CALL_INVITE)
            activeCallNotificationId = intent.getIntExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, 0)
            when (action) {
                Constants.ACTION_INCOMING_CALL -> handleIncomingCall()
                Constants.ACTION_INCOMING_CALL_NOTIFICATION -> showIncomingCallDialog()
                Constants.ACTION_CANCEL_CALL -> handleCancel()
                Constants.ACTION_FCM_TOKEN -> registerForCallInvites()
                Constants.ACTION_ACCEPT -> answer()
                else -> {
                }
            }
        }
    }

    private fun handleIncomingCall() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            showIncomingCallDialog()
        } else {
            if (isAppVisible()) {
                showIncomingCallDialog()
            }
        }
    }

    private fun showIncomingCallDialog() {
        SoundPoolManager.getInstance(this.activity!!.applicationContext)!!.playRinging()
        if (activeCallInvite != null) {
            alertDialog = createIncomingCallDialog(this.activity!!.applicationContext,
                    activeCallInvite!!,
                    answerCallClickListener(),
                    cancelCallClickListener())
            alertDialog?.show()
        }
    }

    private fun isAppVisible(): Boolean {
        return ProcessLifecycleOwner
                .get()
                .lifecycle
                .currentState
                .isAtLeast(Lifecycle.State.STARTED)
    }

    private fun handleCancel() {
        if (alertDialog != null && alertDialog!!.isShowing) {
            SoundPoolManager.getInstance(this.activity!!.applicationContext)!!.stopRinging()
            alertDialog!!.cancel()
        }
    }

    private fun answer() {
        SoundPoolManager.getInstance(this.activity!!.applicationContext)!!.stopRinging()
        activeCallInvite!!.accept(this.activity!!.applicationContext, callListener())
        notificationManager?.cancel(activeCallNotificationId)
        if (alertDialog != null && alertDialog!!.isShowing) {
            alertDialog!!.dismiss()
        }
    }

    private fun createIncomingCallDialog(context: Context?, callInvite: CallInvite, answerCallClickListener: DialogInterface.OnClickListener?, cancelClickListener: DialogInterface.OnClickListener?): AlertDialog?
    {
        val alertDialogBuilder = AlertDialog.Builder(context)
        alertDialogBuilder.setIcon(R.drawable.ic_call_black_24dp)
        alertDialogBuilder.setTitle("Incoming Call")
        alertDialogBuilder.setPositiveButton("Accept", answerCallClickListener)
        alertDialogBuilder.setNegativeButton("Reject", cancelClickListener)
        alertDialogBuilder.setMessage(callInvite.from + " is calling with " + callInvite.callerInfo.isVerified + " status")
        return alertDialogBuilder.create()
    }

    private fun answerCallClickListener(): DialogInterface.OnClickListener? {
        return DialogInterface.OnClickListener { dialog: DialogInterface?, which: Int ->
            Log.d(TAG, "Clicked accept")
            val acceptIntent = Intent(this.activity!!.applicationContext, IncomingCallNotificationService::class.java)
            acceptIntent.action = Constants.ACTION_ACCEPT
            acceptIntent.putExtra(Constants.INCOMING_CALL_INVITE, activeCallInvite)
            acceptIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, activeCallNotificationId)
            Log.d(TAG, "Clicked accept startService")
            this.activity!!.applicationContext.startService(acceptIntent)
        }
    }

    private fun cancelCallClickListener(): DialogInterface.OnClickListener? {
        return DialogInterface.OnClickListener { dialogInterface: DialogInterface?, i: Int ->
            SoundPoolManager.getInstance(this.activity!!.applicationContext)!!.stopRinging()
            if (activeCallInvite != null) {
                val intent = Intent(this.activity!!.applicationContext, IncomingCallNotificationService::class.java)
                intent.action = Constants.ACTION_REJECT
                intent.putExtra(Constants.INCOMING_CALL_INVITE, activeCallInvite)
                this.activity!!.applicationContext.startService(intent)
            }
            if (alertDialog != null && alertDialog!!.isShowing) {
                alertDialog!!.dismiss()
            }
        }
    }
}