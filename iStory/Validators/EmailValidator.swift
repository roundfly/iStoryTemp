//
//  EmailValidator.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

import Foundation

struct EmailValidator: Validatable {
    
    private static let emailRegex: String = "[\\w._%+-|]+@[\\w0-9.-]+\\.[A-Za-z]{2,}"

    static func isValid(_ mail: String) -> Bool {
        return regex(value: mail, pattern: emailRegex)
    }
}
        
        
