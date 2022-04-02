//
//  AuthenticationIstorySignUpViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit

final class AuthenticationIstorySignUpViewController: UIViewController {

    override func loadView() {
        super.loadView()
        let viewModel = AuthenticationIstoryViewModel(title: String(localized: "splash.auth.signup.title"),
                                                      emailButtonTitle: String(localized: "auth.istory.signup.email.button.title"),
                                                      smsButtonTitle: String(localized: "auth.istory.signup.sms.button.title"),
                                                      disclaimerButtonTitle: String(localized: "auth.istory.signup.disclaimer.button.title"),
                                                      emailButtonAtion: {},
                                                      smsButtonAction: {})
        view = AuthenticationIstoryView(viewModel: viewModel)
    }
}
