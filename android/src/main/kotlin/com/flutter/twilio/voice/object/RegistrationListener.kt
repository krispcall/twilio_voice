package com.flutter.twilio.voice.events

import android.util.Log
import com.twilio.voice.RegistrationException
import com.twilio.voice.RegistrationListener
import java.util.*

const val TAG = "RegistrationListener";
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
//RegistrationListener
//{
//    fun onRegistered(accessToken: String, fcmToken: String) {
//        Log.d(TAG, "Successfully registered accessToken $accessToken")
//        Log.d(TAG, "Successfully registered fcmToken $fcmToken")
//    }
//
//    fun onError(error: RegistrationException,
//                         accessToken: String,
//                         fcmToken: String) {
//        val message = String.format(
//                Locale.US,
//                "Registration Error: %d, %s",
//                error.errorCode,
//                error.message)
//        Log.e(TAG, message)
//        Log.e(TAG, "FCM accessToken $accessToken")
//        Log.e(TAG, "FCM token $fcmToken")
//    }
//}