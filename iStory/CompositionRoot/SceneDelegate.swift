//
//  SceneDelegate.swift
//  iStory
//
//  Created by Nikola Stojanovic on 18.3.22..
//

import UIKit
import LoginWithAmazon
import PhoneNumberKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appFlow = AppFlowController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.rootViewController = HomeViewController()
        self.window?.makeKeyAndVisible()
       // appFlow.configure(window: window)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let url = URLContexts.first!.url
        AMZNAuthorizationManager.handleOpen(url, sourceApplication: nil)
    }    
}

