//
//  GoogleSignInWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import NetworkServiceAPI

struct GoogleSignInWorker: HTTPClient {
    var accessToken: String
    var path: String {
        "api/social/google"
    }

    var requestMethod: RequestMethod {
        .post
    }

    var params: Parameters? {
        [
            "access_token": accessToken,
        ]
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func performSignUp() async throws {
        try await execute()
    }
}
