//
//  TabBarController.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/7/22.
//

import Foundation
import UIKit
import StyleSheet
import Combine

final class TabBarController: UITabBarController {
    
    let store: AuthenticationStore
    var anonymousUserInteractionPublisher: AnyPublisher<Void, Never> {
        anonymousUserInteractionSubject.eraseToAnyPublisher()
    }
    private let anonymousUserInteractionSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        setupUI()
    }
    
    private func setupControllers() {
        viewControllers = TabBarItemId.allCases.map({ id in
            var viewController: UIViewController
            switch id {
            case .feed:
                let home = HomeViewController(authStatus: store.state.authStatus)
                home
                    .anonymousUserInteractionPublisher
                    .sink { [anonymousUserInteractionSubject] _ in
                        anonymousUserInteractionSubject.send()
                    }.store(in: &cancellables)
                viewController = home
            default:
                viewController = UIViewController()
            }
            let tabBarItem = TabBarItem(id: id, viewController: viewController)
            viewController.tabBarItem = tabBarItem.uiTabBarItem
            viewController.tabBarItem.accessibilityIdentifier = tabBarItem.accessibilityIdentifier
            return viewController
        })
    }
    
    private func setupUI() {
        let activeColor = UIColor.black
        let inactiveColor = UIColor.gray
        let backgroundColor = UIColor.white
    
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor

        appearance.compactInlineLayoutAppearance.normal.iconColor = inactiveColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : inactiveColor]

        appearance.inlineLayoutAppearance.normal.iconColor = inactiveColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : inactiveColor]

        appearance.stackedLayoutAppearance.normal.iconColor = inactiveColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : inactiveColor]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.tintColor = activeColor
    }
}
