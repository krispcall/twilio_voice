package com.flutter.twilio.voice

import com.twilio.chat.*
import io.flutter.plugin.common.EventChannel

class ChatListener(val properties: ChatClient.Properties) : ChatClientListener {
    var events: EventChannel.EventSink? = null

    override fun onAddedToChannelNotification(channelSid: String) {
        TwilioVoice.debug("ChatListener.onAddedToChannelNotification => channelSid = $channelSid")
        sendEvent("addedToChannelNotification", mapOf("channelSid" to channelSid))
    }

    override fun onChannelAdded(channel: Channel) {
        TwilioVoice.debug("ChatListener.onChannelAdded => sid = ${channel.sid}")
        sendEvent("channelAdded", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    override fun onChannelDeleted(channel: Channel) {
        TwilioVoice.debug("ChatListener.onChannelDeleted => sid = ${channel.sid}")
        sendEvent("channelDeleted", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    override fun onChannelInvited(channel: Channel) {
        TwilioVoice.debug("ChatListener.onChannelInvited => sid = ${channel.sid}")
        sendEvent("channelInvited", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    override fun onChannelJoined(channel: Channel) {
        TwilioVoice.debug("ChatListener.onChannelJoined => sid = ${channel.sid}")
        sendEvent("channelJoined", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    override fun onChannelSynchronizationChange(channel: Channel) {
        TwilioVoice.debug("ChatListener.onChannelSynchronizationChange => sid = ${channel.sid}")
        sendEvent("channelSynchronizationChange", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    override fun onChannelUpdated(channel: Channel, reason: Channel.UpdateReason) {
        TwilioVoice.debug("ChatListener.onChannelUpdated => channel '${channel.sid}' updated, $reason")
        sendEvent("channelUpdated", mapOf(
                "channel" to Mapper.channelToMap(channel),
                "reason" to mapOf(
                    "type" to "channel",
                    "value" to reason.toString()
                )
        ))
    }

    override fun onClientSynchronization(synchronizationStatus: ChatClient.SynchronizationStatus) {
        TwilioVoice.debug("ChatListener.onClientSynchronization => status = $synchronizationStatus")
        sendEvent("clientSynchronization", mapOf("synchronizationStatus" to synchronizationStatus.toString()))
    }

    override fun onConnectionStateChange(connectionState: ChatClient.ConnectionState) {
        TwilioVoice.debug("ChatListener.onConnectionStateChange => status = $connectionState")
        sendEvent("connectionStateChange", mapOf("connectionState" to connectionState.toString()))
    }

    override fun onError(errorInfo: ErrorInfo) {
        sendEvent("error", null, errorInfo)
    }

    override fun onInvitedToChannelNotification(channelSid: String) {
        TwilioVoice.debug("ChatListener.onInvitedToChannelNotification => channelSid = $channelSid")
        sendEvent("invitedToChannelNotification", mapOf("channelSid" to channelSid))
    }

    override fun onNewMessageNotification(channelSid: String?, messageSid: String?, messageIndex: Long) {
        TwilioVoice.debug("ChatListener.onNewMessageNotification => channelSid = $channelSid, messageSid = $messageSid, messageIndex = $messageIndex")
        sendEvent("newMessageNotification", mapOf(
                "channelSid" to channelSid,
                "messageSid" to messageSid,
                "messageIndex" to messageIndex
        ))
    }

    override fun onNotificationSubscribed() {
        TwilioVoice.debug("ChatListener.onNotificationSubscribed")
        sendEvent("notificationSubscribed", null)
    }

    override fun onNotificationFailed(errorInfo: ErrorInfo) {
        sendEvent("notificationFailed", null, errorInfo)
    }

    override fun onRemovedFromChannelNotification(channelSid: String) {
        TwilioVoice.debug("ChatListener.onRemovedFromChannelNotification => channelSid = $channelSid")
        sendEvent("removedFromChannelNotification", mapOf("channelSid" to channelSid))
    }

    override fun onTokenAboutToExpire() {
        TwilioVoice.debug("ChatListener.onTokenAboutToExpire")
        sendEvent("tokenAboutToExpire", null)
    }

    override fun onTokenExpired() {
        TwilioVoice.debug("ChatListener.onTokenExpired")
        sendEvent("tokenExpired", null)
    }

    override fun onUserSubscribed(user: User) {
        TwilioVoice.debug("ChatListener.onUserSubscribed => user '${user.friendlyName}'")
        sendEvent("userSubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onUserUnsubscribed(user: User) {
        TwilioVoice.debug("ChatListener.onUserUnsubscribed => user '${user.friendlyName}'")
        sendEvent("userUnsubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onUserUpdated(user: User, reason: User.UpdateReason) {
        TwilioVoice.debug("ChatListener.onUserUpdated => user '${user.friendlyName}' updated, $reason")
        sendEvent("userUpdated", mapOf(
                "user" to Mapper.userToMap(user),
                "reason" to mapOf(
                        "type" to "user",
                        "value" to reason.toString()
                )
        ))
    }

    private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        events?.success(eventData)
    }
}
