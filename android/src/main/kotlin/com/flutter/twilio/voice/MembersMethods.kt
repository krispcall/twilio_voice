package com.flutter.twilio.voice

import com.twilio.chat.CallbackListener
import com.twilio.chat.Channel
import com.twilio.chat.ErrorInfo
import com.twilio.chat.StatusListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object MembersMethods {
    fun getChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
            ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMembersList(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.getMembersList (Channels.getChannel) => onSuccess")
                val membersListMap = Mapper.membersListToMap(channel.members.membersList)
                result.success(membersListMap)
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.getMembersList (Channels.getChannel) onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMember(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.getMember (Channels.getChannel) => onSuccess")
                val memberMap = Mapper.memberToMap(channel.members.getMember(identity))
                result.success(memberMap)
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.getMember (Channels.getChannel) onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun addByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.addByIdentity (Channels.getChannel) => onSuccess")
                channel.members.addByIdentity(identity, object : StatusListener() {
                    override fun onSuccess() {
                        TwilioVoice.debug("MembersMethods.addByIdentity (Members.addByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        TwilioVoice.debug("MembersMethods.addByIdentity (Members.addByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.addByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun inviteByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.inviteByIdentity (Channels.getChannel) => onSuccess")
                channel.members.inviteByIdentity(identity, object : StatusListener() {
                    override fun onSuccess() {
                        TwilioVoice.debug("MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        TwilioVoice.debug("MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.inviteByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun removeByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MembersMethods.removeByIdentity (Channels.getChannel) => onSuccess")
                channel.members.removeByIdentity(identity, object : StatusListener() {
                    override fun onSuccess() {
                        TwilioVoice.debug("MembersMethods.removeByIdentity (Members.removeByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        TwilioVoice.debug("MembersMethods.removeByIdentity (Members.removeByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MembersMethods.removeByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }
}
