import Foundation

public struct UIConstants {
    static var channel = "ios_chat_ui_kit"
    static var packageName = "ios_chat_ui_kit"
}

internal struct UIKitConstants {
    static var version = "5.0.0-beta.2"
    static var messageId = "messageId"
    static var conversationId = "conversationId"
    static var senderId = "senderId"
    static var timeZoneCode = "timezoneCode"
}

public struct MessagesConstants {
    public static var parentMessageId = "parentMessageId"
}

public struct  MessageCategoryConstants {
    public static var message = "message"
    public static var custom = "custom"
    public static var action = "action"
    public static var call = "call"
    public static var interactive = "interactive"
}

public struct  MessageTypeConstants {
    public static var text = "text"
    public static var file = "file"
    public static var image = "image"
    public static var audio = "audio"
    public static var video = "video"
    public static var poll = "extension_poll"
    public static var sticker = "extension_sticker"
    public static var document = "extension_document"
    public static var whiteboard = "extension_whiteboard"
    public static var meeting = "meeting"
    public static var location = "location"
    public static var groupMember = "groupMember"
    public static var message = "message"
    public static var form = "form"
    public static var card = "card"
    public static var scheduler = "scheduler"
}

public struct ComposerAttachmentConstants {
    public static let camera = "camera"
    public static let gallery = "gallery"
    public static let audio = "audio"
    public static let file = "file"
}

public struct SchedulerMessageConstants {
    static var defaultDateFormate = "yyyy-MM-dd"
}

public struct  ReceiverTypeConstants {
    static var user = "user"
    static var group = "group"
}

public struct  MessageOptionConstants {
    public static var editMessage = "editMessage"
    public static var deleteMessage = "deleteMessage"
    public static var translateMessage = "translateMessage"
    public static var reactToMessage = "reactToMessage"
    public static var sendMessagePrivately = "sendMessagePrivately"
    public static var replyMessagePrivately = "replyMessagePrivately"
    public static var replyMessage = "replyMessage"
    public static var replyInThread = "replyInThread"
    public static var messageInformation = "messageInformation"
    public static var copyMessage = "copyMessage"
    public static var shareMessage = "shareMessage"
    public static var messagePrivately = "messagePrivately"
    public static var forwardMessage = "forwardMessage"
}

@objc public enum MessageBubbleAlignment: Int {
    case left
    case right
    case center
}


public enum  MessageBubbleTimeAlignment {
    case top
    case bottom
}

public enum MessageStatus: Int {
    case inProgress
    case success
    case error
}

public enum MessageListAlignment {
    
    case standard
    case leftAligned
    
}

public struct  MetadataConstants {
    
    public static var replyMessage = "reply-message"
    public static var sticker_url = "sticker_url"
    public static var sticker_name = "sticker_name"
    public static var liveReaction = "live_reaction"
    
}

public struct  GroupOptionConstants {
    public static var leave = "leave"
    public static var delete = "delete"
    public static var viewMembers = "viewMembers"
    public static var addMembers = "addMembers"
    public static var bannedMembers = "bannedMembers"
    public static var voiceCall = "voiceCall"
    public static var videoCall = "videoCall"
    public static var viewInformation = "viewInformation"
}

public struct  GroupMemberOptionConstants {
    public static var kick = "kick"
    public static var ban = "ban"
    public static var unban = "unban"
    public static var changeScope = "changeScope"
}

public struct  UserOptionConstants {
    public static var unblock = "unblock"
    public static var block = "block"
    public static var blockUnblock = "blockUnblock"
    public static var viewProfile = "viewProfile"
    public static var voiceCall = "voiceCall"
    public static var videoCall = "videoCall"
    public static var viewInformation = "viewInformation"
}

public struct CallLogsDetailsConstants {
    public static var avatarID = "CallLogAvatar"
    public static var participantID = "CallLogParticipant"
    public static var recordingID = "CallLogRecording"
    public static var historyID = "CallLogHistory"
    public static var primaryDetailsTemplateID = "CallLogDetailsPrimaryCallLogDetailsTemplate"
    public static var secondaryDetailsTemplateID = "SecondaryCallLogDetailsTemplate"
}

public struct  ConversationOptionConstants {
    public static var delete = "delete"
}

public struct  ConversationTypeConstants {
    public static var users = "users"
    public static var groups = "groups"
    public static var both = "both"
}


public struct  GroupTypeConstants {
    public static var privateGroup = "private"
    public static var passwordProtectedGroup = "password"
    public static var publicGroup = "public"
}


public struct  GroupMemberScope {
    public static var users = "admin"
    public static var groups = "moderator"
    public static var both = "participant"
}

public enum CometChatDatePattern {
    case time
    case dayDate
    case dayDateTime
    case custom(String)
}

public struct DetailTemplateConstants {
    static var primaryActions = "primaryActions"
    static var secondaryActions = "secondaryActions"
}

public enum SelectionMode {
    case single
    case multiple
    case none
}

public enum UsersListenerConstants {
    static let userListener = "users-user-listener"
    
}

public enum GroupsListenerConstants {
    static let groupListener = "groups-group-listener"
    static let messagesListener = "groups-message-listener"
}

public enum ConversationsListenerConstants {
    static let userListener = "conversations-user-listener"
    static let groupListener = "conversations-group-listener"
    static let messagesListener = "conversations-message-listener"
}

public enum MessagesListenerConstants {
    static let userListener = "messages-user-listener"
    static let groupListener = "messages-group-listener"
    static let messagesListener = "messages-message-listener"
}

public enum GroupMembersListenerConstants {
    static let groupListener = "group-members-group-listener"
}
