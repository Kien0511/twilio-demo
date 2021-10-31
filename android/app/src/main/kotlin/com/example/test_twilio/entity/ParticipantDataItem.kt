class ParticipantDataItem(
    val sid: String?,
    val identity: String?,
    val conversationSid: String?,
    val friendlyName: String?,
    val isOnline: Boolean?,
    val lastReadMessageIndex: Long?,
    val lastReadTimestamp: String?,
    val typing: Boolean? = false
) {
    companion object {
        fun fromMap(data: HashMap<String, Any?>): ParticipantDataItem {
            return ParticipantDataItem(
                sid = data["sid"]?.toString(),
                identity = data["identity"]?.toString(),
                conversationSid = data["conversationSid"]?.toString(),
                friendlyName = data["friendlyName"]?.toString(),
                isOnline = data["isOnline"]?.toString()?.toBoolean(),
                lastReadMessageIndex = data["lastReadMessageIndex"]?.toString()?.toLong(),
                lastReadTimestamp = data["lastReadTimestamp"]?.toString(),
                typing = data["typing"]?.toString()?.toBoolean(),
            )
        }
    }

    fun toMap() : HashMap<String, Any?> {
        val map = hashMapOf<String, Any?>()

        map["sid"] = sid
        map["identity"] = identity
        map["conversationSid"] = conversationSid
        map["friendlyName"] = friendlyName
        map["isOnline"] = isOnline
        map["lastReadMessageIndex"] = lastReadMessageIndex
        map["lastReadTimestamp"] = lastReadTimestamp
        map["typing"] = typing
        return map
    }
}
