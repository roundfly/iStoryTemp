//
//  AuthenticationEnvironment.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import GoogleSignInService
import Combine

struct AuthenticationEnvironment {
    var phoneNumberKit: PhoneNumberService { .init() }
    var amazonClient: AmazonService
    var googleClient: GoogleClient { .prodution }
    var appleClient: AppleClient { .production }
    var authenticationClient: AuthenticationClient { .prodution }
}

struct AuthenticationClient /* iStory client */ {
    var logIn: (Credentials) -> AnyPublisher<User, Error>

    static var prodution: AuthenticationClient {
        Self(logIn: { credentials in
            Just(User()).setFailureType(to: Error.self).eraseToAnyPublisher()
        })
    }

    #if DEBUG
    struct LoginError: Error {}

    static let happyPath = Self { credentials in
        Just(User()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    static let unhappyPath = Self { credentials in
        Fail(error: LoginError()).eraseToAnyPublisher()
    }
    #endif
}
