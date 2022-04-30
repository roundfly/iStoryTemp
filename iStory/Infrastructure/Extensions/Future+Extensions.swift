//
//  Future+Extensions.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import Combine

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
