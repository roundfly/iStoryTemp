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
    typealias Dependencies = GoogleDependency & AppleDependency & AmazonDependency
    private let googleClient: GoogleClient
    private let appleClient: AppleClient
    private let amazonService: AmazonService
    var signupPublisher: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(dependencies: Dependencies) {
        self.googleClient = dependencies.googleClient
        self.appleClient = dependencies.appleClient
        self.amazonService = dependencies.amazonService
    }

    func onAppleRequest(req: ASAuthorizationAppleIDRequest) {
        // todo
    }

    func onAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        // todo
    }

    func onAmazon() {
        amazonService.openAuthorizeRequest()
    }

    func onIstorySignUp() {
        subject.send(())
    }

    func onGoogle() {
        guard let currentViewController = UIApplication.shared.topMostViewController() else {
            NSLog("Can not present Google sign in, beacuse topMostViewController can not be found")
            return
        }
        
        googleClient.signIn(currentViewController)
            .sink { error in
                NSLog("Error fetching google user \(error)")
            } receiveValue: { user in
                NSLog("User has founded with email \(user.email ?? "unknown")")
            }.store(in: &cancellables)
    }
}
