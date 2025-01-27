//
//  File.swift
//  
//
//  Created by Pushpsen Airekar on 16/02/23.
//

import Foundation
import CometChatSDK

class SmartReplyExtensionDecorator: DataSourceDecorator {
    
    var dataStamp:Double?
    var _messageListenerId: String?
    var loggedInUser: User?
    var isVisible = false
    var id = [String: Any]()
    
    override init(dataSource: DataSource) {
        super.init(dataSource: dataSource)
        self.dataStamp = Date().timeIntervalSince1970
        self._messageListenerId = "ExtensionMessageListener"
        self.loggedInUser = CometChat.getLoggedInUser()
        disconnect()
        connect()
    }
    
    override func getId() -> String {
        return "smart-reply"
    }
    
    public func connect() {
        if let _messageListenerId = _messageListenerId {
            CometChatMessageEvents.addListener(_messageListenerId, self)
        }
    }
    
    public func disconnect() {
        if let _messageListenerId = _messageListenerId {
            CometChatMessageEvents.removeListener(_messageListenerId)
            CometChatUIEvents.removeListener(_messageListenerId)
        }
    }
    
    public func getReplies(message: BaseMessage) -> [String]? {
        var replies = [String]()
        if let map = ExtensionModerator.extensionCheck(baseMessage: message), !map.isEmpty && map.containsKey(ExtensionConstants.smartReply), let smartReplies = map[ExtensionConstants.smartReply] {
            
            if smartReplies.containsKey("reply_neutral") {
                if let reply_neutral = smartReplies["reply_neutral"] as? String {
                    replies.append(reply_neutral)
                }
            }
            if smartReplies.containsKey("reply_negative") {
                if let reply_negative = smartReplies["reply_negative"] as? String {
                    replies.append(reply_negative)
                }
            }
            if smartReplies.containsKey("reply_positive") {
                if let reply_positive = smartReplies["reply_positive"] as? String {
                    replies.append(reply_positive)
                }
            }
            if !replies.isEmpty {
                replies.append("")
            }
        }
        return replies
    }
    
    func getID(for message: BaseMessage) -> [String: Any] {
        var id = [String:Any]()
        if let receiver = message.receiver {
            if receiver is User {
                id["uid"] = message.sender?.uid
            } else if receiver is Group {
                id["guid"] = message.receiverUid
            }
        }
        if message.parentMessageId != 0 {
            id["parentMessageId"] = message.parentMessageId
        }
        
        return id
    }
    
    public func presentSmartReplies(for textMessage: BaseMessage) {
        id = getID(for: textMessage)
        if let replies = getReplies(message: textMessage) , !replies.isEmpty {
            let smartRepliesView = CometChatSmartReplies()
            smartRepliesView.translatesAutoresizingMaskIntoConstraints = false
            smartRepliesView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            smartRepliesView.set(titles: replies)
            smartRepliesView.setOnClick { [weak self] title in
                guard let self = self else { return }
                if title == "" {
                    self.isVisible = false
                    CometChatUIEvents.hidePanel(id: id, alignment: .composerTop)
                } else {
                    let newMessage: TextMessage?
                    if textMessage.receiverType == .user {
                        let receiverUid = textMessage.sender?.uid ?? ""
                        newMessage = TextMessage(receiverUid: receiverUid, text: title, receiverType: .user)
                    } else {
                        let receiverUid = textMessage.receiverUid
                        newMessage = TextMessage(receiverUid: receiverUid, text: title, receiverType: .group)
                    }
                    if let newMessage = newMessage {
                        newMessage.muid = "\(Int(Date().timeIntervalSince1970))"
                        newMessage.senderUid = CometChat.getLoggedInUser()?.uid ?? ""
                        newMessage.sender = CometChat.getLoggedInUser()
                        newMessage.parentMessageId = textMessage.parentMessageId
                        CometChatUIKit.sendTextMessage(message: newMessage)
                        self.isVisible = false
                        CometChatUIEvents.hidePanel(id: id, alignment: .composerTop)
                    }
                }
            }
            self.isVisible = true
            CometChatUIEvents.showPanel(id: id, alignment: .composerTop, view: smartRepliesView)
        }else{
            self.isVisible = false
            CometChatUIEvents.hidePanel(id: id, alignment: .composerTop)
        }
    }
}

extension SmartReplyExtensionDecorator: CometChatMessageEventListener {
    func ccMessageSent(message: CometChatSDK.BaseMessage, status: MessageStatus) {
        if isVisible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                CometChatUIEvents.hidePanel(id: self.id, alignment: .composerTop)
            }
        }
    }
    
    func onMediaMessageReceived(mediaMessage: CometChatSDK.MediaMessage) {
        if isVisible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                CometChatUIEvents.hidePanel(id: self.id, alignment: .composerTop)
            }
        }
    }
    
    func onCustomMessageReceived(customMessage: CometChatSDK.CustomMessage) {
        if isVisible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                CometChatUIEvents.hidePanel(id: self.id, alignment: .composerTop)
            }
        }
    }
    
    func onFormMessageReceived(message: FormMessage) {
        if isVisible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                CometChatUIEvents.hidePanel(id: self.id, alignment: .composerTop)
            }
        }
    }
    
    func onCardMessageReceived(message: CardMessage) {
        if isVisible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                CometChatUIEvents.hidePanel(id: self.id, alignment: .composerTop)
            }
        }
    }
    
    func onTextMessageReceived(textMessage: TextMessage) {
        DispatchQueue.main.async {
            self.presentSmartReplies(for: textMessage)
        }
    }
}
