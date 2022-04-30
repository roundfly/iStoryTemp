//
//  AuthenticationLoginInputViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 8.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationLoginInputViewController: UIViewController, FailureShowable {
    // MARK: - Instance variables

    var forgotPasswordPublisher: AnyPublisher<Void, Never> {
        forgotPasswordSubject.eraseToAnyPublisher()
    }
    var createAccountPublisher: AnyPublisher<Void, Never> {
        createAccountSubject.eraseToAnyPublisher()
    }
    var logInCompletePublisher: AnyPublisher<Void, Never> {
        logInCompleteSubject.eraseToAnyPublisher()
    }

    private let forgotPasswordSubject = PassthroughSubject<Void, Never>()
    private let createAccountSubject = PassthroughSubject<Void, Never>()
    private let logInCompleteSubject = PassthroughSubject<Void, Never>()
    private let viewModel: AuthenticationInputViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - FailureShowable conformance

    var authInputView: AuthenticationInputView!
    var errorLabel = UILabel()

    // MARK: - Initialization

    init(store: AuthenticationStore) {
        self.viewModel = AuthenticationInputViewModel(authenticationType: .login, store: store)
        super.init(nibName: nil, bundle: nil)
        store.$state
            .dropFirst()
            .sink { [weak self] authState in
                if let error = authState.authFailure {
                    self?.show(failureReason: error)
                } else if let _ = authState.currentUser {
                    self?.hideFailureLabel()
                    self?.logInCompleteSubject.send()
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAuthenticationStyle(to: view)
        setupSubviews()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Subview setup

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
        var createAccountConfig = UIButton.Configuration.plain()
        createAccountConfig.baseForegroundColor = .black
        createAccountConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .preferredFont(forTextStyle: .footnote)
            return outgoing
        }
        let createAccountButton = UIButton(configuration: createAccountConfig, publisher: createAccountSubject)
        view.addManagedSubview(createAccountButton)
        createAccountButton.setTitle(String(localized: "auth.input.account.create.title"), for: .normal)
        createAccountButton.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0).activate()
        createAccountButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        createAccountButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()

        var forgotPasswordConfig = UIButton.Configuration.plain()
        forgotPasswordConfig.titleAlignment = .center
        forgotPasswordConfig.baseForegroundColor = .black
        let forgotPasswordButton = UIButton(configuration: forgotPasswordConfig, publisher: forgotPasswordSubject)
        view.addManagedSubview(forgotPasswordButton)
        forgotPasswordButton.setAttributedTitle("Forgot password?\nGet access code".bolded(text: "Get access code", font: .preferredFont(forTextStyle: .callout)), for: .normal)
        forgotPasswordButton.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -20).activate()
        forgotPasswordButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        forgotPasswordButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
    }
}
