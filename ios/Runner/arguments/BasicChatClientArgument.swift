//
//  BasicChatClientArgument.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation

class BasicChatClientArgument {
    var accessToken: String?
    var firebaseToken: String?
    
    init(accessToken: String?, firebaseToken: String?) {
        self.accessToken = accessToken
        self.firebaseToken = firebaseToken
    }
    
    static func fromMap(data: [String: Any?]) -> BasicChatClientArgument {
        return BasicChatClientArgument(accessToken: data["accessToken"] as? String, firebaseToken: data["firebaseToken"] as? String)
    }
}
