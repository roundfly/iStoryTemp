//
//  Validator.swift
//  iStory
//
//  Created by Shyft on 4/9/22.
//

import Foundation

protocol Validatable {
    static func isValid(_: String) -> Bool
}

extension Validatable {
    static func regex(value: String, pattern: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regexText.evaluate(with: value)
    }
}
