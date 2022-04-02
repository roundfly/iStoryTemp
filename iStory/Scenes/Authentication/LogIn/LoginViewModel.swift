//
//  LoginViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import GoogleSignInService
import AuthenticationServices

final class AuthenticationLoginViewModel {
    typealias Dependencies = GoogleDependency & AppleDependency
    private let googleClient: GoogleClient
    private let appleClient: AppleClient

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

    func onIstoryLogin() {
        // todo
    }

    func onGoogle() {
        // todo
    }
}
