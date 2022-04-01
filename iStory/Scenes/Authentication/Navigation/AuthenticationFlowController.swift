//
//  AuthenticationFlowCoordinator.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit

final class AuthenticationFlowController: UIViewController {

    private let navigation: UINavigationController
    private let loginViewController: LoginViewController

    // MARK: - Initialization

    init(navigation: UINavigationController) {
        self.navigation = navigation
        self.loginViewController = .init()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.pushViewController(loginViewController, animated: false)
    }
}
