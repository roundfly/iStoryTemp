//
//  AppleSignInViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 26.3.22..
//

import UIKit
import Combine
import AuthenticationServices

final class AppleSignInViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    private var client: AppleClient {
        .production
    }
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = ASAuthorizationAppleIDButton()
        view.addSubview(button)
        button.center = view.center
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        handleAppleSignIn()
    }

    @objc private func signIn() {
        client.signIn(self)
    }

    private func handleAppleSignIn() {
        client.delegate
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] token in
                let viewController = UIViewController()
                let label = UILabel()
                viewController.view.addSubview(label)
                viewController.view.backgroundColor = .white
                label.frame = viewController.view.bounds
                label.font = .preferredFont(forTextStyle: .largeTitle)
                label.numberOfLines = 0
                label.textAlignment = .center
                label.text = token
                self?.navigationController?.pushViewController(viewController, animated: true)
        })
        .store(in: &cancellables)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
