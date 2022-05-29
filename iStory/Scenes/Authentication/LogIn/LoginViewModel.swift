//
//  LoginViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import GoogleSignInService
import AuthenticationServices

final class AuthenticationLoginViewModel {
    private let store: AuthenticationStore
    var loginPublisher: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    var tryAppPublisher: AnyPublisher<Void, Never> {
        tryAppSubject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Void, Never>()
    private let tryAppSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(store: AuthenticationStore) {
        self.store = store
    }

    func onAppleRequest(req: ASAuthorizationAppleIDRequest) {
        // todo
    }

    func onAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        // todo
    }

    func onAmazon() {
        store.dispatch(.amazonSignIn)
    }

    func onIstoryLogin() {
        subject.send(())
    }

    func tryApp() {
        tryAppSubject.send()
    }

    func onGoogle() {
        guard let currentViewController = UIApplication.shared.topMostViewController() else {
            NSLog("Can not present Google sign in, beacuse topMostViewController can not be found")
            return
        }
        store.dispatch(.googleSignIn(presentingViewController: currentViewController))
    }
}
