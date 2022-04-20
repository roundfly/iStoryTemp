//
//  HTTPResponseMapper.swift
//  iStory
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import Foundation
import NetworkServiceAPI

enum HTTPResponseMapper {
    static func map(_ response: URLResponse?) -> Result<HTTPClientResponse, Error> {
        guard let response = response as? HTTPURLResponse else {
            return .failure(HTTPClientError.badRequest)
        }
        switch response.statusCode {
        case 204 ... 205: return .success(.noContent)
        case 200 ... 299: return .success(.success)
        case 400: return .failure(HTTPClientError.badRequest)
        case 401: return .failure(HTTPClientError.unauthorized)
        case 403: return .failure(HTTPClientError.forbidden)
        case 404: return .failure(HTTPClientError.notFound)
        case 503: return .failure(HTTPClientError.noInternet)
        case 500 ... 599: return .failure(HTTPClientError.internalServerError)
        default: return .failure(HTTPClientError.requestFailed(code: response.statusCode))
        }
    }
}
