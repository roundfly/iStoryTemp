//
//  FilterDateView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/17/22.
//

import Foundation
import UIKit
import StyleSheet

final class FilterDateView: UIView {
    
    private let titleLabel = UILabel()
    private let fromDateView = DateView(type: .from)
    private let toDateView = DateView(type: .to)
    private let theme = ThemeDefault()
    private var flowController: FilterFlowController!

    convenience init(flowController: FilterFlowController) {
        self.init(frame: .zero)
        self.flowController = flowController
        
        setupUI()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addManagedSubview(titleLabel)
        titleLabel.setConstraintsRelativeToSuperView(top: 0, leading: 0, trailing: 50)
        titleLabel.font = theme.fontBold.withSize(16)
        titleLabel.text = "Filter by date"

        addManagedSubview(fromDateView)
        fromDateView.setConstraintsRelativeToSuperView(leading: 0)
        fromDateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).activate()
        fromDateView.setSizeConstraints(width: 157, height: 56)
        
        addManagedSubview(toDateView)
        toDateView.leadingAnchor.constraint(equalTo: fromDateView.trailingAnchor).activate()
        toDateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).activate()
        toDateView.setSizeConstraints(width: 140, height: 56)
    }
}
