//
//  UIImage+Extensions.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit

public extension UIImage {
    private class Klass {}
    convenience init?(namedInStyleSheet name: String) {
        self.init(named: name, in: Bundle(for: Klass.self), compatibleWith: nil)
    }
}
