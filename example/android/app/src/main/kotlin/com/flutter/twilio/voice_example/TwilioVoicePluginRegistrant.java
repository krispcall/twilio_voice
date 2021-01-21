package com.flutter.twilio.voice_example;

import com.flutter.twilio.voice.TwilioVoice;

import io.flutter.plugin.common.PluginRegistry;

public final class TwilioVoicePluginRegistrant{
    public static void registerWith(PluginRegistry registry)
    {
        if (alreadyRegisteredWith(registry))
        {
            return;
        }
        TwilioVoice.registerWith(registry.registrarFor("com.flutter.twilio.voice"));
    }

    private static boolean alreadyRegisteredWith(PluginRegistry registry)
    {
        final String key = TwilioVoicePluginRegistrant.class.getCanonicalName();
        if (registry.hasPlugin(key))
        {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }
}