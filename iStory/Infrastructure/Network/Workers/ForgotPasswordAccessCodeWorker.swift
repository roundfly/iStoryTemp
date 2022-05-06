//
//  ForgotPasswordAccessCodeWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import NetworkServiceAPI

struct ForgotPasswordAccessCodeWorker: HTTPClient {
    var email: String
    var accessCode: String

    var path: String {
        "api/forgot-password/verify"
    }

    var requestMethod: RequestMethod {
        .post
    }

    var params: Parameters? {
        [
            "email": email,
            "code": accessCode
        ]
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func submitAccessCode() async throws -> AccessToken {
        try await execute().decoded()
    }
}
