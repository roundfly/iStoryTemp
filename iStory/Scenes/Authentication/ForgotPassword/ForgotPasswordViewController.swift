//
//  ForgotPasswordViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import UIKit
import StyleSheet
import Combine

final class ForgotPasswordViewController: UIViewController {
    // MARK: - Instance variables

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailTextField = UITextField()
    private let viewModel: ForgotPasswordViewModel
    private var cancellables: Set<AnyCancellable> = []
    var forgotPasswordSubmitPublisher: AnyPublisher<Void, Never> {
        forgotPasswordSubmitSubject.eraseToAnyPublisher()
    }
    private let forgotPasswordSubmitSubject = PassthroughSubject<Void, Never>()

    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        emailTextField.placeholder = viewModel.emailPlaceholder
        setupSubviews()
        viewModel.store.$state
            .sink { [forgotPasswordSubmitSubject] authState in
                if authState.showForgotPasswordAccessCodeFlow {
                    forgotPasswordSubmitSubject.send()
                }
            }.store(in: &cancellables)
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
        setupTitleLabel()
        setupDescriptionLabel()
        setupEmailTextField()
        setupSubmitButton()
    }

    private func setupTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        view.addManagedSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 40.0).activate()
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupDescriptionLabel() {
        view.addManagedSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .title2)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0).activate()
    }

    private func setupEmailTextField() {
        view.addManagedSubview(emailTextField)
        emailTextField.backgroundColor = .white
        emailTextField.textAlignment = .center
        emailTextField.layer.cornerCurve = .continuous
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.tintColor = AppColor.blue.uiColor
        emailTextField.keyboardAppearance = .dark
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).activate()
        emailTextField.heightAnchor.constraint(equalToConstant: 44.0).activate()
        emailTextField.addTarget(viewModel, action: #selector(viewModel.enterEmail(_:)), for: .editingChanged)
    }

    private func setupSubmitButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.blue.uiColor
        config.baseForegroundColor = .black
        config.title = viewModel.submitTitle
        let submitButton = UIButton(configuration: config, primaryAction: UIAction { [viewModel] _ in viewModel.submitForm() })
        view.addManagedSubview(submitButton)
        submitButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
        submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).activate()
        submitButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        submitButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
    }
}
