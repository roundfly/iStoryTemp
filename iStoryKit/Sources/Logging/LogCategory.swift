//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

/// A type which represents the category used in Apple's unified logging system.
/// This is on purposed modelled as a product type instead of a sum type
/// so as to introduce greater flexibility in specifying the value of the category rather
/// than having predefined cases. The static members defined provide sane defaults.
public struct Category: ExpressibleByStringLiteral {
    var value: String

    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    public static var authentication: Category {
        #function
    }

    public static var activity: Category {
        #function
    }

    public static var networking: Category {
        #function
    }

    public static var persistence: Category {
        #function
    }

    public static var userInterface: Category {
        #function
    }

    public static var fileSystem: Category {
        #function
    }

    public static var analytics: Category {
        #function
    }

    public static var comments: Category {
        #function
    }

    public static var decoding: Category {
        #function
    }

    public static var encoding: Category {
        #function
    }

    public static var main: Category {
        #function
    }
}
