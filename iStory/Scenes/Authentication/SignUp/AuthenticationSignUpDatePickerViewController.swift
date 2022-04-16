//
//  AuthenticationSignUpDatePickerViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 15.4.22..
//

import UIKit
import StyleSheet

final class AuthenticationSignUpDatePickerViewController: UIViewController {
    // MARK: - Instance variables

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoImageView = UIImageView()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        applyAuthenticationStyle(to: view)
        setupSubviews()
    }

    // MARK: - Subview setup

    private func setupSubviews() {
        navigationItem.hidesBackButton = true
        setupLogoImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupInputStackView()
    }

    private func setupLogoImageView() {
        logoImageView.image = .logo
        logoImageView.contentMode = .scaleAspectFill
        view.addManagedSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        logoImageView.heightAnchor.constraint(equalToConstant: 130).activate()
        logoImageView.widthAnchor.constraint(equalToConstant: 90).activate()
    }

    private func setupTitleLabel() {
        titleLabel.text = String(localized: "splash.auth.signup.title")
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        view.addManagedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).activate()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupDescriptionLabel() {
        view.addManagedSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = String(localized: "auth.date.picker.description")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .title2)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupInputStackView() {
        var dateConfig = UIButton.Configuration.filled(), submitConfig = UIButton.Configuration.filled()
        dateConfig.baseBackgroundColor = .white
        dateConfig.baseForegroundColor = .black
        dateConfig.title = String(localized: "auth.date.picker.placeholder")
        submitConfig.baseBackgroundColor = AppColor.blue.uiColor
        submitConfig.baseForegroundColor = .black
        submitConfig.title = String(localized: "auth.button.submit.title")
        let dateLabel = UILabel()
        dateLabel.text = String(localized: "auth.date.picker.heading")
        dateLabel.font = .preferredFont(forTextStyle: .body)
        let datePickerButton = UIButton(configuration: dateConfig, primaryAction: UIAction { _ in })
        let submitButton = UIButton(configuration: submitConfig, primaryAction: UIAction { _ in })
        let stackView = UIStackView(arrangedSubviews: [dateLabel, datePickerButton, submitButton])
        view.addManagedSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        submitButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 80.0).activate()
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
    }
}
