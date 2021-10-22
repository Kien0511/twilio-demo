package com.example.test_twilio.arguments

class ChannelArgument(
        var friendlyName: String?,
        var sid: String?,
        var dateUpdatedAsDate: Long?,
        var dateCreatedAsDate: Long?,
        var status: Int?,
        var lastMessageDate: Long?,
        var notificationLevel: Int?,
        var lastMessageIndex: Int?,
        var type: Int?) {

    companion object {
        fun fromMap(data: HashMap<String, Any>?): ChannelArgument {
            return ChannelArgument(
                    friendlyName = data?.get("friendlyName")?.toString(),
                    sid = data?.get("sid")?.toString(),
                    dateUpdatedAsDate = data?.get("dateUpdatedAsDate")?.toString()?.toLong(),
                    dateCreatedAsDate = data?.get("dateCreatedAsDate")?.toString()?.toLong(),
                    status = data?.get("status")?.toString()?.toInt(),
                    lastMessageDate = data?.get("lastMessageDate")?.toString()?.toLong(),
                    notificationLevel = data?.get("notificationLevel")?.toString()?.toInt(),
                    lastMessageIndex = data?.get("lastMessageIndex")?.toString()?.toInt(),
                    type = data?.get("type")?.toString()?.toInt()
            )
        }
    }
}