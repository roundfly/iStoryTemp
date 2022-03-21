//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

public enum HTTPClientError: Error {
    case badRequest // response code 400
    case unauthorized // response code 401
    case forbidden // response code 403
    case notFound // response code 404
    case internalServerError // response code 500
    case noInternet // response code 503
    case requestFailed(code: Int) // Row error localized description
    case jsonConversionFailure(reason: String)

    var customDescription: String {
        switch self {
        case .badRequest: return "server returned bad request error."
        case .unauthorized: return "the client is not authorized error."
        case .forbidden: return "request is forbidden."
        case .notFound: return "the requested content is not found."
        case .internalServerError: return "something is wrong on server, notify admin."
        case .noInternet: return "no internet connection."
        case let .requestFailed(code): return "request failed with status code: \(code)."
        case let .jsonConversionFailure(reason): return "json conversion failed: \(reason)."
        }
    }
}
