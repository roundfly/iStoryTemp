//
//  ViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 18.3.22..
//

import StyleSheet
import Combine
import GoogleSignIn
import GoogleSignInService
import UIKit

class TestViewController: UIViewController {
    
    private let theme = ThemeDefault()
    
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme.colorGreen
        label.font = theme.fontBold
        label.font = theme.fontBlack
    }
}

final class GoogleSignUpViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        setupSignUpButton()
    }

    private func setupSignUpButton() {
        let googleButton = GIDSignInButton()
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleButton)
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        googleButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    @objc
    private func signIn() {
        let client: GoogleClient = .prodution
        client.signIn(self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] user in
                let viewController = UIViewController()
                let label = UILabel()
                viewController.view.addSubview(label)
                viewController.view.backgroundColor = .white
                label.frame = viewController.view.bounds
                label.font = .preferredFont(forTextStyle: .largeTitle)
                label.numberOfLines = 0
                label.textAlignment = .center
                label.text = user.givenName
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .store(in: &cancellables)
    }
}
