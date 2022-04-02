//
//  AuthenticationIstoryLoginViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit

final class AuthenticationIstoryLoginViewController: UIViewController {

    override func loadView() {
        super.loadView()
        let viewModel = AuthenticationIstoryViewModel(title: String(localized: "splash.auth.login.title"),
                                                      emailButtonTitle: String(localized: "auth.istory.login.email.button.title"),
                                                      smsButtonTitle: String(localized: "auth.istory.login.sms.button.title"),
                                                      disclaimerButtonTitle: String(localized: "auth.istory.login.disclaimer.button.title"),
                                                      emailButtonAtion: {},
                                                      smsButtonAction: {})
        view = AuthenticationIstoryView(viewModel: viewModel)
    }
}
