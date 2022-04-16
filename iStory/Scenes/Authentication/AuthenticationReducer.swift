//
//  AuthenticationReducer.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation
import Combine
import GoogleSignInService

let authReducer: Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> = { state, action, environment in
    switch action {
    case .logIn(let credentials):
        return environment.authenticationClient
            .logIn(credentials)
            .map(AuthenticationAction.loggedIn)
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .signUp(let credentials):
        state.authFailure = nil
        state.currentUser = .init()
    case .loggedIn(let user):
        state.authFailure = nil
        state.currentUser = user
    case .authFailure(let reason):
        state.authFailure = reason
    case .googleSignIn(presentingViewController: let presentingViewController):
        return environment
            .googleClient
            .signIn(presentingViewController)
            .map(AuthenticationAction.loggedInWithGoogle(googleUser:))
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .amazonSignIn:
        return environment
            .amazonClient
            .openAuthorizeRequest()
            .map(AuthenticationAction.loggedInWithAmazon(token:))
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
        
    case .loggedInWithGoogle(googleUser: let googleUser):
        state.currentUser = .init()
    case .loggedInWithAmazon(token: let token):
        state.currentUser = .init()
    case .submitBirthday(let date):
        return environment.authenticationClient
            .submitBirthday(date)
            .map(AuthenticationAction.submittedBirthday(date:))
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .submittedBirthday(let date):
        state.authFailure = nil
        state.userBirthday = date
    }
    return Empty().eraseToAnyPublisher()
}
