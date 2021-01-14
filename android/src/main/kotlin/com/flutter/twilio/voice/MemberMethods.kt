package com.flutter.twilio.voice

import com.twilio.chat.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException

object MemberMethods {
    fun getChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
            ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel) {
                TwilioVoice.debug("MemberMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                TwilioVoice.debug("MemberMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getUserDescriptor(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        try {
            TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
                override fun onSuccess(channel: Channel) {
                    TwilioVoice.debug("MemberMethods.getUserDescriptor => onSuccess")
                    val member = channel.members.membersList.find { it.identity == identity }
                    if (member != null) {
                        member.getUserDescriptor(object : CallbackListener<UserDescriptor>() {
                            override fun onSuccess(userDescriptor: UserDescriptor) {
                                TwilioVoice.debug("MemberMethods.getUserDescriptor (Member.getUserDescriptor) => onSuccess")
                                result.success(Mapper.userDescriptorToMap(userDescriptor))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                TwilioVoice.debug("ChannelsMethods.getUserDescriptor => getUserDescriptor onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with identity '$identity'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    TwilioVoice.debug("ChannelsMethods.getUserDescriptor => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getAndSubscribeUser(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val memberSid = call.argument<String>("memberSid")
                ?: return result.error("ERROR", "Missing 'memberSid'", null)

        try {
            TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
                override fun onSuccess(channel: Channel) {
                    TwilioVoice.debug("MemberMethods.getAndSubscribeUser => onSuccess")
                    val member = channel.members.membersList.find { it.sid == memberSid }
                    if (member != null) {
                        member.getAndSubscribeUser(object : CallbackListener<User>() {
                            override fun onSuccess(user: User) {
                                TwilioVoice.debug("MemberMethods.getAndSubscribeUser (Member.getAndSubscribeUser) => onSuccess")
                                result.success(Mapper.userToMap(user))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                TwilioVoice.debug("ChannelsMethods.getAndSubscribeUser => getAndSubscribeUser onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with sid '$memberSid'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    TwilioVoice.debug("ChannelsMethods.getAndSubscribeUser => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun setAttributes(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val memberSid = call.argument<String>("memberSid")
                ?: return result.error("ERROR", "Missing 'memberSid'", null)

        // Not erroring out because a nullable attributes is allowed to reset the Channel attributes.
        val attributes = call.argument<Map<String, Any>>("attributes")

        try {
            TwilioVoice.chatClient?.channels?.getChannel(channelSid, object : CallbackListener<Channel>() {
                override fun onSuccess(channel: Channel) {
                    TwilioVoice.debug("MemberMethods.setAttributes => onSuccess")
                    val member = channel.members.membersList.find { it.sid == memberSid }
                    if (member != null) {
                        member.setAttributes(Mapper.mapToAttributes(attributes), object : StatusListener() {
                            override fun onSuccess() {
                                TwilioVoice.debug("MemberMethods.setAttributes  (Channel.setAttributes) => onSuccess")
                                try {
                                    result.success(Mapper.attributesToMap(member.attributes))
                                } catch (err: JSONException) {
                                    return result.error("JSONException", err.message, null)
                                }
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                TwilioVoice.debug("MemberMethods.setAttributes  (Channel.setAttributes) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with sid '$memberSid'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    TwilioVoice.debug("MemberMethods.setAttributes => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }
}
