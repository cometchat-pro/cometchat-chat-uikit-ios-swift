//
//  HomeScreen.swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 17/10/24.
//

import UIKit
import AVFoundation
import CometChatUIKitSwift
import CometChatSDK

class HomeScreenViewController: UITabBarController {
    
    lazy var conversations: CometChatConversations = {
        let conversations = CometChatConversations()
        conversations.set(itemClickListener: { [weak self] conversation, indexPath in
            let messages = MessagesVC()
            messages.group = (conversation.conversationWith as? Group)
            messages.user = (conversation.conversationWith as? CometChatSDK.User)
            self?.navigationController?.pushViewController(messages, animated: true)
        })
        return conversations
    }()
    
    #if canImport(CometChatCallsSDK)
    lazy var calls: CometChatCallLogs = {
        let calls = CometChatCallLogs()
        calls.goToCallLogDetail = { callLog, user, group in
            let callDetails = CallLogDetailsVC()
            callDetails.currentUser = user
            callDetails.currentGroup = group
            callDetails.callLog = callLog
            self.navigationController?.pushViewController(callDetails, animated: true)
        }
        return calls
    }()
    #endif
    
    lazy var users: CometChatUsers = {
        let users = CometChatUsers()
        users.setOnItemClick(onItemClick: { [weak self] users, indexPath in
            let messages = MessagesVC()
            messages.user = users
            self?.navigationController?.pushViewController(messages, animated: true)
        })
        return users
    }()
        
    lazy var groups: CometChatGroups = {
                
        let groups = CometChatGroups()
        groups.rightBarButtonItem = [
            UIBarButtonItem(
                image: UIImage(named: "groups-create"),
                style: .done,
                target: self,
                action: #selector(tapCreate)
            )
        ]
        groups.joinPasswordProtectedGroup = { [weak self] group in
            let joinGroupVC = JoinPasswordProtectedGroupVC()
            joinGroupVC.group = group
            joinGroupVC.onGroupJoined = { [weak joinGroupVC] group in
                joinGroupVC?.dismiss(animated: true)
                let messages = MessagesVC()
                messages.group = group
                self?.navigationController?.pushViewController(messages, animated: true)
            }
            if let self = self {
                presentViewControllerBottomSheet(from: self, to: joinGroupVC, height: 378)
            }
        }
        groups.setOnItemClick { [weak self] group, indexPath in
            let messages = MessagesVC()
            messages.group = group
            self?.navigationController?.pushViewController(messages, animated: true)
        }


        return groups
    }()
    
    lazy var lastSelectedIndex = 0
    var loggedInUserAvatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = CometChatTheme.backgroundColor01.withAlphaComponent(0.5)
        self.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        super.viewWillAppear(animated)
        
        buildAvatarBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if lastSelectedIndex == self.selectedIndex {
            #if canImport(CometChatCallsSDK)
            switch self.selectedIndex {
            case 0:
                if conversations.tableView.numberOfRows(inSection: 0) > 0{
                    conversations.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case 1:
                if calls.tableView.numberOfRows(inSection: 0) > 0{
                    calls.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case 2:
                if users.tableView.numberOfRows(inSection: 0) > 0{
                    users.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case 3:
                if groups.tableView.numberOfRows(inSection: 0) > 0{
                    groups.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            default:
                break
            }
            #else
            switch self.selectedIndex {
            case 0:
                if conversations.tableView.numberOfRows(inSection: 0) > 0{
                    conversations.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case 1:
                if users.tableView.numberOfRows(inSection: 0) > 0{
                    users.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case 2:
                if groups.tableView.numberOfRows(inSection: 0) > 0{
                    groups.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            default:
                break
            }
            #endif
        } else {
            lastSelectedIndex = self.selectedIndex
        }
    }
    
    func buildAvatarBarButtonItem() {
        
        let customButton = UIButton(type: .custom)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        
        var widthAnchor = customButton.widthAnchor.constraint(equalToConstant: 24)
        widthAnchor.priority = .required
        widthAnchor.isActive = true
        
        var heightAnchor = customButton.heightAnchor.constraint(equalToConstant: 24)
        heightAnchor.priority = .required
        heightAnchor.isActive = true

        if let imageURL = URL(string: "\(CometChat.getLoggedInUser()?.avatar ?? "")") {
            UIImageView.downloaded(from: imageURL) { image in
                if image == nil {
                    let image = UIImageView(frame: .init(origin: .zero, size: CGSize(width: 24, height: 24)))
                    customButton.setImage(AvatarUtils.setImageSnap(text: CometChat.getLoggedInUser()?.name ?? "", color: CometChatTheme.primaryColor, textAttributes: [.font: CometChatTypography.Caption1.medium, .foregroundColor: CometChatTheme.white], view: image), for: .normal)

                } else {
                    customButton.setImage(image, for: .normal)
                    customButton.imageView?.contentMode = .scaleAspectFill
                }
            }
        } else {
            let image = UIImageView(frame: .init(origin: .zero, size: CGSize(width: 24, height: 24)))
            customButton.setImage(AvatarUtils.setImageSnap(text: CometChat.getLoggedInUser()?.name ?? "", color: CometChatTheme.primaryColor, textAttributes: [.font: CometChatTypography.Caption1.medium, .foregroundColor: CometChatTheme.white], view: image), for: .normal)
        }
        
        customButton.imageView?.layer.cornerRadius = 12
        customButton.imageView?.clipsToBounds = true
        let logoutBarButtonItem = UIBarButtonItem(customView: customButton)
    
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let menu = UIMenu(title: "\(appVersion ?? "v5.0.0")", children: [
            UIAction(title: "Create conversation", image: UIImage(systemName: "plus.bubble.fill"), handler: { _ in
                let startNewConversationNVC = UINavigationController(rootViewController: CreateConversationVC())
                startNewConversationNVC.hidesBottomBarWhenPushed = true
                self.navigationController?.present(startNewConversationNVC, animated: true)
            }),
            UIAction(title: "\(CometChat.getLoggedInUser()?.name ?? "")", image: UIImage(systemName: "person.circle"), handler: { _ in

            }),
            UIAction(title: "Logout", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), attributes: .destructive, handler: { _ in
                self.logoutTapped()
            }),
        ])

        
        if #available(iOS 14.0, *) {
            customButton.menu = menu
            customButton.showsMenuAsPrimaryAction = true
        }
        
        logoutBarButtonItem.tintColor = CometChatTheme.primaryColor
        conversations.rightBarButtonItem = [logoutBarButtonItem]
    }
    
    //Logging out
    @objc func logoutTapped() {
        
        //Changing root window
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.setRootViewController(UINavigationController(rootViewController: LoginWithUidVC()))

        UserDefaults.standard.removeObject(forKey: "appID")
        UserDefaults.standard.removeObject(forKey: "region")
        UserDefaults.standard.removeObject(forKey: "authKey")
        
        //Logging out from CometChatSDK
        CometChat.logout(onSuccess: { success in
        }, onError: { error in })
    }
    
    @objc func tapCreate(){
        let vc = CreateGroupVC()
        vc.openGroupChat = { [weak self] group in
            let messages = MessagesVC()
            messages.group = group
            self?.navigationController?.pushViewController(messages, animated: true)
        }
        presentViewControllerBottomSheet(from: self, to: vc, height: 356)
    }
    
    func setupTabs() {
        conversations.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 0)
        conversations.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        
        #if canImport(CometChatCallsSDK) //if CometChatCalls SDK is not included
        calls.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(systemName: "phone"), tag: 0)
        calls.tabBarItem.selectedImage = UIImage(systemName: "phone.fill")
        #endif

        users.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person"), tag: 1)
        users.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        groups.tabBarItem = UITabBarItem(title: "Groups", image: UIImage(systemName: "person.2"), tag: 1)
        groups.tabBarItem.selectedImage = UIImage(systemName: "person.2.fill")
        
        
        #if canImport(CometChatCallsSDK)
        viewControllers = [
            UINavigationController(rootViewController: conversations),
            UINavigationController(rootViewController: calls),
            UINavigationController(rootViewController: users),
            UINavigationController(rootViewController: groups),
        ]
        #else
        viewControllers = [
            UINavigationController(rootViewController: conversations),
            UINavigationController(rootViewController: users),
            UINavigationController(rootViewController: groups),
        ]
        #endif
        
        tabBar.tintColor = CometChatTheme.primaryColor
        tabBar.isTranslucent = true
    }
}

extension UIViewController {
    func presentViewControllerBottomSheet(from presentingVC: UIViewController, to viewControllerToPresent: UIViewController, height: Int) {
        if #available(iOS 15.0, *) {
            if let sheet = viewControllerToPresent.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    let customDetent = UISheetPresentationController.Detent.custom { _ in
                        return CGFloat(height)
                    }
                    sheet.detents = [customDetent]
                }
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            viewControllerToPresent.modalPresentationStyle = .pageSheet
        } else {
            viewControllerToPresent.modalPresentationStyle = .pageSheet
        }

        presentingVC.present(viewControllerToPresent, animated: true, completion: nil)
    }
}
