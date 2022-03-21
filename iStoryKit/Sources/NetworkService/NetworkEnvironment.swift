//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

public enum EnvironmentFactory {
    public static func getEnvironment() -> NetworkEnvironmentClient {
        #if DEBUG
            return .development
        #else
            return .production
        #endif
    }
}

public protocol NetworkEnvironment {
    var scheme: String { get }
    var domain: String { get }
    var baseURLString: String { get }
    var allowInvalidCerts: Bool { get }
    var redirectUri: String { get }
    var clientId: Int { get }
}

public enum NetworkEnvironmentClient {
    case development
    case production
}
