//
//  BasicChatClient.swift
//  Runner
//
//  Created by KienNT on 10/26/21.
//

import Foundation
import TwilioConversationsClient

class BasicChatClient: NSObject {
    static let instance = BasicChatClient()
    var conversationsClient: TwilioConversationsClient? = nil
    var accessToken: String? = nil
    var firebaseToken: String? = nil
    private var delegate: AppDelegateCallback? = nil
    private var conversations: [String: ConversationModel] = [:]
    
    func setAppDelegateCallback(delegate: AppDelegateCallback) {
        self.delegate = delegate
    }
    
    func updateAccessToken(accessToken: String) {
        self.accessToken = accessToken
        if let conversationsClient = conversationsClient {
            conversationsClient.updateToken(accessToken) { (result) in
                if (result.isSuccessful) {
                    print("update access token success")
                } else {
                    print("update access token failed")
                }
            }
        }
    }
    
    func getConversations() -> [String: Any?]{
        var map: [String: Any?] = [:]
        conversations.forEach { (arg0) in
            let (key, value) = arg0
            map["\(key)"] = value.toMap()
        }
        return map
    }
    
    func getMessageItemList() -> [[String: Any?]] {
        var list: [[String: Any?]] = []
        MessageClient.instance.messageItemList.forEach { (messageItem) in
            list.append(messageItem.toMap())
        }
        return list
    }
    
    func clearChannel() {
        conversations.removeAll()
    }
    
    func createClient(accessToken: String?, firebaseToken: String?) {
        self.accessToken = accessToken
        self.firebaseToken = firebaseToken
        if (conversationsClient != nil) {
            shutdown()
        }
        
        let props = TwilioConversationsClientProperties.init()
        props.region = "us1"
        props.deferCertificateTrustToPlatform = false
        
        TwilioConversationsClient.conversationsClient(withToken: accessToken!, properties: props, delegate: self, completion: { (result, conversationClient) in
            if (result.isSuccessful) {
                self.conversationsClient = conversationClient
                if (self.conversationsClient != nil) {
                    self.setFcmToken()
                }
                self.conversationsClient?.delegate = self
            } else {
                self.conversationsClient = nil
            }
        })
    }
    
    func shutdown() {
        conversationsClient!.shutdown()
        conversationsClient = nil
    }
    
    private func setFcmToken() {
        //TODO: register firebase token
    }
    
    func getListConversation() {
        conversationsClient?.myConversations()?.forEach({ (conversation) in
            conversations[conversation.sid!] = ConversationModel(conversation: conversation)
        })
        refreshChannelList()
    }
    
    func getmessages(conversationArgument: ConversationArgument) {
        let conversationModel = conversations[conversationArgument.sid!]
        conversationModel?.getConversation(listener: { (conversation) in
            MessageClient.instance.setConversation(conversation: conversation)
            MessageClient.instance.setDelegate(delegate: self)
            MessageClient.instance.addListener()
            MessageClient.instance.getLastMessage()
        })
    }
    
    func removeConversationListener() {
        MessageClient.instance.removeListener()
    }
    
    func joinConversation(conversationArgument: ConversationArgument) {
        let conversationModel = conversations[conversationArgument.sid!]
        conversationModel?.getConversation(listener: { (conversation) in
            conversation.join { (result) in
                if (result.isSuccessful) {
                    self.delegate?.joinChannelSuccess()
                } else {
                    self.delegate?.joinChannelError()
                }
            }
        })
    }
    
    func sendMessage(message: String) {
        MessageClient.instance.sendMessage(message: message)
    }
    
    func deleteMessage(messageId: String) {
        MessageClient.instance.deleteMessage(messageId: messageId)
    }
    
    func updateMessage(messageArgument: UpdateMessageArgument) {
        MessageClient.instance.updateMessage(messageId: messageArgument.messageId, body: messageArgument.messageBody)
    }
    
    func createConversation(conversationName: String) {
        conversationsClient!.createConversation(options: [TCHConversationOptionFriendlyName: conversationName]) { (result, conversation) in
            if (result.isSuccessful) {
                print("create conversation success")
                self.delegate?.createChannelResult(result: true)
                self.conversations[conversation!.sid!] = ConversationModel(conversation: conversation!)
                self.refreshChannelList()
            } else {
                print("create conversation error")
                self.delegate?.createChannelResult(result: result.error!.description)
            }
        }
    }
    
    func inviteByIdentity(identity: String) {
        MessageClient.instance.addParticipantByIdentity(identity: identity)
    }
    
    func typing() {
        MessageClient.instance.typing()
    }
    
    func getMessageBefore() {
        MessageClient.instance.getMessageBefore()
    }
}

extension BasicChatClient: TwilioConversationsClientDelegate {
    func conversationsClientTokenExpired(_ client: TwilioConversationsClient) {
        accessToken = nil
        if (conversationsClient != nil) {
            delegate?.generateNewAccessToken()
        }
    }
    
    func conversationsClientTokenWillExpire(_ client: TwilioConversationsClient) {
        if (conversationsClient != nil) {
            delegate?.generateNewAccessToken()
        }
    }
}

extension BasicChatClient: TCHConversationDelegate {
    func conversationsClient(_ client: TwilioConversationsClient, conversationDeleted conversation: TCHConversation) {
        print("onConversationDeleted: \(conversation)")
        conversations.removeValue(forKey: conversation.sid!)
        refreshChannelList()
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, updated: TCHConversationUpdate) {
        print("onConversationUpdated: \(conversation)")
        conversations[conversation.sid!] = ConversationModel(conversation: conversation)
        refreshChannelList()
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversationAdded conversation: TCHConversation) {
        print("onConversationAdded: \(conversation)")
        conversations[conversation.sid!] = ConversationModel(conversation: conversation)
        refreshChannelList()
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if (status == TCHClientSynchronizationStatus.completed) {
            delegate?.onCreateBasicChatClientComplete()
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, synchronizationStatusUpdated status: TCHConversationSynchronizationStatus) {
        refreshChannelList()
    }

    private func refreshChannelList() {
        delegate?.refreshChannelList()
    }
}

extension BasicChatClient: BasicChatClientDelegate {
    func getMessageCompleted() {
        delegate?.refreshMessagesList()
    }
    
    func removeMessageSuccess(messageItemArgument: MessageItemArgument) {
        delegate?.removeMessageSuccess(messageItemArgument: messageItemArgument)
    }
    
    func updateMessageSuccess(messageItemArgument: MessageItemArgument) {
        delegate?.updateMessageSuccess(messageItemArgument: messageItemArgument)
    }
    
    func onTypingStarted(description: String) {
        delegate?.onTypingStarted(description: description)
    }
    
    func onTypingEnded(description: String) {
        delegate?.onTypingEnded(description: description)
    }
    
    func loadMoreMessageComplete(list: [MessageItemArgument]) {
        delegate?.loadMoreMessageComplete(list: list)
    }
    
    
}

protocol BasicChatClientDelegate {
    func getMessageCompleted()
    func removeMessageSuccess(messageItemArgument: MessageItemArgument)
    func updateMessageSuccess(messageItemArgument: MessageItemArgument)
    func onTypingStarted(description: String)
    func onTypingEnded(description: String)
    func loadMoreMessageComplete(list: [MessageItemArgument])
}
