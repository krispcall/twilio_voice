package app.krispcall

import android.content.Context
import com.google.firebase.FirebaseApp
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import com.facebook.stetho.Stetho

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    companion object {
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(ActivityLifecycleListener)
        FirebaseApp.initializeApp(this)
        FlutterMain.startInitialization(this)
        context = applicationContext
        Stetho.initializeWithDefaults(this)

    }

    override fun registerWith(registry: PluginRegistry?) {
        TwilioVoicePluginRegistrant.registerWith(registry!!)
        SharedPreferencePluginRegistrant.registerWith(registry)
        InCallManagerPluginRegistrant.registerWith(registry)
        FlutterToastPluginRegistrant.registerWith(registry)
        AudioManagerPluginRegistrant.registerWith(registry)
        AwesomeNotificationPluginRegistrant.registerWith(registry)
    }
}
