import Combine
import GoogleSignIn

public enum GoogleSignInEvent {
    case signIn(GoogleUser)
    case signOut
}

/// A type which is responsible for coordinating Google's sign in flow
@available(iOS 15.0.0, *)
public struct GoogleClient {
    // MARK: - API

    /// Starts an interactive sign-in flow
    public var signIn: (_ viewController: UIViewController) -> AnyPublisher<GoogleUser, Error>

    /// Marks current user as being in the signed out state.
    public var signOut: () -> Void

    /// Disconnects the current user from the app and revokes previous authentication.
    /// If the operation succeeds, the OAuth 2.0 token is also removed from keychain.
    public var disconnect: () -> AnyPublisher<Void, Error>

    /// Attempts to restore a previously authenticated user without interaction.
    public var restorePreviousSignIn: () -> AnyPublisher<GoogleUser, Error>

    /// This method should be called from your `UIApplicationDelegate`'s `application:openURL:options:` method.
    public var handle: (_ url: URL) -> Bool

    // MARK: - Initialization

    public init(signIn: @escaping (UIViewController) -> AnyPublisher<GoogleUser, Error>,
                signOut: @escaping () -> Void,
                disconnect: @escaping () -> AnyPublisher<Void, Error>,
                restorePreviousSignIn: @escaping () -> AnyPublisher<GoogleUser, Error>,
                handle: @escaping (URL) -> Bool) {
        self.signIn = signIn
        self.signOut = signOut
        self.disconnect = disconnect
        self.restorePreviousSignIn = restorePreviousSignIn
        self.handle = handle
    }

    // MARK: Production entry point

    public static var prodution: GoogleClient {
        Self(signIn: _signIn,
             signOut: _signOut,
             disconnect: _disconnect,
             restorePreviousSignIn: _restorePreviousSignIn,
             handle: _handle
        )
    }

    internal static var clientID: String {
        "312001111901-6q70v9716e3vef9nnvovl1291df80ngk.apps.googleusercontent.com"
    }
}

// MARK: - Implementation details

private func _signIn(presenting viewController: UIViewController) -> AnyPublisher<GoogleUser, Error> {
    Deferred {
        Future { promise in
            let signInConfig = GIDConfiguration(clientID: GoogleClient.clientID)
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController) { user, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                let social = GoogleUser(id: user?.userID.unwrapOrBlank,
                                        idToken: user?.authentication.idToken.unwrapOrBlank,
                                        accessToken: user?.authentication.accessToken,
                                        expirationDate: user?.authentication.accessTokenExpirationDate,
                                        name: user?.profile?.name,
                                        givenName: user?.profile?.givenName.unwrapOrBlank,
                                        familyName: user?.profile?.familyName.unwrapOrBlank,
                                        email: user?.profile?.email)
                promise(.success(social))
            }
        }
    }.eraseToAnyPublisher()
}

private func _signOut() {
    GIDSignIn.sharedInstance.signOut()
}

private func _disconnect() -> AnyPublisher<Void, Error> {
    Deferred {
        Future { promise in
            GIDSignIn.sharedInstance.disconnect { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(()))
            }
        }
    }.eraseToAnyPublisher()
}

private func _restorePreviousSignIn() -> AnyPublisher<GoogleUser, Error> {
    Deferred {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                let social = GoogleUser(id: user?.userID.unwrapOrBlank,
                                        idToken: user?.authentication.idToken.unwrapOrBlank,
                                        accessToken: user?.authentication.accessToken,
                                        expirationDate: user?.authentication.accessTokenExpirationDate,
                                        name: user?.profile?.name,
                                        givenName: user?.profile?.givenName.unwrapOrBlank,
                                        familyName: user?.profile?.familyName.unwrapOrBlank,
                                        email: user?.profile?.email)
                promise(.success(social))
            }
        }
    }.eraseToAnyPublisher()
}

private func _handle(url: URL) -> Bool {
    GIDSignIn.sharedInstance.handle(url)
}
