//
//  SplashAuthViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import UIKit
import StyleSheet

enum SplashAuthNavigationEvent {
    case logIn
    case signUp
    case tryApp
}

final class SplashAuthViewController: UIViewController {
    // MARK: - Instance variables

    private let titleLabel = UILabel()
    var navigationPublisher: AnyPublisher<SplashAuthNavigationEvent, Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<SplashAuthNavigationEvent, Never>()
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        applyAuthenticationStyle(to: view)
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
        imageView.heightAnchor.constraint(equalToConstant: 130).activate()
        imageView.widthAnchor.constraint(equalToConstant: 90).activate()
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
        let loginAction: UIAction = .init(handler: { [subject] _ in subject.send(.logIn) })
        let signUpAction: UIAction = .init(handler: { [subject] _ in subject.send(.signUp) })
        let skipAction: UIAction = .init(handler: { [subject] _ in subject.send(.tryApp) })
        let loginButton = UIButton(configuration: config, primaryAction: loginAction),
            signUpButton = UIButton(configuration: config, primaryAction: signUpAction),
            skipButton = UIButton(primaryAction: skipAction)
        let vStackView = UIStackView(arrangedSubviews: [loginButton, signUpButton, skipButton])
        let titles = ["splash.auth.login.title", "splash.auth.signup.title"].map { String(localized: $0) }
        zip([loginButton, signUpButton], titles).forEach { button, title in
            button.setTitle(title, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 44.0).activate()
        }
        view.addManagedSubview(vStackView)
        let title = String(localized: "splash.auth.skip").bolded(text: "and check the app", font: .preferredFont(forTextStyle: .footnote))
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.setAttributedTitle(title, for: .normal)
        vStackView.spacing = 20
        vStackView.setCustomSpacing(60, after: signUpButton)
        vStackView.axis = .vertical
        vStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        vStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
        vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).activate()
        vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()
        vStackView.distribution = .fillEqually
    }
}
