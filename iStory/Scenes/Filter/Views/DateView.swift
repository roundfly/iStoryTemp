//
//  DateView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/17/22.
//

import Foundation
import UIKit
import StyleSheet

enum DateFilterType {
    case from
    case to
}

final class DateView: UIView {
    private var type: DateFilterType = .from
    private let squaredContentView = UIView()
    private let textLabel = UILabel()
    private let dateLabel = UILabel()
    private let theme = ThemeDefault()
    
    convenience init(type: DateFilterType) {
        self.init(frame: .zero)
        self.type = type
        
        setupUI()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addManagedSubview(squaredContentView)
        squaredContentView.setConstraintsEqualToSuperView()
        squaredContentView.layer.cornerRadius = 13
        squaredContentView.clipsToBounds = true
        squaredContentView.backgroundColor = AppColor.backgroundGrayColor.uiColor
        
        squaredContentView.addManagedSubview(textLabel)
        textLabel.setConstraintsRelativeToSuperView(leading: 10)
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        textLabel.font = theme.fontBold.withSize(12)
        textLabel.text = type == .from ? "from" : "to"
        
        squaredContentView.addManagedSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10).activate()
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        dateLabel.font = theme.fontRegular.withSize(16)
        dateLabel.text = "05/05/2000"
    }
}
