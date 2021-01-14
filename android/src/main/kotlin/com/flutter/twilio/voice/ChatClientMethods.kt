package com.flutter.twilio.voice

import com.flutter.twilio.voice.TwilioVoice
import com.twilio.chat.ErrorInfo
import com.twilio.chat.StatusListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object ChatClientMethods {
    fun updateToken(call: MethodCall, result: MethodChannel.Result) {
        val token = call.argument<String>("token")
                ?: return result.error("ERROR", "Missing 'token'", null)

        TwilioVoice.chatClient?.updateToken(token, object : StatusListener() {
            override fun onSuccess() {
                TwilioVoice.debug("ChatClientMethods.updateToken => onSuccess")
                result.success(null)
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("ChatClientMethods.updateToken => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun shutdown(call: MethodCall, result: MethodChannel.Result) {
        return try {
            TwilioVoice.chatClient?.shutdown()
            result.success(null)
        } catch (err: Exception) {
            result.error("ERROR", err.message, null)
        }
    }
}
