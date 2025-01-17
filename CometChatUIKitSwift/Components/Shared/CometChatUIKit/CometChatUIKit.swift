//
//  Created by Pushpsen Airekar on 01/02/22.
//

import Foundation
import CometChatSDK
import CoreMedia



final public class CometChatUIKit {
    
    public enum ApiStatus {
        case success(User)
        case onError(CometChatException)
    }
    
    public static var bundle =  Bundle(for: CometChatUIKit.self)
    static var uiKitSettings: UIKitSettings?
    static var uiKitError: CometChatException = CometChatException(errorCode: "Err_101", errorDescription: "UIKit Settings are not initialised, Try calling CometChatUIKit.init method first.")
    static var sdkEventInitializer: SDKEventInitializer?
    static public let soundManager = CometChatSoundManager()
    
    #if canImport(CometChatCallsSDK)
    static var callingExtension: CallingExtension?
    #endif
    
    @discardableResult
    public init(uiKitSettings: UIKitSettings, result: @escaping (Result<Bool, Error>) -> Void) {
        CometChat.init(appId: uiKitSettings.appID, appSettings: AppSettings(builder: uiKitSettings.appSettingsBuilder)) { isSuccess  in
            CometChatUIKit.uiKitSettings = uiKitSettings
            if isSuccess {
                CometChat.setSource(resource: "uikit-v5", platform: "ios", language: "swift", version: UIKitConstants.version)
                #if canImport(CometChatCallsSDK)
                if !uiKitSettings.isCallingDisabled {
                    if let customCallingExtension = uiKitSettings.callingExtensions {
                        CometChatUIKit.callingExtension = customCallingExtension
                    } else {
                        CometChatUIKit.callingExtension = CallingExtension()
                    }
                    CometChatUIKit.callingExtension?.enable()
                }
                #endif
                CometChatUIKit.sdkEventInitializer = SDKEventInitializer()
                CometChatUIKit.configureAI(extensions: uiKitSettings.aiExtensions)
                CometChatUIKit.configureExtensions(extensions: uiKitSettings.extensions)
                CometChatUIKit.registerForVOIP(with: uiKitSettings.voipToken)
                CometChatUIKit.registerForPushNotification(with: uiKitSettings.deviceToken)
                CometChatUIKit.registerForFCM(with: uiKitSettings.fcmKey)
            }
            result(.success(isSuccess))
        } onError: { error in
            result(.failure(error as! Error))
        }
    }
    
    // Registered Push Notification.
    private static func registerForPushNotification(with token: String?) {
        guard let token = token, token != "" else { return }
        register(with: token, VOIP: false)
    }
    
    private static func register(with token: String, VOIP: Bool? = true) {
        CometChat.registerTokenForPushNotification(token: token, settings: ["voip": VOIP]) { (success) in
            print("onSuccess to registerTokenForPushNotification: \(success)")
        }
            onError: { (error) in
            print("error to registerTokenForPushNotification")
        }
    }
    
    private static func registerForFCM(with FCMToken: String?) {
        guard let token = FCMToken, token != "" else { return }
        CometChat.registerTokenForPushNotification(token: token, onSuccess: { (sucess) in
            print("token registered \(sucess)")
        }) { (error) in
            print("token registered error \(String(describing: error?.errorDescription))")
        }
    }
    
    private static func registerForVOIP(with token: String?) {
        guard let token = token, !token.isEmpty else { return }
        register(with: token)
    }
    
    private static func registerNotificationAndVOIP() {
        registerForVOIP(with: uiKitSettings?.voipToken)
        registerForPushNotification(with: uiKitSettings?.deviceToken)
        registerForFCM(with: uiKitSettings?.fcmKey)
    }
    
    static public func login(authToken: String, result: @escaping (ApiStatus) -> Void) {
        CometChat.login(authToken: authToken) {  user in
            if let uiKitSettings = uiKitSettings {
                CometChatUIKit.configureAI(extensions: uiKitSettings.aiExtensions)
                CometChatUIKit.configureExtensions(extensions: uiKitSettings.extensions)
            }
            registerNotificationAndVOIP()
            result(.success(user))
        } onError: { error in
            result(.onError(error))
            debugPrint(error.description)
        }
    }
    
    static private func configureAI(extensions: [ExtensionDataSource]?) {
        let extensions = extensions ?? DefaultExtensions.listOfAIExtensions()
        if  !extensions.isEmpty {
            if let extensions = extensions as? [ExtensionDataSource]  {
                for i in extensions {
                    i.enable()
                }
            }
        }
    }
    
    static private func configureExtensions(extensions: [ExtensionDataSource]?) {
        let extensions = extensions ?? DefaultExtensions.listOfExtensions()
        if  !extensions.isEmpty {
            if let extensions = extensions as? [ExtensionDataSource]  {
                for i in extensions {
                    i.enable()
                }
            }
        }
    }
    
    static public func login(uid: String, result: @escaping (ApiStatus) -> Void) {
        guard let authKey = CometChatUIKit.uiKitSettings?.authKey else { return result(.onError(uiKitError))}
        CometChat.login(UID: uid, authKey: authKey) { user in
            registerNotificationAndVOIP()
            result(.success(user))
            CometChatUIKit.configureExtensions(extensions: CometChatUIKit.uiKitSettings?.extensions)
            CometChatUIKit.configureAI(extensions: CometChatUIKit.uiKitSettings?.aiExtensions)
        } onError: { error in
            result(.onError(error))
            debugPrint(error.description)
        }
    }
    
   static public func create(user: User, result: @escaping (ApiStatus) -> Void) {
        guard let authKey = CometChatUIKit.uiKitSettings?.authKey else { return result(.onError(uiKitError)) }
        CometChat.createUser(user: user, authKey: authKey) { user in
            result(.success(user))
        } onError: { error in
            if let error = error {
                result(.onError(error))
                debugPrint(error.description)
            }
        }
    }
    
    static public func update(user: User, result: @escaping (ApiStatus) -> Void) {
        guard let authKey = CometChatUIKit.uiKitSettings?.authKey else { return result(.onError(uiKitError)) }
        CometChat.updateUser(user: user, authKey: authKey) { user in
            result(.success(user))
        } onError: { error in
            if let error = error {
                result(.onError(error))
                debugPrint(error.description)
            }
        }
    }
    
    static public func logout(user: User, result: @escaping (ApiStatus) -> Void) {
        CometChat.logout { isSuccess in
            result(.success(user))
        } onError: { error in
            result(.onError(error))
            debugPrint(error.description)
        }
    }
    
    static public func getLoggedInUser() -> User? {
        guard let user = CometChat.getLoggedInUser() else { return nil }
        return user
    }
}

//Methods related to Sending of messages
//=============================================
extension CometChatUIKit {
    
    public static func sendTextMessage(message: TextMessage) {
        
        if message.sender == nil { message.sender = CometChat.getLoggedInUser() }
        if message.muid == "" { message.muid = "\(NSDate().timeIntervalSince1970)" }
        if message.senderUid == "" { message.senderUid = CometChat.getLoggedInUser()?.uid ?? "" }
        
        CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.inProgress)
        CometChat.sendTextMessage(message: message) { textMessage in
            CometChatMessageEvents.ccMessageSent(message: textMessage, status: MessageStatus.success)
        } onError: { (error) in
            if let error =  error {
                CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.error)
            }
        }
    }

    public static func sendCustomMessage(message: CustomMessage) {
        
        if message.sender == nil { message.sender = CometChat.getLoggedInUser() }
        if message.muid == "" { message.muid = "\(NSDate().timeIntervalSince1970)" }
        if message.senderUid == "" { message.senderUid = CometChat.getLoggedInUser()?.uid ?? "" }
        
        CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.inProgress)
        CometChat.sendCustomMessage(message: message) { customMessage in
            CometChatMessageEvents.ccMessageSent(message: customMessage, status: MessageStatus.success)
        } onError: { error in
            if let error =  error {
                CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.error)
            }
        }
    }

    public static func sendMediaMessage(message: MediaMessage) {
        
        if message.sender == nil { message.sender = CometChat.getLoggedInUser() }
        if message.muid == "" { message.muid = "\(NSDate().timeIntervalSince1970)" }
        if message.senderUid == "" { message.senderUid = CometChat.getLoggedInUser()?.uid ?? "" }
        
        CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.inProgress)
        CometChat.sendMediaMessage(message: message) { mediaMessage in
            CometChatMessageEvents.ccMessageSent(message: mediaMessage, status: MessageStatus.success)
        } onError: { error in
            if let error =  error {
                CometChatMessageEvents.ccMessageSent(message: message, status: MessageStatus.error)
            }
        }
    }
}


extension CometChatUIKit {
    static public func getDataSource() -> DataSource {
        return ChatConfigurator.getDataSource()
    }
}

extension CometChatUIKit {
    /// `sendFormMessage` method is used to send formMessage
    /// - Parameters:
    ///     - `formMessage`: Specifies the `FormMessage` to be sent.
    ///     - `onSuccess`:  A callback that contains `FormMessage` object that is sent.
    ///     - `onError`:  A callback that contains `Error` object which contains errorCode and errorDescription. The callback is received only if there is an error  while sending `FormMessage`.
    /// - Returns: This method does not return anything.
    public static func sendFormMessage(_ formMessage: FormMessage, onSuccess: @escaping (FormMessage) -> (), onError:  @escaping (CometChatException?) -> ()) {
        
        let interactiveMessage = formMessage.interactiveMessage()
        interactiveMessage.sender = CometChat.getLoggedInUser()
        interactiveMessage.senderUid = CometChat.getLoggedInUser()?.uid ?? ""
        interactiveMessage.muid = "\(NSDate().timeIntervalSince1970)"
        
        CometChatMessageEvents.ccMessageSent(message: formMessage, status: MessageStatus.inProgress)
        CometChat.sendInteractiveMessage(message: interactiveMessage, onSuccess: { interactiveMessage in
            let formMessage = FormMessage.toFormMessage(interactiveMessage)
            onSuccess(formMessage)
            CometChatMessageEvents.ccMessageSent(message: formMessage, status: MessageStatus.success)
        }) { error in
            if let error =  error { 
                CometChatMessageEvents.ccMessageSent(message: formMessage, status: MessageStatus.error)
            }
            onError(error)
        }
        
    }
    
    /// `sendCardMessage` method is used to send formMessage
    /// - Parameters:
    ///     - `cardMessage`: Specifies the `CardMessage` to be sent.
    ///     - `onSuccess`:  A callback that contains `CardMessage` object that is sent.
    ///     - `onError`:  A callback that contains `Error` object which contains errorCode and errorDescription. The callback is received only if there is an error  while sending `CardMessage`.
    /// - Returns: This method does not return anything.
    public static func sendCardMessage(_ cardMessage: CardMessage, onSuccess: @escaping (CardMessage) -> (), onError:  @escaping (CometChatException?) -> ()) {
        
        let interactiveMessage = cardMessage.interactiveMessage()
        interactiveMessage.sender = CometChat.getLoggedInUser()
        interactiveMessage.senderUid = CometChat.getLoggedInUser()?.uid ?? ""
        interactiveMessage.muid = "\(NSDate().timeIntervalSince1970)"
        
        CometChatMessageEvents.ccMessageSent(message: cardMessage, status: MessageStatus.inProgress)
        CometChat.sendInteractiveMessage(message: interactiveMessage, onSuccess: { interactiveMessage in
            let cardMessage = CardMessage.toCardMessage(interactiveMessage)
            onSuccess(cardMessage)
            CometChatMessageEvents.ccMessageSent(message: cardMessage, status: MessageStatus.success)
        }) { error in
            if let error =  error { 
                CometChatMessageEvents.ccMessageSent(message: cardMessage, status: MessageStatus.error)
            }
            onError(error)
        }
        
    }
    
    public static func sendSchedulerMessage(schedulerMessage: SchedulerMessage, onSuccess: @escaping (SchedulerMessage) -> (), onError:  @escaping (CometChatException?) -> ()) {
        
        let interactiveMessage = SchedulerMessage.interactiveMessage(from: schedulerMessage)
        interactiveMessage.sender = CometChat.getLoggedInUser()
        interactiveMessage.senderUid = CometChat.getLoggedInUser()?.uid ?? ""
        interactiveMessage.muid = "\(NSDate().timeIntervalSince1970)"
        
        CometChatMessageEvents.ccMessageSent(message: schedulerMessage, status: MessageStatus.inProgress)
        CometChat.sendInteractiveMessage(message: interactiveMessage, onSuccess: { interactiveMessage in
            let schedulerMessage = SchedulerMessage.toSchedulerMessage(interactiveMessage)
            onSuccess(schedulerMessage)
            CometChatMessageEvents.ccMessageSent(message: schedulerMessage, status: MessageStatus.success)
        }) { error in
            if let error =  error { CometChatMessageEvents.ccMessageSent(message: schedulerMessage, status: MessageStatus.error) }
            onError(error)
        }
        
    }
}
