//
//  SceneDelegate.swift
//  Sample App v5
//
//  Created by Suryansh on 17/10/24.
//

import UIKit
import CometChatUIKitSwift
import CometChatSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var currentScene: UIScene?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        currentScene = scene
        
        if !AppConstants.APP_ID.isEmpty && !AppConstants.AUTH_KEY.isEmpty && !AppConstants.REGION.isEmpty{
            let defaults = UserDefaults.standard
            defaults.set(AppConstants.APP_ID, forKey: "appID")
            defaults.set(AppConstants.REGION, forKey: "region")
            defaults.set(AppConstants.AUTH_KEY, forKey: "authKey")
        }
        
        initialisationCometChatUIKit(completion: {
            if CometChat.getLoggedInUser() != nil {
                self.setRootViewController(UINavigationController(rootViewController: HomeScreenViewController()))
            } else {
                let appId = UserDefaults.standard.string(forKey: "appID") ?? ""
                let authKey = UserDefaults.standard.string(forKey: "authKey") ?? ""
                let region = UserDefaults.standard.string(forKey: "region") ?? ""
                
                if appId.isEmpty && authKey.isEmpty && region.isEmpty {
                    self.setRootViewController(ChangeAppCredentialsVC())
                } else {
                    self.setRootViewController(LoginWithUidVC())
                }
            }
        })        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func setRootViewController(_ viewController: UIViewController){
      
      guard let scene = (currentScene as? UIWindowScene) else { return }
      
        UIView.animate(withDuration: 0.2) {  [weak self] in
            guard let self else { return }
            window = UIWindow(frame: scene.coordinateSpace.bounds)
            window?.tintColor = CometChatTheme.primaryColor
            window?.windowScene = scene
            
            //adding fade transition
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3 // Adjust the duration for smoother or faster transitions
            window?.layer.add(transition, forKey: kCATransition)
            
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
      
    }
    
    func initialisationCometChatUIKit(completion: @escaping() -> ()) {
        let appId = UserDefaults.standard.string(forKey: "appID") ?? ""
        let authKey = UserDefaults.standard.string(forKey: "authKey") ?? ""
        let region = UserDefaults.standard.string(forKey: "region") ?? ""
        
        if appId.isEmpty && authKey.isEmpty && region.isEmpty{
            print("Incorrect App Constants")
            completion()
        } else {
            let uikitSettings = UIKitSettings()
            uikitSettings.set(appID: appId)
                .set(authKey: authKey)
                .set(region: region)
                .subscribePresenceForAllUsers()
                .build()
            
            CometChatUIKit.init(uiKitSettings: uikitSettings, result: {
                result in
                switch result {
                case .success(_):
                    CometChat.setSource(resource: "uikit-v5", platform: "ios", language: "swift")
                    completion()
                    break
                case .failure(let error):
                    print( "Initialization Error:  \(error.localizedDescription)")
                    print( "Initialization Error Description:  \(error.localizedDescription)")
                    break
                }
            })
        }
    }


}

