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
    var dateFormatter = ISO8601DateFormatter()
}

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

struct AuthenticationClient /* iStory client */ {
    var logIn: (Credentials) -> AnyPublisher<User, Error>
    var signIn: (Credentials) -> AnyPublisher<User, Error>
    var submitBirthdayWithEmail: (_ date: String, _ email: String) -> AnyPublisher<Void, Error>
    var submitAccessCodeWithEmail: (_ accessCode: String, _ email: String) -> AnyPublisher<Void, Error>

    static var prodution: AuthenticationClient {
        Self(logIn: { credentials in
            Just(User()).setFailureType(to: Error.self).eraseToAnyPublisher()
        },
             signIn: { credentials in
            let worker = SignUpWorker(email: credentials.email, password: credentials.password)
            return Future<User, Error>(operation: worker.performSignUp).eraseToAnyPublisher()
        },
             submitBirthdayWithEmail: { date, email in
            let worker = BirthDateWorker(email: email, birthday: date)
            return Future<Void, Error>(operation: worker.submitBirthday).eraseToAnyPublisher()
        }, submitAccessCodeWithEmail: { accessCode, email in
            let worker = EmailAccessCodeWorker(email: email, accessCode: accessCode)
            return Future<Void, Error>(operation: worker.submitAccessCode).eraseToAnyPublisher()
        })
    }
}
