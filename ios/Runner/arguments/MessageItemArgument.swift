//
//  MessageItemArgument.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation
import TwilioChatClient

class MessageItemArgument {
    var message: TCHMessage?
    var members: TCHMembers?
    
    init(message: TCHMessage?, members: TCHMembers?) {
        self.message = message
        self.members = members
    }
    
    static func toMapList(list: [MessageItemArgument]) -> [[String: Any?]] {
        var listMap: [[String: Any?]] = []
        for messageItem in list {
            listMap.append(messageItem.toMap())
        }
        return listMap
    }
    
    func toMap() -> [String: Any?] {
        var map: [String: Any?] = [:]
        map["message"] = messageMap(message: message!)
        map["members"] = membersMap(members: members!)
        return map
    }
    
    private func messageMap(message: TCHMessage) -> [String: Any?] {
        var map: [String: Any?] = [:]
        map["sid"] = message.sid
        map["author"] = message.author
        map["dateCreated"] = message.dateCreated
        map["dateUpdated"] = message.dateUpdated
        map["lastUpdatedBy"] = message.lastUpdatedBy
        map["messageBody"] = message.body
        map["memberSid"] = message.memberSid
        map["messageIndex"] = message.index
        map["type"] = message.messageType.rawValue
        map["hasMedia"] = message.hasMedia()
        return map
    }
    
    private func membersMap(members: TCHMembers) -> [String: Any?] {
        var map: [String: Any?] = [:]
        map["members"] = memberMap(membersList: members.membersList())
        return map
    }
    
    private func memberMap(membersList: [TCHMember]) -> [[String: Any?]] {
        var listMap: [[String: Any?]] = []
        for member in membersList {
            var map: [String: Any?] = [:]
            map["sid"] = member.sid
            map["lastConsumedMessageIndex"] = member.lastConsumedMessageIndex
            map["lastConsumptionTimestamp"] = member.lastConsumptionTimestamp
            map["identity"] = member.identity
            map["type"] = member.type.rawValue
            listMap.append(map)
        }
        return listMap
    }
}
