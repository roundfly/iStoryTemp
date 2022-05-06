//
//  ForgotPasswordViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import UIKit

final class ForgotPasswordViewModel {
    private(set) var store: AuthenticationStore
    private var email: String = ""

    var title: String {
        String(localized: "auth.forgot.password.title")
    }

    var subtitle: String {
        String(localized: "auth.forgot.password.desc")
    }

    var emailPlaceholder: String {
        String(localized: "enter your email here")
    }

    var submitTitle: String {
        String(localized: "auth.forgot.password.button.title")
    }

    init(store: AuthenticationStore) {
        self.store = store
    }

    func submitForm() {
        // TODO: handle validation
        guard !email.isEmpty else { return }
        store.dispatch(.forgotPassword(email: email))
    }

    @objc func enterEmail(_ textField: UITextField) {
        email = textField.text ?? ""
    }
}
