//
//  BirthDateWorker.swift
//  iStory
//
//  Created by Nikola Stojanovic on 29.4.22..
//

import NetworkServiceAPI

struct BirthDateWorker: HTTPClient {
    var email: String
    var birthday: String
    var path: String {
        "api/birthday"
    }

    var requestMethod: RequestMethod {
        .post
    }

    var params: Parameters? {
        [
            "email": email,
            "birthday": birthday
        ]
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func submitBirthday() async throws {
        try await execute()
    }
}
