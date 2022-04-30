//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Alamofire
import Foundation
import KeychainServiceAPI

public enum AuthenticationError: Error, Equatable {
    case badURL
    case badAuthentication
    case tokenStoringFailed

    var customDescription: String {
        switch self {
        case .badURL: return "unable to build authorization url."
        case .badAuthentication: return "could not get authorization url"
        case .tokenStoringFailed: return "could not store authorization token in the keychain"
        }
    }
}

public struct RequestTokenParams {
    public let clientId: Int
    public let redirectUri: String
    public let code: String
    public let codeVerifier: String

    public init(clientId: Int, redirectUri: String, code: String, codeVerifier: String) {
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.code = code
        self.codeVerifier = codeVerifier
    }
}

public struct RefreshTokenParams {
    public let clientId: Int
    public let redirectUri: String
    public let refreshToken: String

    public init(clientId: Int, redirectUri: String, refreshToken: String) {
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.refreshToken = refreshToken
    }
}
public protocol AuthenticatorProtocol {
    var isUserLoggedIn: Bool { get }
    func requestToken(with parameters: RequestTokenParams) async throws
    func refreshToken(with parameters: RefreshTokenParams) async throws
}

@available(iOS 15.0.0, *)
public final class NetworkRequestInterceptor: RequestInterceptor {
    private let HTTP_UNAUTHORIZED = 401
    private let retryLimit = 3
    private var configuration: NetworkConfiguration
    private var keychain: KeychainServiceAPI
    private var authenticator: AuthenticatorProtocol

    public init(configuration: NetworkConfiguration,
                keychain: KeychainServiceAPI,
                authenticator: AuthenticatorProtocol) {
        self.configuration = configuration
        self.keychain = keychain
        self.authenticator = authenticator
    }

    public func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        if let accessToken = keychain.getAccessToken() {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        completion(.success(urlRequest))
    }

    public func retry(_ request: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
//        // Retry if user is not authorized and if refreshToken exists
//        guard shouldRetry(response: request.response), let refreshToken = keychain.getRefreshToken() else {
//            completion(.doNotRetry)
//            return
//        }
//
//        if canRetry(request: request) {
//            Task {
//                let refreshTokenParams = RefreshTokenParams(clientId: configuration.environment.clientId,
//                                                            redirectUri: configuration.environment.redirectUri,
//                                                            refreshToken: refreshToken)
//                do {
//                    try await authenticator.refreshToken(with: refreshTokenParams)
//                } catch {
//                    // logger(category: .networking).error("Refresh token fails with error \(error.localizedDescription)")
//                }
//                completion(.retry)
//            }
//        } else {
//            completion(.doNotRetry)
//            // MY-TODO: Logout and reset ui
//        }
    }

    private func shouldRetry(response: HTTPURLResponse?) -> Bool {
        response?.statusCode == HTTP_UNAUTHORIZED
    }

    private func canRetry(request: Request) -> Bool {
        request.retryCount <= retryLimit
    }
}
