//
//  SplashAuthViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import StyleSheet

final class SplashAuthViewController: UIViewController {
    // MARK: - Instance variables

    private let titleLabel = UILabel()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.yellow.uiColor
        setupBackgroundImageView()
        setupLogoImageView()
        setupTitleLabel()
        setupButtonVStack()
    }

    // MARK: - Subview setup

    private func setupLogoImageView() {
        let imageView = UIImageView()
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFill
        view.addManagedSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).activate()
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).activate()
    }

    private func setupTitleLabel() {
        titleLabel.text = String(localized: "splash.auth.title")
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        view.addManagedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func setupButtonVStack() {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        config.cornerStyle = .medium
        config.buttonSize = .medium
        let loginButton = UIButton(configuration: config), signUpButton = UIButton(configuration: config), skipButton = UIButton()
        let vStackView = UIStackView(arrangedSubviews: [loginButton, signUpButton, skipButton])
        let titles = ["splash.auth.login.title", "splash.auth.signup.title"].map { String(localized: $0) }
        zip([loginButton, signUpButton], titles).forEach { button, title in
            button.setTitle(title, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 44.0).activate()
        }
        view.addManagedSubview(vStackView)
        skipButton.setTitle(String(localized: "splash.auth.skip"), for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        vStackView.spacing = 20
        vStackView.setCustomSpacing(60, after: signUpButton)
        vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        vStackView.axis = .vertical
        vStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        vStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).activate()
        vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()
        vStackView.distribution = .fillEqually
    }

    private func setupBackgroundImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        view.addManagedSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).activate()
        imageView.image = UIImage(namedInStyleSheet: "onboarding-background")
    }
}
