//
//  AuthenticationSignUpViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import UIKit
import SwiftUI

final class AuthenticationSignUpViewController: UIViewController {

    private let viewModel: AuthenticationSignUpViewModel
    var signupPublisher: AnyPublisher<Void, Never> {
        viewModel.signupPublisher
    }

    init(viewModel: AuthenticationSignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let socialViewModel = AuthSocialViewModel(title: String(localized: "splash.auth.signup.title"),
                                                  primaryButtonTitle: String(localized: "auth.social.signup.button.title"),
                                                  authIntent: .signUp,
                                                  onGoogleRequest: viewModel.onGoogle,
                                                  onAmazonRequest: viewModel.onAmazon,
                                                  onIstoryRequest: viewModel.onIstorySignUp,
                                                  onAppleRequest: viewModel.onAppleRequest(req:),
                                                  onAppleCompletion: viewModel.onAppleCompletion(_:))
        add(UIHostingController(rootView: AuthSocialContainerView(viewModel: socialViewModel)))
    }
}
