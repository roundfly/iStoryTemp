//
//  ForgotPasswordWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import NetworkServiceAPI

struct ForgotPasswordWorker: HTTPClient {
    var email: String
    var path: String {
        "api/forgot-password/code"
    }

    var requestMethod: RequestMethod {
        .post
    }

    var params: Parameters? {
        [
            "email": email,
        ]
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func performForgotPassword() async throws {
        try await execute()
    }
}
