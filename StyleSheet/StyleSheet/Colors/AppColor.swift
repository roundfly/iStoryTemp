//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import SwiftUI

enum AppColor: String, View, Identifiable, CaseIterable {
    case black = "Black"
    case blue = "Blue"
    case green = "Green"
    case white = "White"
    case yellow = "Yellow"

    public var id: String {
        rawValue
    }

    public var body: Color {
        Color(uiColor)
    }

    public var uiColor: UIColor {
        guard let color = UIColor(named: rawValue, in: .styleSheet, compatibleWith: nil) else {
            assertionFailure("Invalid color queried from bundle, using name: \(rawValue)")
            return .clear
        }
        return color
    }
}
