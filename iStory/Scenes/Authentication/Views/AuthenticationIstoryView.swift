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
    var disclaimerButtonTitle: String
    var emailButtonAtion: () -> Void
    var smsButtonAction: () -> Void
}

final class AuthenticationIstoryView: UIView {

    private let titleLabel = UILabel()
    private let logoImageView = UIImageView()
    private let viewModel: AuthenticationIstoryViewModel

    init(viewModel: AuthenticationIstoryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        applyAuthenticationStyle(to: self)
        setupLogoImageView()
        setupTitleLabel()
        setupButtonStackView()
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
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        addManagedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).activate()
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
        let button = UIButton(configuration: .plain())
        addManagedSubview(button)
        button.setTitle(viewModel.disclaimerButtonTitle, for: .normal)
        button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).activate()
        button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).activate()
        button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).activate()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
    }
}
