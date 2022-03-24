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

    // MARK: - Initialization

    public init(signIn: @escaping (UIViewController) -> AnyPublisher<GoogleUser, Error>,
                signOut: @escaping () -> Void,
                disconnect: @escaping () -> AnyPublisher<Void, Error>) {
        self.signIn = signIn
        self.signOut = signOut
        self.disconnect = disconnect
    }

    // MARK: Production entry point

    public static var prodution: GoogleClient {
        Self(signIn: _signIn(presenting:), signOut: _signOut, disconnect: _disconnect)
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
