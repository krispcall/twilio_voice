package com.flutter.twilio.voice

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.koushikdutta.ion.Ion
import com.twilio.voice.Call
import com.twilio.voice.CallException
import com.twilio.voice.ConnectOptions
import com.twilio.voice.Voice
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.*


/** VoicePlugin */
class VoicePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  @SuppressLint("StaticFieldLeak")
  private var instance: VoicePlugin? = null
  private var activity: Activity? = null
  private lateinit var channel : MethodChannel
  private var activeCall: Call? = null
  var registrationListener: com.twilio.voice.RegistrationListener? = null
  var callListenerFlutter = callListener()
    private val TAG = "VoicePlugin"
    private var savedAudioMode = AudioManager.MODE_INVALID
    private val audioManager: AudioManager? = null
    private val MICPERMISSIONREQUESTCODE = 1
    private val TWILIO_ACCESS_TOKEN_SERVER_URL = "TWILIO_ACCESS_TOKEN_SERVER_URL"
    private val identity = "alice"
    private lateinit var accessToken: String
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding)
  {
      if (instance == null)
      {
          instance = VoicePlugin()
      }
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "voice")
      channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
        "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
        "makeCall" -> handleMakeCall(call, result)
        else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      this.activity = binding.activity
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

        if (!checkPermissionForMicrophone())
        {
            requestPermissionForMicrophone()
        }
        else
        {
            retrieveAccessToken()
        }
        val accessTokenUrl = call.argument("accessTokenUrl") as? String
        val from = call.argument("from") as? String
        val to = call.argument("to") as? String
        val toDisplayName = call.argument("toDisplayName") as? String

        val params: HashMap<String, String?> = hashMapOf(
                "accessTokenUrl" to accessTokenUrl,
                "from" to from,
                "to" to to,
                "toDisplayName" to toDisplayName
        )


        //TODO main calling code

        val connectOptions: ConnectOptions = ConnectOptions.Builder("")
                .params(params)
                .build()
        activeCall = com.twilio.voice.Voice.connect(this@VoicePlugin.activity!!, connectOptions, callListenerFlutter)
    }

    private fun retrieveAccessToken() {
        Ion.with(this@VoicePlugin.activity!!).load("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzY29wZSI6InNjb3BlOmNsaWVudDpvdXRnb2luZz9hcHBTaWQ9Tm9uZSZjbGllbnROYW1lPXN1cHBvcnRfYWdlbnRfTm9uZSBzY29wZTpjbGllbnQ6aW5jb21pbmc_Y2xpZW50TmFtZT1zdXBwb3J0X2FnZW50X05vbmUiLCJpc3MiOiJBQzMyZDQ2ZjU5ZWE2MTk5YzA0ZTUyZWExODAwZTc5NzQ3IiwiZXhwIjoxNjA5OTE2NzU3LCJuYmYiOjE2MDk5MTMxNTd9.f6LPGk7p327iJccEySmVOr4gyqJwL3KMRMewEZXcVL0")
                .asString()
                .setCallback { e, accessToken ->
                    if (e == null) {
                        this@VoicePlugin.accessToken = accessToken
                        registerForCallInvites()
                    }
                }
    }

    private fun registerForCallInvites()
    {
        Voice.register(accessToken, Voice.RegistrationChannel.FCM, "Joshan Tandukar", registrationListener!!)
    }

    private fun checkPermissionForMicrophone(): Boolean {
        val resultMic = ContextCompat.checkSelfPermission(this@VoicePlugin.activity!!, Manifest.permission.RECORD_AUDIO)
        return resultMic == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissionForMicrophone() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this@VoicePlugin.activity!!, Manifest.permission.RECORD_AUDIO)) {
        } else {
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
          }

          override fun onConnectFailure(call: Call, error: CallException) {
              setAudioFocus(false)
              Log.d(TAG, "Connect failure")
              val message = String.format(
                      Locale.US,
                      "Call Error: %d, %s",
                      error.errorCode,
                      error.message)
              Log.e(TAG, message)
          }

          override fun onConnected(call: Call) {
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
}