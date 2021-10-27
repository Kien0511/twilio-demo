//
//  ChannelModel.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation
import TwilioConversationsClient

class ConversationModel {
    var conversation: TCHConversation? = nil
    
    init(conversation: TCHConversation) {
        self.conversation = conversation
    }
    
    func getConversation(listener: @escaping (TCHConversation) -> Void) {
        if let conversation = conversation {
            listener(conversation)
        }
    }
    
    func toMap() -> [String: Any?] {
        var map: [String: Any?] = [:]
        map["friendlyName"] = conversation?.friendlyName
        map["sid"] = conversation?.sid
        map["dateUpdatedAsDate"] = Int(conversation!.dateUpdatedAsDate!.timeIntervalSince1970)
        map["dateCreatedAsDate"] = Int(conversation!.dateCreatedAsDate!.timeIntervalSince1970)
        map["status"] = conversation?.status.rawValue
        map["lastMessageDate"] = Int(conversation!.lastMessageDate!.timeIntervalSince1970)
        map["notificationLevel"] = conversation?.notificationLevel.rawValue
        map["lastMessageIndex"] = conversation?.lastMessageIndex
        return map
    }
}
