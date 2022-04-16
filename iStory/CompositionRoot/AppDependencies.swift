//
//  AppDependencies.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import Foundation
import GoogleSignInService
import KeychainSwift
import KeychainService
import KeychainServiceAPI
import PhoneNumberKit
import NetworkService

struct Authenticator: AuthenticatorProtocol {
    var isUserLoggedIn: Bool = false

    func requestToken(with parameters: RequestTokenParams) async throws {

    }

    func refreshToken(with parameters: RefreshTokenParams) async throws {

    }
}

struct AppEnvironment {
    var authentication: AuthenticationEnvironment
    static var networking: NetworkManager = {
        let configuration = NetworkConfiguration(environment: EnvironmentFactory.getEnvironment())
        let interceptor = NetworkRequestInterceptor(configuration: configuration,
                                                    keychain: KeychainService(keychain: KeychainWrapper(keychain: KeychainSwift())),
                                                    authenticator: Authenticator())
        let manager = NetworkManager(configuration: configuration, interceptor: interceptor)
        return manager
    }()

    static var production: AppEnvironment {
        Self(authentication: .init(amazonClient: .init()))
    }
}
