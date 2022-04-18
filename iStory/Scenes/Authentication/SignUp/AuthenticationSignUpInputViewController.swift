//
//  AuthenticationSignUpInputViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 8.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationSignUpInputViewController: UIViewController, FailureShowable {
    // MARK: - Instance variables

    var checkAppPublisher: AnyPublisher<Void, Never> {
        checkAppSubject.eraseToAnyPublisher()
    }
    var loginPublisher: AnyPublisher<Void, Never> {
        loginSubject.eraseToAnyPublisher()
    }
    var signUpCompletePublisher: AnyPublisher<Void, Never> {
        signUpCompleteSubject.eraseToAnyPublisher()
    }
    private let checkAppSubject = PassthroughSubject<Void, Never>()
    private let loginSubject = PassthroughSubject<Void, Never>()
    private let signUpCompleteSubject = PassthroughSubject<Void, Never>()
    private let viewModel: AuthenticationInputViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - FailureShowable conformance

    var authInputView: AuthenticationInputView!
    var errorLabel = UILabel()

    // MARK: - Initialization

    init(store: AuthenticationStore) {
        self.viewModel = AuthenticationInputViewModel(authenticationType: .signup, store: store)
        super.init(nibName: nil, bundle: nil)
        store.$state
            .dropFirst()
            .sink { [weak self] authState in
                if let error = authState.authFailure {
                    self?.show(failureReason: error)
                } else if let _ = authState.currentUser {
                    // do stuff with user
                    self?.hideFailureLabel()
                    self?.signUpCompleteSubject.send()
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
        var loginConfig = UIButton.Configuration.plain()
        loginConfig.baseForegroundColor = .black
        let loginButton = UIButton(configuration: loginConfig, publisher: loginSubject)
        loginButton.setAttributedTitle(String(localized: "auth.account.login").bolded(text: "LogIn!", font: .preferredFont(forTextStyle: .footnote)), for: .normal)
        view.addManagedSubview(loginButton)
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).activate()
        loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()

        var checkAppConfig = UIButton.Configuration.plain()
        checkAppConfig.titleAlignment = .center
        checkAppConfig.baseForegroundColor = .black
        let checkAppButton = UIButton(configuration: checkAppConfig, publisher: checkAppSubject)
        checkAppButton.setAttributedTitle(String(localized: "auth.skip.title").bolded(text: "Skip", font: .preferredFont(forTextStyle: .footnote)), for: .normal)
        view.addManagedSubview(checkAppButton)
        checkAppButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor).activate()
        checkAppButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        checkAppButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        checkAppButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
    }
}
