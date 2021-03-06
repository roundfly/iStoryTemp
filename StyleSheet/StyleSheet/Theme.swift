//
//  Theme.swift
//  StyleSheet
//
//  Created by Shyft on 3/20/22.
//

import Foundation
import UIKit

public protocol Theme {
    var colorBlack: UIColor { get }
    var colorBlue: UIColor { get }
    var colorGreen: UIColor { get }
    var colorWhite: UIColor { get }
    var colorYellow: UIColor { get }
}

public struct ThemeDefault: Theme {
    
    public init() {
        
    }
    
    public var colorBlack: UIColor { AppColor.black.uiColor }
    
    public var colorBlue: UIColor { AppColor.blue.uiColor }
    
    public var colorGreen: UIColor { AppColor.green.uiColor }
    
    public var colorWhite: UIColor { AppColor.white.uiColor }
    
    public var colorYellow: UIColor { AppColor.yellow.uiColor }
    
    public var fontRegular: UIFont { .init(name: "Gotham-Black", size: 12)! }
    
    public var fontMedium: UIFont { .init(name: "Gotham-Medium", size: 20)! }

    public var fontBold: UIFont { .init(name: "Gotham-Bold", size: 48)! }
}
