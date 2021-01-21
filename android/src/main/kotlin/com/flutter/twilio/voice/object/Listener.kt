package com.flutter.twilio.voice.`object`

import android.util.Log
import com.twilio.voice.Call
import com.twilio.voice.Call.CallQualityWarning
import com.twilio.voice.CallException
import com.twilio.voice.RegistrationException
import com.twilio.voice.RegistrationListener
import java.util.*

const val TAG = "Listener";
fun callListener(): Call.Listener {
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
            Log.d(TAG, "Connect failure")
            val message = String.format(
                    Locale.US,
                    "Call Error: %d, %s",
                    error.errorCode,
                    error.message)
        }

        override fun onConnected(call: Call) {
//            audioSwitch.activate()
//            SoundPoolManager.getInstance(this@VoiceActivity).stopRinging()
//            Log.d(TAG, "Connected")
//            activeCall = call
        }

        override fun onReconnecting(call: Call, callException: CallException) {
            Log.d(TAG, "onReconnecting")
        }

        override fun onReconnected(call: Call) {
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
                                                  currentWarnings: MutableSet<CallQualityWarning>,
                                                  previousWarnings: MutableSet<CallQualityWarning>) {
            if (previousWarnings.size > 1) {
                val intersection: MutableSet<CallQualityWarning> = HashSet(currentWarnings)
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

fun registrationListener() : RegistrationListener {
    return object : RegistrationListener {
        override fun onRegistered(accessToken: String, fcmToken: String) {
            Log.d(TAG, "Successfully registered accessToken $accessToken")
            Log.d(TAG, "Successfully registered fcmToken $fcmToken")
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
            Log.e(TAG, "FCM accessToken $accessToken")
            Log.e(TAG, "FCM token $fcmToken")
        }
    }
}