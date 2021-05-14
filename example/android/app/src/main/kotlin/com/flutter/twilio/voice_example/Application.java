package com.flutter.twilio.voice_example;

import com.google.firebase.FirebaseApp;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate()
    {
        super.onCreate();
        FirebaseApp.initializeApp(this);
    }
    
    @Override
    public void registerWith(PluginRegistry registry) {
        AwesomePluginRegistrant.registerWith(registry);
        TwilioVoicePluginRegistrant.registerWith(registry);
    }
}