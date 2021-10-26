//
//  BasicChatClient.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation
import TwilioChatClient

class BasicChatClient: NSObject {
    var chatClient: TwilioChatClient? = nil
    var accessToken: String? = nil
    var firebaseToken: String? = nil
    private var delegate: AppDelegateCallback? = nil
    private var channels: [String: ChannelModel] = [:]
    
    func setAppDelegateCallback(delegate: AppDelegateCallback) {
        self.delegate = delegate
    }
    
    func createClient(accessToken: String?, firebaseToken: String?) {
        self.accessToken = accessToken
        self.firebaseToken = firebaseToken
        if (chatClient != nil) {
            shutdown()
        }
        
        let props = TwilioChatClientProperties.init()
        props.region = "us1"
        props.deferCertificateTrustToPlatform = false
        
        TwilioChatClient.chatClient(withToken: accessToken!, properties: props, delegate: self) { (result, chatClient) in
            if (result.isSuccessful()) {
                self.chatClient = chatClient
                if (chatClient != nil) {
                    self.setFcmToken()
                }
            } else {
                self.chatClient = nil
            }
        }
    }
    
    func shutdown() {
        chatClient!.shutdown()
        chatClient = nil
    }
    
    private func setFcmToken() {
        //TODO: register firebase token
    }
}

extension BasicChatClient: TwilioChatClientDelegate {
    
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        print("onChannelAdded: \(channel)")
        channels[channel.sid!] = ChannelModel(channel: channel)
        refreshChannelList()
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        print("onChannelDeleted: \(channel)")
        channels.removeValue(forKey: channel.sid!)
        refreshChannelList()
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        if (chatClient != nil) {
            delegate?.generateNewAccessToken()
        }
    }
    
    func chatClientTokenExpired(_ client: TwilioChatClient) {
        accessToken = nil
        if (chatClient != nil) {
            delegate?.generateNewAccessToken()
        }
    }
    
    private func refreshChannelList() {
        delegate?.refreshChannelList()
    }
}
