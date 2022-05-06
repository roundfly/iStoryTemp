//
//  EmailAccessCodeWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 29.4.22..
//

import NetworkServiceAPI

struct EmailAccessCodeWorker: HTTPClient {
    var email: String
    var accessCode: String
    var path: String {
        "api/verify"
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

    func submitAccessCode() async throws {
        try await execute()
    }
}
