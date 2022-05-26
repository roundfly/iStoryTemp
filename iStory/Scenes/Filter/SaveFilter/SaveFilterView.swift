//
//  SaveFilterView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/20/22.
//

import Foundation
import UIKit
import StyleSheet

final class SaveFilterView: UIView {
    private let titleLabel = UILabel()
    private let searchBar = SearchBar(type: .fullWidth, frame: .zero)
    private let theme = ThemeDefault()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addManagedSubview(titleLabel)
        titleLabel.setConstraintsRelativeToSuperView(top: 0, leading: 0, trailing: 50)
        titleLabel.font = theme.fontBold.withSize(16)
        titleLabel.text = "Save filter"
        
        addManagedSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).activate()
        searchBar.setConstraintsRelativeToSuperView(leading: 0, trailing: 90)
        searchBar.setSizeConstraints(height: 30)
        searchBar.placeholder = "Add title"
    }
    
}
