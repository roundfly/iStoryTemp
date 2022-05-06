//
//  AuthenticationReducer.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation
import Combine
import GoogleSignInService

extension Notification.Name {
    static let userDidLogIn = Self(rawValue: "iStory.log.in")
}

let authReducer: Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> = { state, action, environment in
    switch action {
    case .logIn(let credentials):
        return environment.authenticationClient
            .logIn(credentials)
            .map { token in
                environment.keychain.setAccessToken(token.accessToken)
                let user = User(email: credentials.email, password: credentials.password)
                return AuthenticationAction.signedIn(user: user, token: token)
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
                return AuthenticationAction.signedIn(user: user, token: nil)
            }
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .signedIn(let user, let token):
        state.authFailure = nil
        state.currentUser = user
        state.accessToken = token
        state.didSignIn = true
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
        return environment
            .authenticationClient
            .googleSignIn(googleUser)
            .map { token in
                environment.keychain.setAccessToken(token.accessToken)
                return AuthenticationAction.loggedInWithIstoryFromGoogle(User(email: googleUser.email), token)
            }
            .catch { Just(AuthenticationAction.authFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .loggedInWithIstoryFromGoogle(let user, let token):
        state.currentUser = user
        state.accessToken = token
        environment.notificationCenter.post(name: .userDidLogIn, object: nil)
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
        environment.keychain.setUserEmail(email)
        return environment.authenticationClient
            .forgotPassword(email)
            .map { AuthenticationAction.forgotPasswordSubmitted }
            .catch { Just(AuthenticationAction.forgotPasswordFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .forgotPasswordFailure(let reason):
        break
    case .forgotPasswordSubmitted:
        state.showForgotPasswordAccessCodeFlow = true
    case .submitForgotPasswordAccessCode(let accessCode):
        guard let email = environment.keychain.getUserEmail() else {
            preconditionFailure("Email address not set")
        }
        return environment.authenticationClient
            .submitForgotPasswordAccessCodeWithEmail(accessCode, email)
            .map { token in
                environment.keychain.setAccessToken(token.accessToken)
                return AuthenticationAction.forgotPasswordAcessCodeSubmitted(email: email, token: token.accessToken)
            }
            .catch { Just(AuthenticationAction.forgotPasswordFailure(reason: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .forgotPasswordAcessCodeSubmitted(let email, let token):
        guard let email = environment.keychain.getUserEmail() else {
            preconditionFailure("Email address not set")
        }
        state.accessToken = AccessToken(accessToken: token)
        state.currentUser = User(email: email, didSubmitValidAccessCodeInSession: true)
        environment.notificationCenter.post(name: .userDidLogIn, object: nil)
    }
    return Empty().eraseToAnyPublisher()
}
