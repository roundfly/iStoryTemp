import Combine
import GoogleSignIn

public enum GoogleSignInEvent {
    case signIn(GoogleUser)
    case signOut
}

/// A type which is responsible for coordinating Google's sign in flow
@available(iOS 15.0.0, *)
public struct GoogleClient {

    // FIXME: GIDSignInDelegate was removed, update implementation details to use newer Google API's
    private final class Delegate: NSObject, GIDSignInDelegate {

        let subject: PassthroughSubject<GoogleSignInEvent, Error>

        init(subject: PassthroughSubject<GoogleSignInEvent, Error>) {
            self.subject = subject
            super.init()
        }

        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                subject.send(completion: .failure(error))
                return
            }
            guard let user = user else { return }
            let social = GoogleUser(id: user.userID.unwrapOrBlank,
                                    idToken: user.authentication.idToken.unwrapOrBlank,
                                    accessToken: user.authentication.accessToken,
                                    expirationDate: user.authentication.accessTokenExpirationDate,
                                    name: user.profile?.name,
                                    givenName: user.profile?.givenName.unwrapOrBlank,
                                    familyName: user.profile?.familyName.unwrapOrBlank,
                                    email: user.profile?.email)
            subject.send(.signIn(social))
        }
    }

    public var delegate: AnyPublisher<GoogleSignInEvent, Error>

    /// Starts an interactive sign-in flow using Google services
    public let signIn: () -> Void
    /// Marks current user as being in the signed out state
    public let signOut: () -> Void
    /// This closure should be called from `UIApplicationDelegate`'s `application:openURL:options`
    public let handle: (URL) -> Bool
    /// The view controller used to present the sign in flow
    public let presentingViewController: (UIViewController) -> Void

    private static var clientID: String {
        "GOOGLE_CLIENT_ID"
    }

    public static var production: GoogleClient {
        let subject = PassthroughSubject<GoogleSignInEvent, Error>()
        var delegate: Delegate? = Delegate(subject: subject)
        GIDSignIn.sharedInstance()?.delegate = delegate
        GIDSignIn.sharedInstance().clientID = Self.clientID
        return Self(delegate: subject
                        .handleEvents(receiveCancel: { delegate = nil })
                        .eraseToAnyPublisher(),
                    signIn: { GIDSignIn.sharedInstance()?.signIn() },
                    signOut: {
            GIDSignIn.sharedInstance()?.signOut()
            subject.send(.signOut)
        },
                    handle: { (url) in
            guard let didHandle = GIDSignIn.sharedInstance()?.handle(url) else { return false }
            return didHandle
        },
                    presentingViewController: { (viewController) in
            GIDSignIn.sharedInstance()?.presentingViewController = viewController
        }
        )
    }
}
