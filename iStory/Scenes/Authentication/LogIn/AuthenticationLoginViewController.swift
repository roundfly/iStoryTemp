//
//  AuthenticationLoginViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import SwiftUI
import StyleSheet

final class AuthenticationLoginViewController: UIViewController {

    private let viewModel: AuthenticationLoginViewModel

    init(viewModel: AuthenticationLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let socialViewModel = AuthSocialViewModel(title: String(localized: "splash.auth.login.title"),
                                                  primaryButtonTitle: String(localized: "auth.social.login.button.title"),
                                                  disclaimerButtonTitle: String(localized: "auth.social.login.disclaimer"),
                                                  onGoogleRequest: viewModel.onGoogle,
                                                  onAmazonRequest: viewModel.onAmazon,
                                                  onIstoryRequest: viewModel.onIstoryLogin,
                                                  onAppleRequest: viewModel.onAppleRequest(req:),
                                                  onAppleCompletion: viewModel.onAppleCompletion(_:))
        add(UIHostingController(rootView: AuthSocialContainerView(viewModel: socialViewModel)))
    }
}
