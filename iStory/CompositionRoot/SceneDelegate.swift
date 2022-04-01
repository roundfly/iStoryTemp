//
//  SceneDelegate.swift
//  iStory
//
//  Created by Nikola Stojanovic on 18.3.22..
//

import UIKit
import LoginWithAmazon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let vc = AmazonViewController()
        
        let rootNC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let url = URLContexts.first!.url
        AMZNAuthorizationManager.handleOpen(url, sourceApplication: nil)
    }    
}

