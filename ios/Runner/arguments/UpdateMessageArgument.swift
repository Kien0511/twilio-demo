//
//  UpdateMessageArgument.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation

class UpdateMessageArgument {
    var messageId: String?
    var messageBody: String?
    
    init(messageId: String?, messageBody: String?) {
        self.messageId = messageId
        self.messageBody = messageBody
    }
    
    static func fromMap(json: [String: Any?]) -> UpdateMessageArgument {
        return UpdateMessageArgument(messageId: json["messageId"] as? String, messageBody: json["messageBody"] as? String)
    }
}
