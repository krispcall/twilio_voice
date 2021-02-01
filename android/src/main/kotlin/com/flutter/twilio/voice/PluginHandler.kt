package com.flutter.twilio.voice

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class PluginHandler(private val applicationContext: Context) : MethodCallHandler {
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        TwilioVoice.debug("TwilioVoice.onMethodCall => received ${call.method}")
        when (call.method) {
            "debug" -> debug(call, result)
            "create" -> create(call, result)
            "registerForNotification" -> TwilioVoice.instance.registerForNotification(call, result)
            "unregisterForNotification" -> TwilioVoice.instance.unregisterForNotification(call, result)

            "makeCall"->TwilioVoice.instance.makeCall(call,result)

            "rejectCall"->TwilioVoice.instance.rejectCall(call,result)

            "disConnect"->TwilioVoice.instance.disConnect(call,result)

            "acceptCall"->TwilioVoice.instance.acceptCall(call,result)

            "handleMessage"->TwilioVoice.instance.handleMessage(call,result)

            "ChatClient#updateToken" -> ChatClientMethods.updateToken(call, result)
            "ChatClient#shutdown" -> ChatClientMethods.shutdown(call, result)

            "User#unsubscribe" -> UserMethods.unsubscribe(call, result)

            "Users#getChannelUserDescriptors" -> UsersMethods.getChannelUserDescriptors(call, result)
            "Users#getUserDescriptor" -> UsersMethods.getUserDescriptor(call, result)
            "Users#getAndSubscribeUser" -> UsersMethods.getAndSubscribeUser(call, result)

            "Channel#join" -> ChannelMethods.join(call, result)
            "Channel#leave" -> ChannelMethods.leave(call, result)
            "Channel#typing" -> ChannelMethods.typing(call, result)
            "Channel#declineInvitation" -> ChannelMethods.declineInvitation(call, result)
            "Channel#destroy" -> ChannelMethods.destroy(call, result)
            "Channel#getMessagesCount" -> ChannelMethods.getMessagesCount(call, result)
            "Channel#getUnconsumedMessagesCount" -> ChannelMethods.getUnconsumedMessagesCount(call, result)
            "Channel#getMembersCount" -> ChannelMethods.getMembersCount(call, result)
            "Channel#setAttributes" -> ChannelMethods.setAttributes(call, result)
            "Channel#getFriendlyName" -> ChannelMethods.getFriendlyName(call, result)
            "Channel#setFriendlyName" -> ChannelMethods.setFriendlyName(call, result)
            "Channel#getNotificationLevel" -> ChannelMethods.getNotificationLevel(call, result)
            "Channel#setNotificationLevel" -> ChannelMethods.setNotificationLevel(call, result)
            "Channel#getUniqueName" -> ChannelMethods.getUniqueName(call, result)
            "Channel#setUniqueName" -> ChannelMethods.setUniqueName(call, result)

            "Channels#createChannel" -> ChannelsMethods.createChannel(call, result)
            "Channels#getChannel" -> ChannelsMethods.getChannel(call, result)
            "Channels#getPublicChannelsList" -> ChannelsMethods.getPublicChannelsList(call, result)
            "Channels#getUserChannelsList" -> ChannelsMethods.getUserChannelsList(call, result)
            "Channels#getMembersByIdentity" -> ChannelsMethods.getMembersByIdentity(call, result)

            "Member#getUserDescriptor" -> MemberMethods.getUserDescriptor(call, result)
            "Member#getAndSubscribeUser" -> MemberMethods.getAndSubscribeUser(call, result)
            "Member#setAttributes" -> MemberMethods.setAttributes(call, result)

            "Members#getMembersList" -> MembersMethods.getMembersList(call, result)
            "Members#getMember" -> MembersMethods.getMember(call, result)
            "Members#addByIdentity" -> MembersMethods.addByIdentity(call, result)
            "Members#inviteByIdentity" -> MembersMethods.inviteByIdentity(call, result)
            "Members#removeByIdentity" -> MembersMethods.removeByIdentity(call, result)

            "Message#updateMessageBody" -> MessageMethods.updateMessageBody(call, result)
            "Message#setAttributes" -> MessageMethods.setAttributes(call, result)
            "Message#getMedia" -> MessageMethods.getMedia(call, result)

            "Messages#sendMessage" -> MessagesMethods.sendMessage(call, result)
            "Messages#removeMessage" -> MessagesMethods.removeMessage(call, result)
            "Messages#getMessagesBefore" -> MessagesMethods.getMessagesBefore(call, result)
            "Messages#getMessagesAfter" -> MessagesMethods.getMessagesAfter(call, result)
            "Messages#getLastMessages" -> MessagesMethods.getLastMessages(call, result)
            "Messages#getMessageByIndex" -> MessagesMethods.getMessageByIndex(call, result)
            "Messages#setLastConsumedMessageIndexWithResult" -> MessagesMethods.setLastConsumedMessageIndexWithResult(call, result)
            "Messages#advanceLastConsumedMessageIndexWithResult" -> MessagesMethods.advanceLastConsumedMessageIndexWithResult(call, result)
            "Messages#setAllMessagesConsumedWithResult" -> MessagesMethods.setAllMessagesConsumedWithResult(call, result)
            "Messages#setNoMessagesConsumedWithResult" -> MessagesMethods.setNoMessagesConsumedWithResult(call, result)

            else -> result.notImplemented()
        }
    }

    private fun create(call: MethodCall, result: MethodChannel.Result) {
        TwilioVoice.debug("TwilioVoice.create => called")

        val token = call.argument<String>("token")
        val propertiesObj = call.argument<Map<String, Any>>("properties")
        if (token == null) {
            return result.error("ERROR", "Missing token", null)
        }
        if (propertiesObj == null) {
            return result.error("ERROR", "Missing properties", null)
        }
    }

    private fun debug(call: MethodCall, result: MethodChannel.Result) {
        val enableNative = call.argument<Boolean>("native")
        val enableSdk = call.argument<Boolean>("sdk")

        if (enableNative != null) {
            TwilioVoice.nativeDebug = enableNative
            result.success(enableNative)
        } else {
            result.error("MISSING_PARAMS", "Missing 'native' parameter", null)
        }
    }
}
