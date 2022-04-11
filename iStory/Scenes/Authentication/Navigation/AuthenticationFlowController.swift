//
//  AuthenticationFlowCoordinator.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit
import Combine

// MARK: - Utility types

typealias AuthenticationStore = Store<AuthenticationState, AuthenticationAction, AuthenticationEnvironment>

final class AuthenticationFlowController: UIViewController {
    // MARK: - Instance variables

    private let navigation: UINavigationController
    private let store: AuthenticationStore
    private let loginViewController: SplashAuthViewController
    private var cancenllables: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(navigation: UINavigationController, store: AuthenticationStore) {
        self.navigation = navigation
        self.loginViewController = SplashAuthViewController()
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        add(loginViewController)
        loginViewController.navigationPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .tryApp: // todo
                    break
                case .signUp:
                    let viewController = AuthenticationSignUpViewController(viewModel: .init(store: self.store))
                    viewController.signupPublisher.sink(receiveValue: { _ in self.openSignUpFlow() }).store(in: &self.cancenllables)
                    self.navigation.pushViewController(viewController, animated: true)
                case .logIn:
                    let viewController = AuthenticationLoginViewController(viewModel: .init(store: self.store))
                    viewController.loginPublisher.sink(receiveValue: { _ in self.openLogInFlow() }).store(in: &self.cancenllables)
                    self.navigation.pushViewController(viewController, animated: true)
                }
            }.store(in: &cancenllables)
    }

    // MARK: - Implementation details

    private func openLogInFlow() {
        let viewController = AuthenticationIstoryLoginViewController()
        viewController.emailButtonPublisher
            .sink { [navigation, store] _ in
                navigation.pushViewController(AuthenticationLoginInputViewController(store: store), animated: true)
            }.store(in: &cancenllables)
        
        viewController.smsButtonPublisher
            .sink { [navigation] _ in
                let viewModel = LoginWithSMSViewModel(dependency: self.dependencies.phoneNumberKit, viewState: .error, authType: .login)
                navigation.pushViewController(LoginWithSMSViewController(viewModel: viewModel), animated: true)
            }.store(in: &cancenllables)
        
        navigation.pushViewController(viewController, animated: true)
    }

    private func openSignUpFlow() {
        let viewController = AuthenticationIstorySignUpViewController()
        viewController.emailButtonPublisher.sink { [navigation, store] _ in
            navigation.pushViewController(AuthenticationSignUpInputViewController(store: store), animated: true)
        }.store(in: &cancenllables)
        
        viewController.smsButtonPublisher.sink { [navigation] _ in
            let viewModel = LoginWithSMSViewModel(dependency: self.dependencies.phoneNumberKit, viewState: .error, authType: .signup)
            navigation.pushViewController(LoginWithSMSViewController(viewModel: viewModel), animated: true)
        }.store(in: &cancenllables)
        
        navigation.pushViewController(viewController, animated: true)
    }
}
