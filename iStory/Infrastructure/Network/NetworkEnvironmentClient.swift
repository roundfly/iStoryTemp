//
//  NetworkEnvironmentClient.swift
//  iStory
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import Foundation
import NetworkService

extension NetworkEnvironmentClient: NetworkEnvironment {
    public var scheme: String {
        switch self {
        case .development: return "http"
        case .production: return "http"
        }
    }

    public var domain: String {
        switch self {
        case .development: return "develop.istoryapp.com"
        case .production: return "develop.istoryapp.com"
        }
    }

    public var baseURLString: String {
        switch self {
        case .development: return "\(scheme)://\(domain)/"
        case .production: return "\(scheme)://\(domain)/"
        }
    }

    public var allowInvalidCerts: Bool {
        true
    }

    public var redirectUri: String {
        "http://develop.istoryapp.com/callback/auth"
    }

    public var clientId: Int {
        1
    }
}
