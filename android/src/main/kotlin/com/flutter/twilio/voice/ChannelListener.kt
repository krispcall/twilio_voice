package com.flutter.twilio.voice

import com.twilio.chat.Channel
import com.twilio.chat.ErrorInfo
import com.twilio.chat.Member
import com.twilio.chat.Message
import com.twilio.chat.ChannelListener as TwilioChannelListener
import io.flutter.plugin.common.EventChannel

class ChannelListener(private val events: EventChannel.EventSink) : TwilioChannelListener {
    override fun onMessageAdded(message: Message) {
        TwilioVoice.debug("ChannelListener.onMessageAdded => messageSid = ${message.sid}")
        sendEvent("messageAdded", mapOf("message" to Mapper.messageToMap(message)))
    }

    override fun onMessageUpdated(message: Message, reason: Message.UpdateReason) {
        TwilioVoice.debug("ChannelListener.onMessageUpdated => messageSid = ${message.sid}, reason = $reason")
        sendEvent("messageUpdated", mapOf(
                "message" to Mapper.messageToMap(message),
                "reason" to mapOf(
                        "type" to "message",
                        "value" to reason.toString()
                )
        ))
    }

    override fun onMessageDeleted(message: Message) {
        TwilioVoice.debug("ChannelListener.onMessageDeleted => messageSid = ${message.sid}")
        sendEvent("messageDeleted", mapOf("message" to Mapper.messageToMap(message)))
    }

    override fun onMemberAdded(member: Member) {
        TwilioVoice.debug("ChannelListener.onMemberAdded => memberSid = ${member.sid}")
        sendEvent("memberAdded", mapOf("member" to Mapper.memberToMap(member)))
    }

    override fun onMemberUpdated(member: Member, reason: Member.UpdateReason) {
        TwilioVoice.debug("ChannelListener.onMemberUpdated => memberSid = ${member.sid}, reason = $reason")
        sendEvent("memberUpdated", mapOf(
                "member" to Mapper.memberToMap(member),
                "reason" to mapOf(
                        "type" to "member",
                        "value" to reason.toString()
                )
        ))
    }

    override fun onMemberDeleted(member: Member) {
        TwilioVoice.debug("ChannelListener.onMemberDeleted => memberSid = ${member.sid}")
        sendEvent("memberDeleted", mapOf("member" to Mapper.memberToMap(member)))
    }

    override fun onTypingStarted(channel: Channel, member: Member) {
        TwilioVoice.debug("ChannelListener.onTypingStarted => channelSid = ${channel.sid}, memberSid = ${member.sid}")
        sendEvent("typingStarted", mapOf("channel" to Mapper.channelToMap(channel), "member" to Mapper.memberToMap(member)))
    }

    override fun onTypingEnded(channel: Channel, member: Member) {
        TwilioVoice.debug("ChannelListener.onTypingEnded => channelSid = ${channel.sid}, memberSid = ${member.sid}")
        sendEvent("typingEnded", mapOf("channel" to Mapper.channelToMap(channel), "member" to Mapper.memberToMap(member)))
    }

    override fun onSynchronizationChanged(channel: Channel) {
        TwilioVoice.debug("ChannelListener.onSynchronizationChanged => channelSid = ${channel.sid}")
        sendEvent("synchronizationChanged", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        events.success(eventData)
    }
}
