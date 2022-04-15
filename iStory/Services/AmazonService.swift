//
//  AmazonService.swift
//  iStory
//
//  Created by Shyft on 3/28/22.
//

import Combine
import LoginWithAmazon

final class AmazonService {
    func openAuthorizeRequest() -> AnyPublisher<String, Error> {
        let request = AMZNAuthorizeRequest()
        request.scopes = [AMZNProfileScope.profile(), AMZNProfileScope.postalCode()]
        return Future { promise in
            AMZNAuthorizationManager.shared().authorize(request) { result, isSuccess, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                if let token = result?.token {
                    promise(.success(token))
                }
            }
        }.eraseToAnyPublisher()
    }
}
