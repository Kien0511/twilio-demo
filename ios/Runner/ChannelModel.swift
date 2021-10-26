//
//  ChannelModel.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation
import TwilioChatClient

class ChannelModel {
    var channel: TCHChannel? = nil
    var channelDescriptor: TCHChannelDescriptor? = nil
    
    init(channel: TCHChannel) {
        self.channel = channel
    }
    
    init(channelDescriptor: TCHChannelDescriptor) {
        self.channelDescriptor = channelDescriptor
    }
    
    func getFriendlyName() -> String? {
        if (channel != nil) {
            return channel!.friendlyName
        }
        
        if (channelDescriptor != nil) {
            return channelDescriptor!.friendlyName
        }
        
        return nil
    }
    
    func getSid() -> String? {
        if (channel != nil) {
            return channel!.sid
        }
        
        if (channelDescriptor != nil) {
            return channelDescriptor!.sid
        }
        
        return nil
    }
    
    
    func getDateUpdatedAsDate() -> Date? {
        if (channel != nil) {
            return channel!.dateUpdatedAsDate
        }
        
        if (channelDescriptor != nil) {
            return channelDescriptor!.dateUpdated
        }
        
        return nil
    }
    
    func getDateCreatedAsDate() -> Date? {
        if (channel != nil) {
            return channel!.dateCreatedAsDate
        }
        
        if (channelDescriptor != nil) {
            return channelDescriptor!.dateCreated
        }
        
        return nil
    }
    
    func getstatus() -> TCHChannelStatus? {
        if (channel != nil) {
            return channel!.status
        }
        
        if (channelDescriptor != nil) {
            return nil
        }
        
        return nil
    }
    
    func getLastMessageDate() -> Date? {
        if (channel != nil) {
            return channel!.lastMessageDate
        }
        
        if (channelDescriptor != nil) {
            return nil
        }
        
        return nil
    }
    
    func getNotificationLevel() -> TCHChannelNotificationLevel? {
        if (channel != nil) {
            return channel!.notificationLevel
        }
        
        if (channelDescriptor != nil) {
            return TCHChannelNotificationLevel.default
        }
        
        return nil
    }
    
    func getLastMessageIndex() -> NSNumber? {
        if (channel != nil) {
            return channel!.lastMessageIndex
        }
        
        if (channelDescriptor != nil) {
            return nil
        }
        
        return nil
    }
    
    func getType() -> TCHChannelType? {
        if (channel != nil) {
            return channel!.type
        }
        
        if (channelDescriptor != nil) {
            return TCHChannelType.public
        }
        
        return nil
    }
    
    func getChannel(callBack: @escaping(_ value: TCHChannel?) -> Void) {
        if (channel != nil) {
            callBack(self.channel)
        }
        
        if (channelDescriptor != nil) {
            channelDescriptor!.channel { (result, channel) in
                callBack(channel)
            }
            return
        }
    }
    
    func toMap() -> [String: Any?] {
        var map: [String: Any?] = [:]
        map["friendlyName"] = getFriendlyName()
        map["sid"] = getSid()
        map["dateUpdatedAsDate"] = getDateUpdatedAsDate()?.timeIntervalSinceNow
        map["dateCreatedAsDate"] = getDateCreatedAsDate()?.timeIntervalSinceNow
        map["status"] = getstatus()?.rawValue
        map["lastMessageDate"] = getLastMessageDate()?.timeIntervalSinceNow
        map["notificationLevel"] = getNotificationLevel()?.rawValue
        map["lastMessageIndex"] = getLastMessageIndex()
        map["type"] = getType()?.rawValue
        return map
    }
}
