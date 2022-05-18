//
//  FilterViewController.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/13/22.
//

import Foundation
import UIKit
import StyleSheet

final class FilterViewController: UIViewController {
    private var filterByPeopleView: FilterByPeopleView!
    private let titleLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let theme = ThemeDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addManagedSubview(titleLabel)
        titleLabel.text = "Filter"
        titleLabel.setConstraintsRelativeToSuperView(top: 45, leading: 70, trailing: 70)
        titleLabel.font = theme.fontBold.withSize(20)
        titleLabel.textAlignment = .center
        
        let images: [UIImage] = [.checkmark, .remove, .checkmark, .remove, .checkmark, .remove, .checkmark, .remove, .checkmark]
        filterByPeopleView = FilterByPeopleView(peopleImages: images)
        view.addManagedSubview(filterByPeopleView)
        filterByPeopleView.setConstraintsRelativeToSuperView(top: 100, leading: 0, trailing: 0)
        filterByPeopleView.setSizeConstraints(height: 200)
    }
}
