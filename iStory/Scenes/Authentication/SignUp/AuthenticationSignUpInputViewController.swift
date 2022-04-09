//
//  AuthenticationSignUpInputViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 8.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationSignUpInputViewController: UIViewController {

    var checkAppPublisher: AnyPublisher<Void, Never> {
        checkAppSubject.eraseToAnyPublisher()
    }
    var loginPublisher: AnyPublisher<Void, Never> {
        loginSubject.eraseToAnyPublisher()
    }
    private let checkAppSubject = PassthroughSubject<Void, Never>()
    private let loginSubject = PassthroughSubject<Void, Never>()
    private var authInputView: AuthenticationInputView!
    private let viewModel: AuthenticationInputViewModel = .signup

    override func viewDidLoad() {
        super.viewDidLoad()
        applyAuthenticationStyle(to: view)
        setupSubviews()
        hideKeyboardWhenTappedAround()
    }

    private func setupSubviews() {
        setupInputView()
        setupButtons()
    }

    private func setupInputView() {
        authInputView = AuthenticationInputView(viewModel: viewModel)
        view.addManagedSubview(authInputView)
        authInputView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        authInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        authInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        authInputView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).activate()
    }

    private func setupButtons() {
        var loginConfig = UIButton.Configuration.plain()
        loginConfig.title = String(localized: "auth.account.login")
        loginConfig.baseForegroundColor = .black
        let loginButton = UIButton(configuration: loginConfig, publisher: loginSubject)
        view.addManagedSubview(loginButton)
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).activate()
        loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()

        var checkAppConfig = UIButton.Configuration.plain()
        checkAppConfig.title = String(localized: "auth.skip.title")
        checkAppConfig.titleAlignment = .center
        checkAppConfig.baseForegroundColor = .black
        let checkAppButton = UIButton(configuration: checkAppConfig, publisher: checkAppSubject)
        view.addManagedSubview(checkAppButton)
        checkAppButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20).activate()
        checkAppButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        checkAppButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        checkAppButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
    }
}
