//
//  MessageClient.swift
//  Runner
//
//  Created by KienNT on 10/27/21.
//

import Foundation
import TwilioConversationsClient

class MessageClient: NSObject {
    static var instance: MessageClient = MessageClient()
    private var conversation: TCHConversation? = nil
    var messageItemList: [MessageItemArgument] = []
    private var canLoadMore = true
    private var delegate: BasicChatClientDelegate? = nil
    
    func setDelegate(delegate: BasicChatClientDelegate) {
        self.delegate = delegate
    }
    
    func setConversation(conversation: TCHConversation) {
        self.conversation = conversation
    }
    
    func getLastMessage(count: UInt = 50) {
        conversation?.getLastMessages(withCount: count, completion: { (result, listMessage) in
            self.canLoadMore = UInt(listMessage?.count ?? 0) == count
            self.messageItemList.removeAll()
            let participantsList = self.conversation?.participants()
            if let participantsList = participantsList {
                if (listMessage?.isEmpty == false) {
                    listMessage?.forEach({ (message) in
                        self.messageItemList.append(MessageItemArgument(message: message, members: participantsList))
                    })
                }
            }
            self.delegate?.getMessageCompleted()
        })
    }
    
    func removeListener() {
        conversation?.delegate = nil
    }
    
    func addListener() {
        conversation?.delegate = self
    }
    
    func sendMessage(message: String) {
        conversation?.sendMessage(with: TCHMessageOptions.init().withBody(message), completion: { (result, message) in
            if (result.isSuccessful) {
                print("send message success")
            } else {
                print("send message failed")
            }
        })
    }
    
    func deleteMessage(messageId: String) {
        let messageItemArgument = messageItemList.first { (messageItem) -> Bool in
            messageItem.message?.sid == messageId
        }
        
        if let messageItemArgument = messageItemArgument {
            conversation?.remove(messageItemArgument.message!, completion: { (result) in
                if (result.isSuccessful) {
                    print("delete message success")
                } else {
                    print("delete message failed")
                }
            })
        }
    }
    
    func updateMessage(messageId: String?, body: String?) {
        let messageItemArgument = messageItemList.first { (messageItem) -> Bool in
            messageItem.message?.sid == messageId
        }
        
        if let messageItemArgument = messageItemArgument {
            messageItemArgument.message?.updateBody(body!, completion: { (result) in
                if (result.isSuccessful) {
                    print("update message success")
                } else {
                    print("update message failed")
                }
            })
        }
    }
    
    func addParticipantByIdentity(identity: String) {
        conversation?.addParticipant(byIdentity: identity, attributes: nil, completion: { (result) in
            if(result.isSuccessful) {
                print("add participant success")
            } else {
                print("add participant failed")
            }
        })
    }
    
    func typing() {
        conversation?.typing()
    }
    
    func getMessageBefore(count: UInt = 50) {
        if (messageItemList.count > 0 && canLoadMore) {
            let messageIndex = messageItemList.first?.message?.index
            
            if let messageIndex = messageIndex {
                conversation?.getMessagesBefore(UInt(messageIndex), withCount: count, completion: { (result, listMessage) in
                    if (result.isSuccessful) {
                        self.canLoadMore = UInt(listMessage?.count ?? 0) == count
                        let participantsList = self.conversation?.participants()
                        var listTemp: [MessageItemArgument] = []
                        if let participantsList = participantsList {
                            listMessage?.forEach({ (message) in
                                listTemp.append(MessageItemArgument(message: message, members: participantsList))
                            })
                        }
                        self.messageItemList.insert(contentsOf: listTemp, at: 0)
                        self.delegate?.loadMoreMessageComplete(list: listTemp)
                        print("get message before: \(listMessage)")
                    } else {
                        print("get message before error")
                    }
                })
            }
        }
    }
}

extension MessageClient: TCHConversationDelegate {
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, messageAdded message: TCHMessage) {
        let participantsList = self.conversation?.participants()
        if let participantsList = participantsList {
            messageItemList.append(MessageItemArgument(message: message, members: participantsList))
            delegate?.getMessageCompleted()
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, message: TCHMessage, updated: TCHMessageUpdate) {
        let participantsList = self.conversation?.participants()
        if let participantsList = participantsList {
            let index = messageItemList.firstIndex { (messageItemArgument) -> Bool in
                messageItemArgument.message?.sid == message.sid
            }
            let messageItemArgument = MessageItemArgument(message: message, members: participantsList)
            if let index = index {
                messageItemList.remove(at: index)
                messageItemList.insert(messageItemArgument, at: index)
            }
            delegate?.updateMessageSuccess(messageItemArgument: messageItemArgument)
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, messageDeleted message: TCHMessage) {
        let participantsList = self.conversation?.participants()
        if let participantsList = participantsList {
            messageItemList.removeAll { (messageItemArgument) -> Bool in
                messageItemArgument.message?.sid == message.sid
            }
            delegate?.removeMessageSuccess(messageItemArgument: MessageItemArgument(message: message, members: participantsList))
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, typingStartedOn conversation: TCHConversation, participant: TCHParticipant) {
        delegate?.onTypingStarted(description: participant.identity! + " is typing....")
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, typingEndedOn conversation: TCHConversation, participant: TCHParticipant) {
        delegate?.onTypingEnded(description: "")
    }
}
