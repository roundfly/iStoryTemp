//
//  UIScreen+Extensions.swift
//  StyleSheet
//
//  Created by Shyft on 4/2/22.
//

import Foundation
import UIKit

public enum DeviceSize {
    case extraSmall
    case small
    case normal
    case medium
    case large
    case ipad

    public var isSmallOrLess: Bool {
        self == .small || self == .extraSmall
    }
}

public extension UIScreen {
    func getDeviceSize() -> DeviceSize {
        let screenWidth = min(bounds.width, bounds.height)
        
        switch screenWidth {
        case 320:
            return .extraSmall
        case 375:
            return .small
        case 390:
            return .normal
        case 414:
            return .medium
        case 428:
            return .large
        case let value where value > 428:
            return .ipad
        default:
            fatalError("Currently running iPhone or iPad is not supported in UIScreen extension, please add it")
        }
    }
}
