//
//  String+Extensions.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 18.4.22..
//

import UIKit

public extension String {
    func bolded(text: String, font: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        if let range = self.range(of: text) {
            let startIndex = self.distance(from: self.startIndex, to: range.lowerBound)
            let range = NSMakeRange(startIndex, text.count)
            attributedString.addAttributes([.font : UIFont.boldSystemFont(ofSize: font.pointSize)], range: range)
        }
        return attributedString
    }
}
