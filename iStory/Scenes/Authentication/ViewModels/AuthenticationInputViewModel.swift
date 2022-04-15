//
//  AuthenticationInputViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation
import Combine

final class AuthenticationInputViewModel {
    enum AuthenticationInputType {
        case login
        case signup
    }
    private let minPasswordLength = 8
    private let type: AuthenticationInputType
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private lazy var emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)

    var title: String {
        switch type {
        case .login:
            return String(localized: "auth.input.login.title")
        case .signup:
            return String(localized: "splash.auth.signup.title")
        }
    }

    var subtitle: String {
        String(localized: "auth.input.login.desc")
    }

    private(set) var store: AuthenticationStore

    private var email: String = "", password: String = ""

    init(authenticationType: AuthenticationInputType, store: AuthenticationStore) {
        self.type = authenticationType
        self.store = store
    }


    private func isValidPassowrd(_ password: String) -> Bool {
        guard password.count > 8 else {
            store.dispatch(.authFailure(reason: String(localized: "auth.password.error")))
            return false
        }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        guard emailPredicate.evaluate(with: email) else {
            store.dispatch(.authFailure(reason: String(localized: "auth.email.error")))
            return false
        }
        return true
    }

    func submitForm() {
        guard isValidPassowrd(password), isValidEmail(email) else { return }
        let credentials = (email: email, password: password)
        switch type {
        case .login:
            store.dispatch(.logIn(user: credentials))
        case .signup:
            store.dispatch(.signUp(user: credentials))
        }
    }
}
