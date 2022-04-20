//
//  SignUpWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import Foundation
import NetworkServiceAPI

struct SignUpWorker: HTTPClient {
    var email: String
    var password: String
    var path: String {
        "api/register"
    }

    var requestMethod: RequestMethod {
        .post
    }

    var params: Parameters? {
        [
            "email": email,
            "password": password
        ]
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func performSignUp() async throws -> User {
        try await execute()
        return User(email: email, number: nil, password: password)
    }
}
