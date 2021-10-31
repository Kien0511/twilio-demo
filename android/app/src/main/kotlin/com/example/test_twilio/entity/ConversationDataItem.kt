class ConversationDataItem(
    val sid: String?,
    val friendlyName: String?,
    val attributes: String?,
    val uniqueName: String?,
    val dateUpdated: Long?,
    val dateCreated: Long?,
    val lastMessageDate: Long?,
    val lastMessageText: String?,
    val lastMessageSendStatus: Int?,
    val createdBy: String?,
    val participantsCount: Long?,
    val messagesCount: Long?,
    val unreadMessagesCount: Long?,
    val participatingStatus: Int?,
    val notificationLevel: Int?
) {
    companion object {
        fun fromMap(data: HashMap<String, Any?>): ConversationDataItem {
            return ConversationDataItem(
                sid = data["sid"]?.toString(),
                friendlyName = data["friendlyName"]?.toString(),
                attributes = data["attributes"]?.toString(),
                uniqueName = data["uniqueName"]?.toString(),
                dateUpdated = data["dateUpdated"]?.toString()?.toLong(),
                dateCreated = data["dateCreated"]?.toString()?.toLong(),
                lastMessageDate = data["lastMessageDate"]?.toString()?.toLong(),
                lastMessageText = data["lastMessageText"]?.toString(),
                lastMessageSendStatus = data["lastMessageSendStatus"]?.toString()?.toInt(),
                createdBy = data["createdBy"]?.toString(),
                participantsCount = data["participantsCount"]?.toString()?.toLong(),
                messagesCount = data["messagesCount"]?.toString()?.toLong(),
                unreadMessagesCount = data["unreadMessagesCount"]?.toString()?.toLong(),
                participatingStatus = data["participatingStatus"]?.toString()?.toInt(),
                notificationLevel = data["notificationLevel"]?.toString()?.toInt(),
            )
        }
    }
    fun toMap(): HashMap<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["sid"] = sid
        map["friendlyName"] = friendlyName
        map["attributes"] = attributes
        map["uniqueName"] = uniqueName
        map["dateUpdated"] = dateUpdated
        map["dateCreated"] = dateCreated
        map["lastMessageDate"] = lastMessageDate
        map["lastMessageText"] = lastMessageText
        map["lastMessageSendStatus"] = lastMessageSendStatus
        map["createdBy"] = createdBy
        map["participantsCount"] = participantsCount
        map["messagesCount"] = messagesCount
        map["unreadMessagesCount"] = unreadMessagesCount
        map["participatingStatus"] = participatingStatus
        map["notificationLevel"] = notificationLevel
        return map
    }
}
