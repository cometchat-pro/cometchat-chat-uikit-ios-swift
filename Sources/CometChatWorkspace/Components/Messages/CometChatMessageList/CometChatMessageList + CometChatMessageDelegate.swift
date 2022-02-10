//
//  CometChatMessageList + CometChatMessageDelegate.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 31/01/22.
//

import Foundation
import CometChatPro

extension CometChatMessageList: CometChatMessageDelegate {

    func onTextMessageReceived(textMessage: TextMessage) {
        switch textMessage.receiverType {
        case .user:
            if textMessage.sender?.uid == currentUser?.uid {
                self.appendMessage(message: textMessage)
            }
        case .group:
            if textMessage.receiverUid == currentGroup?.guid {
                self.appendMessage(message: textMessage)
            }
        @unknown default: break
        }
       
    }
    
    func onMediaMessageReceived(mediaMessage: MediaMessage) {
        switch mediaMessage.receiverType {
        case .user:
            if mediaMessage.sender?.uid == currentUser?.uid {
                self.appendMessage(message: mediaMessage)
            }
        case .group:
            if mediaMessage.receiverUid == currentGroup?.guid {
                self.appendMessage(message: mediaMessage)
            }
        @unknown default: break
        }
    }
    
    func onCustomMessageReceived(customMessage: CustomMessage) {
        switch customMessage.receiverType {
        case .user:
            if customMessage.sender?.uid == currentUser?.uid || customMessage.sender?.uid == CometChat.getLoggedInUser()?.uid {
                self.appendMessage(message: customMessage)
            }
        case .group:
            if customMessage.receiverUid == currentGroup?.guid {
                self.appendMessage(message: customMessage)
            }
        @unknown default: break
        }
    }
    
    func onMessagesDelivered(receipt: MessageReceipt) {
        if let indexpath = self.chatMessages.indexPath(where: {$0.id == Int(receipt.messageId)}){
            let message = chatMessages[indexpath.section][indexpath.row]
            message.deliveredAt = receipt.deliveredAt
            self.updateMessage(message: message)
        }
    }
    
    func onMessagesRead(receipt: MessageReceipt) {
        if let indexpath = self.chatMessages.indexPath(where: {$0.id == Int(receipt.messageId)}){
            let message = chatMessages[indexpath.section][indexpath.row]
            message.readAt = receipt.readAt
            self.updateMessage(message: message)
        }
    }
}

