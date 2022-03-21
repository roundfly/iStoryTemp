import Foundation

/// A user model associated with the response from Google's signup service
public struct GoogleUser {
    /// Client side identifier
    public var id: String?
    /// Remote identifier
    public var idToken: String?
    /// The OAuth2 access token for accessing Google services
    public var accessToken: String?
    /// The estimated expiration date of the access token
    public var expirationDate: Date?
    /// The Google user's full name
    public var name: String?
    /// The Google user's given name
    public var givenName: String?
    /// The Google user's family name
    public var familyName: String?
    /// The Google user's email
    public var email: String?

    public init(
        id: String? = nil,
        idToken: String? = nil,
        accessToken: String? = nil,
        expirationDate: Date? = nil,
        name: String? = nil,
        givenName: String? = nil,
        familyName: String? = nil,
        email: String? = nil
    ) {
        self.id = id
        self.idToken = idToken
        self.accessToken = accessToken
        self.expirationDate = expirationDate
        self.name = name
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
}
