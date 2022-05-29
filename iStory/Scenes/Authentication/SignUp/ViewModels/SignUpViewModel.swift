//
//  SignUpViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import os.log
import GoogleSignInService
import AuthenticationServices

final class AuthenticationSignUpViewModel {
    private let store: AuthenticationStore
    var signupPublisher: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    var tryAppPublisher: AnyPublisher<Void, Never> {
        tryAppSubject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Void, Never>()
    private let tryAppSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger(subsystem: "iStory.app", category: "appleSignIn")

    init(store: AuthenticationStore) {
        self.store = store
    }

    func onAppleRequest(req: ASAuthorizationAppleIDRequest) {
        req.requestedScopes = [.email]
    }

    func onAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard
                let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                let token = credential.identityToken
            else {
                logger.info("Unable to fetch identity token")
                return
            }
            guard let tokenString = String(data: token, encoding: .utf8) else {
                logger.info("Unable to serialize token string from data: \(token.debugDescription)")
                return
            }
            logger.info("Apple jwt: \(tokenString)")
        case .failure(let error):
            logger.error("Apple login error: \(error.localizedDescription)")
        }
    }

    func onAmazon() {
        store.dispatch(.amazonSignIn)
    }

    func onIstorySignUp() {
        subject.send(())
    }

    func onGoogle() {
        guard let currentViewController = UIApplication.shared.topMostViewController() else {
            NSLog("Can not present Google sign in, beacuse topMostViewController can not be found")
            return
        }
        store.dispatch(.googleSignIn(presentingViewController: currentViewController))
    }

    func tryApp() {
        tryAppSubject.send()
    }
}
