//
//  AuthenticationEnvironment.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import GoogleSignInService
import Combine
import Foundation

struct AuthenticationEnvironment {
    var phoneNumberKit: PhoneNumberService { .init() }
    var amazonClient: AmazonService
    var googleClient: GoogleClient { .prodution }
    var appleClient: AppleClient { .production }
    var authenticationClient: AuthenticationClient { .prodution }
}

struct AuthenticationClient /* iStory client */ {
    var logIn: (Credentials) -> AnyPublisher<User, Error>
    var submitBirthday: (Date) -> AnyPublisher<Date, Error>

    static var prodution: AuthenticationClient {
        Self(logIn: { credentials in
            Just(User()).setFailureType(to: Error.self).eraseToAnyPublisher()
        },
             submitBirthday: { date in
            Just(date).setFailureType(to: Error.self).eraseToAnyPublisher()
        })
    }
}
