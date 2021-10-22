package com.example.test_twilio

import com.twilio.chat.*
import java.util.Date
import com.twilio.chat.Channel.ChannelStatus
import com.twilio.chat.Channel.ChannelType
import com.twilio.chat.Channel.NotificationLevel

class ChannelModel {
    private var channel: Channel? = null
    private var channelDescriptor: ChannelDescriptor? = null

    constructor(channel_: Channel) {
        channel = channel_
    }

    constructor(channel_: ChannelDescriptor) {
        channelDescriptor = channel_
    }

    val friendlyName: String?
        get() {
            if (channel != null) return channel!!.friendlyName
            if (channelDescriptor != null) return channelDescriptor!!.friendlyName
            return null
        }

    val sid: String?
        get() {
            if (channel != null) return channel!!.sid
            if (channelDescriptor != null) return channelDescriptor!!.sid
            return null
        }

    val dateUpdatedAsDate: Date?
        get() {
            if (channel != null) return channel!!.dateUpdatedAsDate
            if (channelDescriptor != null) return channelDescriptor!!.dateUpdated
            return null
        }

    val dateCreatedAsDate: Date?
        get() {
            if (channel != null) return channel!!.dateCreatedAsDate
            if (channelDescriptor != null) return channelDescriptor!!.dateCreated
            return null
        }

    val status: ChannelStatus?
        get() {
            if (channel != null) return channel!!.status
            if (channelDescriptor != null) return channelDescriptor!!.status
            return null
        }

    val lastMessageDate: Date?
        get() {
            if (channel != null) return channel!!.lastMessageDate
            if (channelDescriptor != null) return null
            return null
        }

    val notificationLevel: NotificationLevel?
        get() {
            if (channel != null) return channel!!.notificationLevel
            if (channelDescriptor != null) return NotificationLevel.DEFAULT
            return null
        }

    val lastMessageIndex: Long?
        get() {
            if (channel != null) return channel!!.lastMessageIndex
            if (channelDescriptor != null) return null
            return null
        }

    fun getUnconsumedMessagesCount(listener: CallbackListener<Long>) {
        if (channel != null) {
            channel!!.getUnconsumedMessagesCount(listener)
            return
        }
        if (channelDescriptor != null) {
            listener.onSuccess(channelDescriptor!!.unconsumedMessagesCount)
            return
        }
        listener.onError(ErrorInfo(-10001, "No channel in model"))
    }

    fun getMessagesCount(listener: CallbackListener<Long>) {
        if (channel != null) {
            channel!!.getMessagesCount(listener)
            return
        }
        if (channelDescriptor != null) {
            listener.onSuccess(channelDescriptor!!.messagesCount)
            return
        }
        listener.onError(ErrorInfo(-10002, "No channel in model"))
    }

    fun getMembersCount(listener: CallbackListener<Long>) {
        if (channel != null) {
            channel!!.getMembersCount(listener)
            return
        }
        if (channelDescriptor != null) {
            listener.onSuccess(channelDescriptor!!.membersCount)
            return
        }
        listener.onError(ErrorInfo(-10003, "No channel in model"))
    }

    fun join(listener: StatusListener) {
        if (channel != null) {
            channel!!.join(listener)
            return
        }
        if (channelDescriptor != null) {
            channelDescriptor!!.getChannel(object : CallbackListener<Channel>() {
                override fun onSuccess(chan: Channel) {
                    chan.join(listener)
                }

                override fun onError(err: ErrorInfo?) {
                    listener.onError(err)
                }
            })
            return
        }
        listener.onError(ErrorInfo(-10004, "No channel in model"))
    }

    fun getChannel(listener: CallbackListener<Channel>) {
        if (channel != null) {
            listener.onSuccess(channel)
            return
        }
        if (channelDescriptor != null) {
            channelDescriptor!!.getChannel(listener)
            return
        }
        listener.onError(ErrorInfo(-10005, "No channel in model"))
    }

    val type: Channel.ChannelType?
        get() {
            if (channel != null) return channel!!.type
            if (channelDescriptor != null) return ChannelType.PUBLIC
            return null
        }

    fun toMap(): HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["friendlyName"] = friendlyName
        hashMap["sid"] = sid
        hashMap["dateUpdatedAsDate"] = dateUpdatedAsDate?.time
        hashMap["dateCreatedAsDate"] = dateCreatedAsDate?.time
        hashMap["status"] = status?.value
        hashMap["lastMessageDate"] = lastMessageDate?.time
        hashMap["notificationLevel"] = notificationLevel?.value
        hashMap["lastMessageIndex"] = lastMessageIndex
        hashMap["type"] = type?.value
        return hashMap
    }
}
