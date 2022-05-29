//
//  TabBarFlowController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 28.5.22..
//

import UIKit

final class TabBarFlowController: UIViewController, UITabBarControllerDelegate {

    // TODO: - Scope store so that it is generic over TabBarState, TabBarAction, TabBarEnv
    private let store: AuthenticationStore
    private let tabBarCtrl: TabBarController

    init(store: AuthenticationStore) {
        self.store = store
        self.tabBarCtrl = TabBarController(store: store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(tabBarCtrl)
        tabBarCtrl.delegate = self
    }

    func tryApp() {
        tabBarCtrl.selectedIndex = 0
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard tabBarController.selectedIndex == 0 else {
            dismiss(animated: true)
            return
        }
    }
}
