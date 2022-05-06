//
//  LoginEmailWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import NetworkServiceAPI

struct LoginEmailWorker: HTTPClient {
    var email: String
    var password: String

    var path: String {
        "api/login"
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

    func performLogIn() async throws -> AccessToken {
        try await execute().decoded()
    }
}
