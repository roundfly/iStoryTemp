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
            .map { user in
                var user = user
                user.email = credentials.email
                user.password = credentials.password
                return AuthenticationAction.signedIn(user: user)
            }
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .signUp(let credentials):
        return environment.authenticationClient
            .signIn(credentials)
            .map { user in
                var user = user
                user.email = credentials.email
                user.password = credentials.password
                return AuthenticationAction.signedIn(user: user)
            }
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .signedIn(let user):
        state.authFailure = nil
        state.currentUser = user
        environment.keychain.setUserEmail(user.email ?? "")
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
            .submitBirthdayWithEmail(environment.dateFormatter.string(from: date),
                            state.currentUser?.email ?? "")
            .map { AuthenticationAction.submittedBirthday(date: date) }
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .submittedBirthday(let date):
        state.authFailure = nil
        state.userBirthday = date
    case .submitEmailAccessCode(let accessCode):
        return environment.authenticationClient
            .submitAccessCodeWithEmail(accessCode, state.currentUser?.email ?? "")
            .map { _ in AuthenticationAction.submittedAccessCode }
            .catch { Just(AuthenticationAction.accessCodeFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .accessCodeFailure(let reason):
        state.accessCodeFailure = reason
    case .submittedAccessCode:
        state.accessCodeFailure = nil
        state.currentUser?.didSubmitValidAccessCodeInSession = true
    case .forgotPassword(let email):
        state.currentUser = User(email: email)
        return environment.authenticationClient
            .forgotPassword(email)
            .map { AuthenticationAction.forgotPasswordSubmitted }
            .catch { Just(AuthenticationAction.forgotPasswordFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .forgotPasswordFailure(let reason):
        break
    case .forgotPasswordSubmitted:
        state.showForgotPasswordAccessCodeFlow = true
    case .submitForgotPasswordAccessCode(accessCode: let accessCode):
        return environment.authenticationClient
            .submitForgotPasswordAccessCodeWithEmail(accessCode, state.currentUser?.email ?? "")
            .map { AuthenticationAction.forgotPasswordAcessCodeSubmitted }
            .catch { Just(AuthenticationAction.forgotPasswordFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .forgotPasswordAcessCodeSubmitted:
        break
    }
    return Empty().eraseToAnyPublisher()
}
