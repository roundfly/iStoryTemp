//
//  HTTPClient.swift
//  iStory
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import Alamofire
import Foundation
import NetworkServiceAPI

typealias Parameters = [String: Any]

protocol HTTPClient {
    var sessionManager: Session { get }
    var url: String { get }
    var baseURL: String { get }
    var path: String { get }
    var params: Parameters? { get }
    var headers: [String: String]? { get }
    var requestMethod: RequestMethod { get }

    func execute() async throws -> Data
}

extension HTTPClient {
    var sessionManager: Session {
        AppEnvironment.networking.session
    }

    var url: String {
        "\(baseURL)\(path)"
    }

    var baseURL: String {
        AppEnvironment.networking.configuration.environment.baseURLString
    }

    var path: String {
        ""
    }

    var params: Parameters? {
        nil
    }

    var headers: [String: String]? {
        nil
    }

    var requestMethod: RequestMethod {
        .get
    }

    var encoding: ParameterEncoding {
        requestMethod == .get ? URLEncoding.default : JSONEncoding.default
    }

    // MARK: - Executing request

    @discardableResult
    func execute() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let httpHeaders = HTTPHeaders(headers ?? [:])
            sessionManager.request(url, method: HTTPMethod(rawValue: requestMethod.rawValue), parameters: params, encoding: encoding, headers: httpHeaders)
                .validate()
                .responseJSON { response in
                    let result = HTTPResponseMapper.map(response.response)
                    switch result {
                    case .success(.success):
                        guard let data = response.data else {
                            continuation.resume(throwing: HTTPClientError.badRequest)
                            return
                        }
                        continuation.resume(returning: data)
                    case .success(.noContent):
                        continuation.resume(returning: Data())
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
