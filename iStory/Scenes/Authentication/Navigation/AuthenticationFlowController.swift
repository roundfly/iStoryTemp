//
//  AuthenticationFlowCoordinator.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit

final class AuthenticationFlowController: UIViewController {

    private let navigation: UINavigationController
    let loginViewController: SplashAuthViewController

    // MARK: - Initialization

    init(navigation: UINavigationController) {
        self.navigation = navigation
        self.loginViewController = SplashAuthViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
