//
//  CreateChannelArgument.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation

class CreateChannelArgument {
    var channelName: String?
    var channelType: Int?
    
    init(channelName: String?, channelType: Int?) {
        self.channelName = channelName
        self.channelType = channelType
    }
    
    static func fromMap(json: [String: Any?]) -> CreateChannelArgument {
        return CreateChannelArgument(channelName: json["channelName"] as? String, channelType: json["channelType"] as? Int)
    }
}
