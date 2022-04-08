//
//  AuthenticationInputView.swift
//  iStory
//
//  Created by Nikola Stojanovic on 8.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationInputView: UIView {
    // MARK: - Instance variables

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let onSubmit: UIAction
    private var isPasswordVisisble = false
    private lazy var inputVisibilityButton: UIButton = {
        var inputVisibilityConfig = UIButton.Configuration.filled()
        let inputVisibilityAction = UIAction { [weak self] action in
            guard let self = self else { return }
            self.isPasswordVisisble.toggle()
            self.inputVisibilityButton.setImage(self.isPasswordVisisble == true ? UIImage(systemName: "eye.slash"): UIImage(systemName: "eye") , for: .normal)
            self.passwordTextField.isSecureTextEntry = !self.isPasswordVisisble
        }
        inputVisibilityConfig.image = UIImage(systemName: "eye")
        inputVisibilityConfig.baseBackgroundColor = .white
        inputVisibilityConfig.baseForegroundColor = .gray
        let inputVisibilityButton = UIButton(configuration: inputVisibilityConfig, primaryAction: inputVisibilityAction)
        inputVisibilityButton.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        return inputVisibilityButton
    }()

    // MARK: - Initialization

    init(viewModel: AuthenticationInputViewModel, onSubmit: UIAction) {
        self.onSubmit = onSubmit
        super.init(frame: .zero)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Subview setup

    private func setupSubviews() {
        setupTitleLabel()
        setupDescriptionLabel()
        setupTextFields()
        setupInputStackView()
    }

    private func setupTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addManagedSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 40.0).activate()
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupDescriptionLabel() {
        addManagedSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .title2)
        descriptionLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).activate()
        descriptionLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).activate()
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()
    }

    private func setupTextFields() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = inputVisibilityButton
        passwordTextField.rightViewMode = .always
        passwordTextField.placeholder = String(localized: "auth.input.password.placeholder")
        emailTextField.placeholder = String(localized: "auth.input.email.placeholder")
        emailTextField.keyboardType = .emailAddress
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        passwordTextField.leftView = spacer
        passwordTextField.leftViewMode = .always
        [passwordTextField, emailTextField].forEach { textField in
            textField.backgroundColor = .white
            textField.textAlignment = .center
            textField.layer.cornerCurve = .continuous
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 5.0
            textField.tintColor = AppColor.blue.uiColor
            textField.keyboardAppearance = .dark
        }
    }

    private func setupInputStackView() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.blue.uiColor
        config.baseForegroundColor = .black
        config.title = String(localized: "auth.button.submit.title")
        let signupButton = UIButton(configuration: config, primaryAction: onSubmit)
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signupButton])
        addManagedSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        signupButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 80.0).activate()
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).activate()
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).activate()
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).activate()
        stackView.spacing = 20.0
    }
}
