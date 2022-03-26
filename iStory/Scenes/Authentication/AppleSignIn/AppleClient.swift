//
//  AppleClient.swift
//  iStory
//
//  Created by Nikola Stojanovic on 26.3.22..
//

import Foundation
import Combine
import os.log
import AuthenticationServices

typealias AppleIDToken = String

/// A type which is responsible for coordinating Apple's sign in flow
struct AppleClient {
    // MARK: - API

    /// Publisher responsible for providing the user's apple id JWT
    var delegate: AnyPublisher<AppleIDToken, Error>
    /// Starts an interactive sign-in flow
    var signIn: (UIViewController & ASAuthorizationControllerPresentationContextProviding) -> Void

    // MARK: Production entry point

    static var production: AppleClient {
        let subject = PassthroughSubject<AppleIDToken, Error>()
        var delegate: AppleSignInDelegate? = AppleSignInDelegate(subject: subject)
        return Self(
            delegate: subject
                .handleEvents(receiveCancel: { delegate = nil })
                .eraseToAnyPublisher(),
            signIn: { viewController in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = delegate
                authorizationController.presentationContextProvider = viewController
                authorizationController.performRequests()
            }
        )
    }
}

// MARK: - Implementation details

private extension AppleClient {
    final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
        let subject: PassthroughSubject<AppleIDToken, Error>
        private let logger = Logger(subsystem: "iStory.app", category: "appleSignIn")

        init(subject: PassthroughSubject<AppleIDToken, Error>) {
            self.subject = subject
            super.init()
        }
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
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
            subject.send(tokenString)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            guard let error = error as? ASAuthorizationError else {
                logger.error("Apple sign in failed due to: \(error.localizedDescription)")
                return
            }
            switch error.code {
            case .canceled:
                logger.error("Apple sign in failure: Canceled")
            case .unknown:
                logger.error("Apple sign in failure: Unknown")
            case .invalidResponse:
                logger.error("Apple sign in failure: Invalid Respone")
            case .notHandled:
                logger.error("Apple sign in failure: Not handled")
            case .failed:
                logger.error("Apple sign in failure: Failed")
            case .notInteractive:
                logger.error("Apple sign in failure: Not interactive")
            @unknown default:
                logger.error("Apple sign in failure: Unknown default")
            }
            subject.send(completion: .failure(error))
        }
    }
}
