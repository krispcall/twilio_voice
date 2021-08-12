package com.flutter.twilio.voice

import com.twilio.voice.*
import org.json.JSONArray
import org.json.JSONObject

object Mapper
{
    fun jsonObjectToMap(jsonObject: JSONObject): Map<String, Any?> {
        val result = mutableMapOf<String, Any?>()
        jsonObject.keys().forEach {
            when {
                JSONObject.NULL == jsonObject[it] ->
                {
                    result[it] = null
                }
                jsonObject[it] is JSONObject -> {
                    result[it] = jsonObjectToMap(jsonObject[it] as JSONObject)
                }
                jsonObject[it] is JSONArray -> {
                    result[it] = jsonArrayToList(jsonObject[it] as JSONArray)
                }
                else -> {
                    result[it] = jsonObject[it]
                }
            }
        }
        return result
    }

    fun jsonArrayToList(jsonArray: JSONArray): List<Any?> {
        val result = mutableListOf<Any?>()
        for (i in 0 until jsonArray.length()) {
            if (jsonArray[i] == null || JSONObject.NULL == jsonArray[i]) {
                result[i] = null
            } else if (jsonArray[i] is JSONObject) {
                result[i] = jsonObjectToMap(jsonArray[i] as JSONObject)
            } else if (jsonArray[i] is JSONArray) {
                result[i] = jsonArrayToList(jsonArray[i] as JSONArray)
            } else {
                result[i] = jsonArray[i]
            }
        }
        return result
    }

    fun mapToJSONObject(map: Map<String, Any>?): JSONObject? {
        if (map == null) {
            return null
        }
        val result = JSONObject()
        map.keys.forEach {
            if (map[it] == null) {
                result.put(it, null)
            } else if (map[it] is Map<*, *>) {
                result.put(it, mapToJSONObject(map[it] as Map<String, Any>))
            } else if (map[it] is List<*>) {
                result.put(it, listToJSONArray(map[it] as List<Any>))
            } else {
                result.put(it, map[it])
            }
        }
        return result
    }

    fun listToJSONArray(list: List<Any>): JSONArray {
        val result = JSONArray()
        list.forEach {
            if (it is Map<*, *>) {
                result.put(mapToJSONObject(it as Map<String, Any>))
            } else if (it is List<*>) {
                result.put(listToJSONArray(it as List<Any>))
            } else {
                result.put(it)
            }
        }
        return result
    }

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
                "callSid" to message.getSid(),
                "from" to message.from,
                "to" to message.to,
                "isOnHold" to message.isOnHold,
                "isMuted" to message.isMuted
        )
    }

    fun callInviteToMap(message: CallInvite): Map<String, Any?> {
        return mapOf(
                "twi_call_sid" to message.callSid,
                "twi_to" to message.to,
                "twi_from" to message.from,
                "customParameters" to message.customParameters,
                "channelInfo" to message.customParameters["channel_info"]
        )
    }

    fun customParamsToMap(message: CallInvite): Map<String, Any?> {
        return mapOf(
                "twi_call_sid" to message.callSid,
                "twi_to" to message.to,
                "twi_from" to message.from,
                "customParameters" to message.customParameters
        )
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
