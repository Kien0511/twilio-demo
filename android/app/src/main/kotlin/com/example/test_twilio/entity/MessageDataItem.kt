class MessageDataItem(
    val sid: String?,
    val conversationSid: String?,
    val participantSid: String?,
    var type: Int?,
    val author: String?,
    val dateCreated: Long?,
    val body: String?,
    val index: Long?,
    val attributes: String?,
    val direction: Int?,
    var sendStatus: Int?,
    val uuid: String?,
    val mediaSid: String? = null,
    val mediaFileName: String? = null,
    val mediaType: String? = null,
    val mediaSize: Long? = null,
    val mediaUri: String? = null,
    val mediaDownloadId: Long? = null,
    val mediaDownloadedBytes: Long? = null,
    val mediaDownloadState: Int? = 0,
    var mediaUploading: Boolean? = false,
    var mediaUploadedBytes: Long? = null,
    val mediaUploadUri: String? = null,
    var errorCode: Int? = 0,
    val filePath: String? = null
) {
    companion object {
        fun fromMap(data: HashMap<String, Any?>): MessageDataItem {
            return MessageDataItem(
                sid = data["sid"]?.toString(),
                conversationSid = data["conversationSid"]?.toString(),
                participantSid = data["participantSid"]?.toString(),
                type = data["type"]?.toString()?.toInt(),
                author = data["author"]?.toString(),
                dateCreated = data["dateCreated"]?.toString()?.toLong(),
                body = data["body"]?.toString(),
                index = data["index"]?.toString()?.toLong(),
                attributes = data["attributes"]?.toString(),
                direction = data["direction"]?.toString()?.toInt(),
                sendStatus = data["sendStatus"]?.toString()?.toInt(),
                uuid = data["uuid"]?.toString(),
                mediaSid = data["mediaSid"]?.toString(),
                mediaFileName = data["mediaFileName"]?.toString(),
                mediaType = data["mediaType"]?.toString(),
                mediaSize = data["mediaSize"]?.toString()?.toLong(),
                mediaUri = data["mediaUri"]?.toString(),
                mediaDownloadId = data["mediaDownloadId"]?.toString()?.toLong(),
                mediaDownloadedBytes = data["mediaDownloadedBytes"]?.toString()?.toLong(),
                mediaDownloadState = data["mediaDownloadState"]?.toString()?.toInt(),
                mediaUploading = data["mediaUploading"]?.toString()?.toBoolean(),
                mediaUploadedBytes = data["mediaUploadedBytes"]?.toString()?.toLong(),
                mediaUploadUri = data["mediaUploadUri"]?.toString(),
                errorCode = data["errorCode"]?.toString()?.toInt(),
                filePath = data["filePath"]?.toString(),
            )
        }
    }
    
    fun toMap() : HashMap<String, Any?> {
        val map = hashMapOf<String, Any?>()
        
        map["sid"] = sid
        map["conversationSid"] = conversationSid
        map["participantSid"] = participantSid
        map["type"] = type
        map["author"] = author
        map["dateCreated"] = dateCreated
        map["body"] = body
        map["index"] = index
        map["attributes"] = attributes
        map["direction"] = direction
        map["sendStatus"] = sendStatus
        map["uuid"] = uuid
        map["mediaSid"] = mediaSid
        map["mediaFileName"] = mediaFileName
        map["mediaType"] = mediaType
        map["mediaSize"] = mediaSize
        map["mediaUri"] = mediaUri
        map["mediaDownloadId"] = mediaDownloadId
        map["mediaDownloadedBytes"] = mediaDownloadedBytes
        map["mediaDownloadState"] = mediaDownloadState
        map["mediaUploading"] = mediaUploading
        map["mediaUploadedBytes"] = mediaUploadedBytes
        map["mediaUploadUri"] = mediaUploadUri
        map["errorCode"] = errorCode
        map["filePath"] = filePath
        return map
    }
}
