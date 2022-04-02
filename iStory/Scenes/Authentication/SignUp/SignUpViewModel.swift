//
//  SignUpViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Combine
import GoogleSignInService
import AuthenticationServices

final class AuthenticationSignUpViewModel {
    typealias Dependencies = GoogleDependency & AppleDependency
    private let googleClient: GoogleClient
    private let appleClient: AppleClient
    var signupPublisher: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Void, Never>()

    init(dependencies: Dependencies) {
        self.googleClient = dependencies.googleClient
        self.appleClient = dependencies.appleClient
    }

    func onAppleRequest(req: ASAuthorizationAppleIDRequest) {
        // todo
    }

    func onAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        // todo
    }

    func onAmazon() {
        // todo
    }

    func onIstorySignUp() {
        subject.send(())
    }

    func onGoogle() {
        // todo
    }
}
