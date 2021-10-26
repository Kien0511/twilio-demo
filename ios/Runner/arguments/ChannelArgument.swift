//
//  ChannelArgument.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation

class ChannelArgument {
    var friendlyName: String?
    var sid: String?
    var dateUpdatedAsDate: Int64?
    var dateCreatedAsDate: Int64?
    var status: Int?
    var lastMessageDate: Int64?
    var notificationLevel: Int?
    var lastMessageIndex: Int?
    var type: Int?
    
    init(friendlyName: String?, sid: String?, dateUpdatedAsDate: Int64?, dateCreatedAsDate: Int64?, status: Int?, lastMessageDate: Int64?, notificationLevel: Int?, lastMessageIndex: Int?, type: Int?) {
        self.friendlyName = friendlyName
        self.sid = sid
        self.dateUpdatedAsDate = dateUpdatedAsDate
        self.dateCreatedAsDate = dateCreatedAsDate
        self.status = status
        self.lastMessageDate = lastMessageDate
        self.notificationLevel = notificationLevel
        self.lastMessageIndex = lastMessageIndex
        self.type = type
    }
    
    static func fromMap(data: [String: Any?]) -> ChannelArgument {
        return ChannelArgument(friendlyName: data["friendlyName"] as? String, sid: data["sid"] as? String, dateUpdatedAsDate: data["dateUpdatedAsDate"] as? Int64, dateCreatedAsDate: data["dateCreatedAsDate"] as? Int64, status: data["status"] as? Int, lastMessageDate: data["lastMessageDate"] as? Int64, notificationLevel: data["notificationLevel"] as? Int, lastMessageIndex: data["lastMessageIndex"] as? Int, type: data["type"] as? Int)
    }
}
