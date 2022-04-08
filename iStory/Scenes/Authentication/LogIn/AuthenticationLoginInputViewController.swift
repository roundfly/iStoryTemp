//
//  AuthenticationLoginInputViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 8.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationLoginInputViewController: UIViewController {

    var forgotPasswordPublisher: AnyPublisher<Void, Never> {
        forgotPasswordSubject.eraseToAnyPublisher()
    }
    var createAccountPublisher: AnyPublisher<Void, Never> {
        createAccountSubject.eraseToAnyPublisher()
    }

    private let forgotPasswordSubject = PassthroughSubject<Void, Never>()
    private let createAccountSubject = PassthroughSubject<Void, Never>()
    private var authInputView: AuthenticationInputView!

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
        authInputView = AuthenticationInputView(title: String(localized: "auth.input.login.title"),
                                                description: String(localized: "auth.input.login.desc"),
                                                onSubmit: UIAction(handler: { action in

        }))
        view.addManagedSubview(authInputView)
        authInputView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        authInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        authInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        authInputView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).activate()
    }

    private func setupButtons() {
        var createAccountConfig = UIButton.Configuration.plain()
        createAccountConfig.title = String(localized: "auth.input.account.create.title")
        createAccountConfig.baseForegroundColor = .black
        let createAccountButton = UIButton(configuration: createAccountConfig, primaryAction: UIAction { [createAccountSubject] action in
            createAccountSubject.send(())
        })
        view.addManagedSubview(createAccountButton)
        createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).activate()
        createAccountButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        createAccountButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()

        var forgotPasswordConfig = UIButton.Configuration.plain()
        forgotPasswordConfig.title = String(localized: "auth.input.forgot.password")
        forgotPasswordConfig.titleAlignment = .center
        forgotPasswordConfig.baseForegroundColor = .black
        let forgotPasswordButton = UIButton(configuration: forgotPasswordConfig, primaryAction: UIAction { [forgotPasswordSubject] action in
            forgotPasswordSubject.send(())
        })
        view.addManagedSubview(forgotPasswordButton)
        forgotPasswordButton.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -20).activate()
        forgotPasswordButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        forgotPasswordButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
    }
}
