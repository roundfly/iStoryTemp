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
    private let filterByDate = FilterDateView()
    private let titleLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let submitButton = SubmitButton()
    
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
        
        view.addManagedSubview(leftButton)
        leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).activate()
        leftButton.setSizeConstraints(width: 25, height: 25)
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).activate()
        
        view.addManagedSubview(rightButton)
        rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).activate()
        rightButton.setSizeConstraints(width: 25, height: 25)
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).activate()

        leftButton.setImage(UIImage(namedInStyleSheet: "arrow-clockwise"), for: .normal)
        rightButton.setImage(UIImage(namedInStyleSheet: "bookmark"), for: .normal)
        
        let images: [UIImage] = [.checkmark, .remove, .checkmark, .remove, .checkmark, .remove, .checkmark, .remove, .checkmark]
        filterByPeopleView = FilterByPeopleView(peopleImages: images)
        view.addManagedSubview(filterByPeopleView)
        filterByPeopleView.setConstraintsRelativeToSuperView(top: 100, leading: 0, trailing: 0)
        filterByPeopleView.setSizeConstraints(height: 100)
        
        view.addManagedSubview(filterByDate)
        filterByDate.topAnchor.constraint(equalTo: filterByPeopleView.bottomAnchor, constant: 10).activate()
        filterByDate.setConstraintsRelativeToSuperView(leading: 0, trailing: 0)
        filterByDate.setSizeConstraints(height: 100)
        
        view.addManagedSubview(submitButton)
        submitButton.setConstraintsRelativeToSuperView(leading: 15, bottom: 30, trailing: 15)
        submitButton.setSizeConstraints(height: 60)
        submitButton.setTitle("Filter", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
    }
}
