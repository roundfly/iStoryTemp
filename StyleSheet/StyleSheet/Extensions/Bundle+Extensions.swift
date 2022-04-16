//
//  Bundle+Extensions.swift
//  StyleSheet
//
//  Created by Shyft on 3/20/22.
//

import Foundation

internal extension Bundle {
    static var styleSheet: Bundle {
        let identifier = "com.istoryapp.stylesheet"
        guard let bundle = Bundle(identifier: identifier) else {
            preconditionFailure("Invalid identifier used for design system bundle: \(identifier)")
        }
        return bundle
    }
}

func Loc(_ key: String, table: String? = nil, comment: String = "") -> String {
    NSLocalizedString(key, tableName: table, bundle: .styleSheet, value: key, comment: comment)
}
