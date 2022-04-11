//
//  AuthenticationReducer.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation
import Combine

let authReducer: Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> = { state, action, environment in
    switch action {
    case .logIn(let credentials):
        return environment.authenticationClient
            .logIn(credentials)
            .map(AuthenticationAction.loggedIn)
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .signUp(let credentials):
        state.currentUser = .init()
    case .loggedIn(let user):
        state.currentUser = user
    case .authFailure(let reason):
        state.authFailure = reason
    }
    return Empty().eraseToAnyPublisher()
}
