//
//  AuthenticationFlowCoordinator.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit
import Combine

final class AuthenticationFlowController: UIViewController {
    // MARK: - Utility types

    typealias Dependencies = AuthenticationLoginViewModel.Dependencies

    // MARK: - Instance variables

    private let navigation: UINavigationController
    private let dependencies: Dependencies
    private let loginViewController: SplashAuthViewController
    private var cancenllable: Cancellable?

    // MARK: - Initialization

    init(navigation: UINavigationController, dependencies: Dependencies) {
        self.navigation = navigation
        self.loginViewController = SplashAuthViewController()
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        add(loginViewController)
        cancenllable = loginViewController.navigationPublisher
            .sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .tryApp: // todo
                break
            case .signUp:
                let viewController = AuthenticationSignUpViewController(viewModel: .init(dependencies: self.dependencies))
                self.navigation.pushViewController(viewController, animated: true)
            case .logIn:
                let viewController = AuthenticationLoginViewController(viewModel: .init(dependencies: self.dependencies))
                self.navigation.pushViewController(viewController, animated: true)
            }
        }
    }
}
