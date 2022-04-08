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

    static let login = AuthenticationInputViewModel(authenticationType: .login)
    static let signup = AuthenticationInputViewModel(authenticationType: .signup)

    var invalidInputPublisher: AnyPublisher<String, Never> {
        invalidInputSubject.eraseToAnyPublisher()
    }

    private let invalidInputSubject = PassthroughSubject<String, Never>()

    init(authenticationType: AuthenticationInputType) {
        self.type = authenticationType
    }

    func validate(password: String) {
        guard password.count > 8 else { return }
        invalidInputSubject.send(String(localized: "auth.password.error"))
    }

    func validate(email: String) {
        guard emailPredicate.evaluate(with: email) else { return }
        invalidInputSubject.send(String(localized: "auth.email.error"))
    }
}
