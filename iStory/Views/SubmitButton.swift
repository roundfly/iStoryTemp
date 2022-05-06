//
//  SubmitButton.swift
//  iStory
//
//  Created by Shyft on 4/2/22.
//

import Foundation
import UIKit
import StyleSheet

final class SubmitButton: UIButton {
    private let theme = ThemeDefault()
    
    var textColor: UIColor? {
        didSet {
            setTitleColor(textColor, for: .normal)
            setTitleColor(textColor?.withAlphaComponent(0.5), for: .disabled)
        }
    }
    
    var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 13
        backgroundColor = AppColor.blue.uiColor.withAlphaComponent(0.9)
        titleLabel?.font = theme.fontMedium.withSize(20)
    }
    
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    private func updateBackgroundColor() {
        backgroundColor = isEnabled ? AppColor.blue.uiColor.withAlphaComponent(0.9) : AppColor.blue.uiColor.withAlphaComponent(0.7)
    }
}
