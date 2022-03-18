//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

public struct NetworkConfiguration {
    public private(set) var environment: NetworkEnvironment

    public init(environment: NetworkEnvironment) {
        self.environment = environment
    }
}
