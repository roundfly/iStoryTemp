//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation.NSBundle
import os.log

/// Utility procedure for generating an instance of a Logger
/// - Parameters:
///   - bundle: An instance of a Bundle from which an identifier is used for specifying the subsystem
///   - category: The category of the underlying Logger instance
/// - Returns: A Logger of the unified logging system
public func logger(_ bundle: Bundle = .main, category: Category) -> Logger {
    Logger(subsystem: bundle.bundleIdentifier ?? "", category: category.value)
}
