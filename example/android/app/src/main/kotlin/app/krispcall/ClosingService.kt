package app.krispcall

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.util.Log
import com.flutter.twilio.voice.TwilioVoice

class ClosingService : Service() {

    private val TAG = ClosingService::class.java.simpleName
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "onTaskRemoved------------------------------0")
        try {

            TwilioVoice.instance.disConnect()
            TwilioVoice.instance.disConnect()

            val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
            val incoming = "flutter.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS"
            val outgoing = "flutter.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS"
            val prefs = Application.context.getSharedPreferences(
                SHARED_PREFERENCES_NAME,
                Context.MODE_PRIVATE
            )
            prefs.edit().putBoolean(incoming, false).apply()
            prefs.edit().putBoolean(outgoing, false).apply()
            stopSelf()

        } catch (e: Exception) {

        }
        super.onTaskRemoved(rootIntent)
        Log.d(TAG, "onTaskRemoved------------------------------1")
        try {
            val nManager: NotificationManager =
                Application.context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            val intent = Intent(
                Application.context,
                ClosingService::class.java
            )
            stopService(intent)
            nManager.cancelAll()
        } catch (e: Exception) {

        }
    }
}
