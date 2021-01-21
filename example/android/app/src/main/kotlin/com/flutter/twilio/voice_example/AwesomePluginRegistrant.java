package com.flutter.twilio.voice_example;

import io.flutter.plugin.common.PluginRegistry;
import me.carda.awesome_notifications.AwesomeNotificationsPlugin;

public final class AwesomePluginRegistrant{
    public static void registerWith(PluginRegistry registry)
    {
        if (alreadyRegisteredWith(registry))
        {
            return;
        }
        AwesomeNotificationsPlugin.registerWith(registry.registrarFor("me.carda.awesome_notifications.AwesomeNotificationsPlugin"));
    }

    private static boolean alreadyRegisteredWith(PluginRegistry registry)
    {
        final String key = AwesomePluginRegistrant.class.getCanonicalName();
        if (registry.hasPlugin(key))
        {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }
}