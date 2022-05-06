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
        userDidLogInFromForgotPassword()
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
        let forgotPasswordViewController = ForgotPasswordViewController(viewModel: ForgotPasswordViewModel(store: store))
        let loginInputViewController = AuthenticationLoginInputViewController(store: store)
        let accessCodeViewController = AccessCodeViewController(viewModel: .init(accessCodeSource: .forgotPassword, store: store))
        let homeViewController = HomeViewController(store: store)
        forgotPasswordViewController.forgotPasswordSubmitPublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(accessCodeViewController) else { return }
                navigation.pushViewController(accessCodeViewController, animated: true)
            }.store(in: &cancenllables)
        loginInputViewController.forgotPasswordPublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(forgotPasswordViewController) else { return }
                navigation.pushViewController(forgotPasswordViewController, animated: true)
            }.store(in: &cancenllables)
        loginInputViewController.logInCompletePublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(homeViewController) else { return }
                navigation.pushViewController(homeViewController, animated: true)
            }.store(in: &cancenllables)
        viewController.emailButtonPublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(loginInputViewController) else { return }
                navigation.pushViewController(loginInputViewController, animated: true)
            }.store(in: &cancenllables)
        
        viewController.smsButtonPublisher
            .sink { [navigation, store] _ in
                let viewModel = LoginWithSMSViewModel(dependency: .init(), viewState: .error, store: store, authType: .login)
                navigation.pushViewController(LoginWithSMSViewController(viewModel: viewModel), animated: true)
            }.store(in: &cancenllables)
        
        navigation.pushViewController(viewController, animated: true)
    }

    private func openSignUpFlow() {
        let viewController = AuthenticationIstorySignUpViewController()
        let signUpViewController = AuthenticationSignUpInputViewController(store: store)
        let datePickerViewController = AuthenticationSignUpDatePickerViewController(store: store)
        let accessCodeViewController = AccessCodeViewController(viewModel: AccessCodeViewModel(accessCodeSource: .email, store: store))
        accessCodeViewController.accessCodeCompletePublisher
            .sink { [navigation] in
                navigation.pushViewController(InviteContactsViewController(), animated: true)
            }
            .store(in: &cancenllables)
        datePickerViewController.dateCompletePublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(accessCodeViewController) else { return }
                navigation.pushViewController(accessCodeViewController, animated: true)
            }.store(in: &cancenllables)
        signUpViewController.signUpCompletePublisher
            .sink { [navigation] _ in
                guard !navigation.viewControllers.contains(datePickerViewController) else { return }
                navigation.pushViewController(datePickerViewController, animated: true)
            }.store(in: &cancenllables)
        viewController.emailButtonPublisher.sink { [navigation] _ in
            guard !navigation.viewControllers.contains(signUpViewController) else { return }
            navigation.pushViewController(signUpViewController, animated: true)
        }.store(in: &cancenllables)
        viewController.smsButtonPublisher.sink { [navigation, store] _ in
            let viewModel = LoginWithSMSViewModel(dependency: .init(), viewState: .error, store: store, authType: .signup)
            navigation.pushViewController(LoginWithSMSViewController(viewModel: viewModel), animated: true)
        }.store(in: &cancenllables)
        navigation.pushViewController(viewController, animated: true)
    }

    private func userDidLogInFromForgotPassword() {
        NotificationCenter.default.publisher(for: .userDidLogIn, object: nil)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigation.pushViewController(HomeViewController(store: self.store), animated: false)
            }
            .store(in: &cancenllables)
    }
}
