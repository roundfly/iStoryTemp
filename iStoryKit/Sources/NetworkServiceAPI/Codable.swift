//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

public extension Data {

    func decoded<T: Decodable>() throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: self)
        } catch {
            print("Error \(error)")
            throw HTTPClientError.jsonConversionFailure(reason: error.localizedDescription)
        }
    }
}

public extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }
}

extension Formatter {
    static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        let formatter = Formatter.iso8601WithFractionalSeconds
        guard let date = formatter.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date \(string)")
        }
        return date
    }
}
