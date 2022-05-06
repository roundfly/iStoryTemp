//
//  AuthenticationEnvironment.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import GoogleSignInService
import KeychainService
import KeychainServiceAPI
import KeychainSwift
import Combine
import Foundation

private let keychainSwift = KeychainSwift()

struct AuthenticationEnvironment {
    var phoneNumberKit: PhoneNumberService { .init() }
    var amazonClient: AmazonService
    var googleClient: GoogleClient { .prodution }
    var appleClient: AppleClient { .production }
    var authenticationClient: AuthenticationClient { .prodution }
    var keychain: KeychainServiceAPI { KeychainService(keychain: KeychainWrapper(keychain: keychainSwift)) }
    var notificationCenter: NotificationCenter { .default }
    var dateFormatter = ISO8601DateFormatter()
}

struct AuthenticationClient /* iStory client */ {
    var logIn: (Credentials) -> AnyPublisher<AccessToken, Error>
    var signIn: (Credentials) -> AnyPublisher<User, Error>
    var forgotPassword: (_ email: String) -> AnyPublisher<Void, Error>
    var submitBirthdayWithEmail: (_ date: String, _ email: String) -> AnyPublisher<Void, Error>
    /// Signup flow
    var submitAccessCodeWithEmail: (_ accessCode: String, _ email: String) -> AnyPublisher<Void, Error>
    /// Forgot password flow
    var submitForgotPasswordAccessCodeWithEmail: (_ accessCode: String, _ email: String) -> AnyPublisher<AccessToken, Error>

    static var prodution: AuthenticationClient {
        Self(logIn: { credentials in
            let worker = LoginEmailWorker(email: credentials.email, password: credentials.password)
            return Future<AccessToken, Error>(operation: worker.performLogIn).eraseToAnyPublisher()
        },
             signIn: { credentials in
            let worker = SignUpWorker(email: credentials.email, password: credentials.password)
            return Future<User, Error>(operation: worker.performSignUp).eraseToAnyPublisher()
        },
             forgotPassword: { email in
            let worker = ForgotPasswordWorker(email: email)
            return Future<Void, Error>(operation: worker.performForgotPassword).eraseToAnyPublisher()
        },
             submitBirthdayWithEmail: { date, email in
            let worker = BirthDateWorker(email: email, birthday: date)
            return Future<Void, Error>(operation: worker.submitBirthday).eraseToAnyPublisher()

        },
             submitAccessCodeWithEmail: { accessCode, email in
            let worker = EmailAccessCodeWorker(email: email, accessCode: accessCode)
            return Future<Void, Error>(operation: worker.submitAccessCode).eraseToAnyPublisher()

        },
             submitForgotPasswordAccessCodeWithEmail: { accessCode, email in
            let worker = ForgotPasswordAccessCodeWorker(email: email, accessCode: accessCode)
            return Future<AccessToken, Error>(operation: worker.submitAccessCode).eraseToAnyPublisher()
        })
    }
}
