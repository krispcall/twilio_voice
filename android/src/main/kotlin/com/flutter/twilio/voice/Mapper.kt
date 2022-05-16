package com.flutter.twilio.voice

import com.twilio.voice.*
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

object Mapper
{
    fun errorInfoToMap(e: RegistrationException?): Map<String, Any?>? {
        if (e == null)
            return null
        return mapOf(
                "status" to e.errorCode,
                "code" to e.errorCode,
                "message" to e.message
        )
    }

    fun errorInfoToMap(e: CallException?): Map<String, Any?>? {
        if (e == null)
            return null
        return mapOf(
                "code" to e.errorCode,
                "message" to e.message
        )
    }

    fun callToMap(message: Call): Map<String, Any?> {
        return mapOf(
                "callSid" to message.sid,
                "from" to message.from,
                "to" to message.to,
                "isOnHold" to message.isOnHold,
                "isMuted" to message.isMuted
        )
    }

    fun callInviteToMap(message: CallInvite): Map<String, Any?>
    {
        var temp: String = message.customParameters["channel_info"] as String
        temp = temp.replace("{'", "{\"");
        temp = temp.replace("':", "\":");
        temp = temp.replace(": '", ": \"");
        temp = temp.replace("',", "\",");
        temp = temp.replace(", '", ", \"");
        temp = temp.replace("'}", "\"}");
        temp = temp.replace("None", "null")
        return mapOf(
                "twi_call_sid" to message.callSid,
                "twi_to" to message.to,
                "twi_from" to message.from,
                "customParameters" to message.customParameters,
                "channelInfo" to toMap(JSONObject(temp))
        )
    }

    @Throws(JSONException::class)
    fun toMap(jsonobj: JSONObject): Map<String, Any>
    {
        val map: MutableMap<String, Any> = HashMap()
        val keys = jsonobj.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            var value = jsonobj[key]
            if (value is JSONArray) {
                value = toList(value)
            } else if (value is JSONObject) {
                value = toMap(value)
            }
            map[key] = value
        }
        return map
    }

    @Throws(JSONException::class)
    fun toList(array: JSONArray): List<Any> {
        val list: MutableList<Any> = ArrayList()
        for (i in 0 until array.length()) {
            var value = array[i]
            if (value is JSONArray) {
                value = toList(value)
            } else if (value is JSONObject) {
                value = toMap(value)
            }
            list.add(value)
        }
        return list
    }

    fun cancelledCallInviteToMap(message: CancelledCallInvite): Map<String, Any?> {
        return mapOf(
                "twi_call_sid" to message.callSid,
                "twi_to" to message.to,
                "twi_from" to message.from,
                "customParameters" to message.customParameters
        )
    }
}
