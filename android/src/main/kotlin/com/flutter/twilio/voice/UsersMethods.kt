package com.flutter.twilio.voice

import com.twilio.chat.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object UsersMethods {
    fun getChannelUserDescriptors(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.users?.getChannelUserDescriptors(channelSid, object : CallbackListener<Paginator<UserDescriptor>>() {
            override fun onSuccess(paginator: Paginator<UserDescriptor>) {
                TwilioVoice.debug("UsersMethods.getChannelUserDescriptors => onSuccess")
                val pageId = PaginatorManager.setPaginator(paginator)
                result.success(Mapper.paginatorToMap(pageId, paginator, "userDescriptor"))
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("UsersMethods.getChannelUserDescriptors => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getUserDescriptor(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioVoice.chatClient?.users?.getUserDescriptor(identity, object : CallbackListener<UserDescriptor>() {
            override fun onSuccess(userDescriptor: UserDescriptor) {
                TwilioVoice.debug("UsersMethods.getUserDescriptor => onSuccess")
                result.success(Mapper.userDescriptorToMap(userDescriptor))
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("UsersMethods.getUserDescriptor => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getAndSubscribeUser(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioVoice.chatClient?.users?.getAndSubscribeUser(identity, object : CallbackListener<User>() {
            override fun onSuccess(user: User) {
                TwilioVoice.debug("UsersMethods.getAndSubscribeUser => onSuccess")
                result.success(Mapper.userToMap(user))
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("UsersMethods.getAndSubscribeUser => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }
}
