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
    private let datePicker = UIDatePicker()
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
        backgroundColor = .clear
        
//        addManagedSubview(squaredContentView)
//        squaredContentView.setConstraintsEqualToSuperView()
//        squaredContentView.layer.cornerRadius = 13
//        squaredContentView.clipsToBounds = true
//        squaredContentView.backgroundColor = AppColor.backgroundGrayColor.uiColor
        
        addManagedSubview(textLabel)
        textLabel.setConstraintsRelativeToSuperView(leading: 0)
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        textLabel.font = theme.fontBold.withSize(12)
        textLabel.text = type == .from ? "from" : "to"
        
        addManagedSubview(datePicker)
        let leadingOffset: CGFloat = type == .from ? 30 : 0
        datePicker.setConstraintsRelativeToSuperView(top: 0, leading: leadingOffset, bottom: 0, trailing: 0)
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()

        //dateLabel.font = theme.fontRegular.withSize(16)
        //dateLabel.text = "05/05/2000"
    }
}
