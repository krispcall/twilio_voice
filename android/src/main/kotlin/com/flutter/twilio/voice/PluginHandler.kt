package com.flutter.twilio.voice

import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class PluginHandler : MethodCallHandler
{
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "create" -> create(call, result)
            "registerForNotification" -> TwilioVoice.instance.registerForNotification(call, result)
            "unregisterForNotification" -> TwilioVoice.instance.unregisterForNotification(call, result)

            "makeCallWithSid"->TwilioVoice.instance.makeCallWithSid(call,result)

            "rejectCall"->TwilioVoice.instance.rejectCall()

            "disConnect"->TwilioVoice.instance.disConnect()

            "mute"->TwilioVoice.instance.mute()

            "hold"->TwilioVoice.instance.hold()

            "acceptCall"->TwilioVoice.instance.acceptCall()

            "sendDigit"->TwilioVoice.instance.sendDigit(call, result)

            "handleMessage"->TwilioVoice.instance.handleMessage(call)

            else -> result.notImplemented()
        }
    }

    private fun create(call: MethodCall, result: MethodChannel.Result) {

        val token = call.argument<String>("token")
        val propertiesObj = call.argument<Map<String, Any>>("properties")

        if (token == null) {
            return result.error("ERROR", "Missing token", null)
        }
        if (propertiesObj == null) {
            return result.error("ERROR", "Missing properties", null)
        }
    }
}
