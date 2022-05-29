//
//  AuthenticationIstoryView.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import StyleSheet

struct AuthenticationIstoryViewModel {
    var title: String
    var emailButtonTitle: String
    var smsButtonTitle: String
    var authIntent: AuthIntent
    var emailButtonAtion: () -> Void
    var smsButtonAction: () -> Void
    var tryAppAction: () -> Void
}

final class AuthenticationIstoryView: UIView {

    private let titleLabel = UILabel()
    private let logoImageView = UIImageView()
    private let switchAuthFlowButton: UIButton
    private let viewModel: AuthenticationIstoryViewModel

    init(viewModel: AuthenticationIstoryViewModel) {
        self.viewModel = viewModel
        var config: UIButton.Configuration = .plain()
        config.baseForegroundColor = .black
        switchAuthFlowButton = UIButton(configuration: config)
        super.init(frame: .zero)
        applyAuthenticationStyle(to: self)
        setupLogoImageView()
        setupTitleLabel()
        setupButtonStackView()
        setupSwitchAuthFlowButton()
        setupDisclaimerButton()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupLogoImageView() {
        logoImageView.image = .logo
        logoImageView.contentMode = .scaleAspectFill
        addManagedSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        logoImageView.heightAnchor.constraint(equalToConstant: 130).activate()
        logoImageView.widthAnchor.constraint(equalToConstant: 90).activate()
    }

    private func setupTitleLabel() {
        titleLabel.text = viewModel.title
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        addManagedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).activate()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func setupButtonStackView() {
        var config: UIButton.Configuration = .filled()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        let emailButton = UIButton(configuration: config, primaryAction: .init(handler: { [viewModel] _ in viewModel.emailButtonAtion() }))
        let smsButton = UIButton(configuration: config, primaryAction: .init(handler: { [viewModel] _ in viewModel.smsButtonAction() }))
        let buttons = [emailButton, smsButton]
        let titles = [viewModel.emailButtonTitle, viewModel.smsButtonTitle]
        zip(buttons, titles).forEach { button, title in
            button.setTitle(title, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 44.0).activate()
        }
        let vStackView = UIStackView(arrangedSubviews: buttons)
        addManagedSubview(vStackView)
        vStackView.spacing = 20
        vStackView.axis = .vertical
        vStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).activate()
        vStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).activate()
        vStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).activate()
        vStackView.distribution = .fillEqually
    }

    private func setupDisclaimerButton() {
        var config: UIButton.Configuration = .plain()
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        addManagedSubview(button)
        let title = "Skip and check the app.".bolded(text: "Skip", font: .preferredFont(forTextStyle: .footnote))
        button.setAttributedTitle(title, for: .normal)
        button.addAction(UIAction { [weak self] _ in self?.viewModel.tryAppAction() }, for: .touchUpInside)
        button.bottomAnchor.constraint(equalTo: switchAuthFlowButton.topAnchor).activate()
        button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).activate()
        button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).activate()
        button.titleLabel?.textAlignment = .center
    }

    private func setupSwitchAuthFlowButton() {
        addManagedSubview(switchAuthFlowButton)
        let title = viewModel.authIntent == .signUp ? "Already have an account? LogIn!" : "No account? Create one!"
        let attributed = title.bolded(text: viewModel.authIntent == .signUp ? "LogIn!" : "Create one!", font: .preferredFont(forTextStyle: .footnote))
        switchAuthFlowButton.setAttributedTitle(attributed, for: .normal)
        switchAuthFlowButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40).activate()
        switchAuthFlowButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).activate()
        switchAuthFlowButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).activate()
        switchAuthFlowButton.titleLabel?.textAlignment = .center

    }
}
