//
//  FilterByPeopleView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/13/22.
//

import Foundation
import UIKit
import StyleSheet

final class FilterByPeopleView: UIView {
    private let imageViewSize: CGFloat = 40
    
    private let titleLabel = UILabel()
    private let plusButton = UIButton()
    private var peopleImages: [UIImage] = []
    private var peopleImageViews: [UIImageView] = []
    private let moreButton = UIButton()
    
    private let theme = ThemeDefault()

    
    convenience init(peopleImages: [UIImage]) {
        self.init(frame: .zero)
        self.peopleImages = peopleImages
        
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
        titleLabel.setConstraintsRelativeToSuperView(top: 0, leading: 50, trailing: 50)
        titleLabel.font = theme.fontBold.withSize(16)
        titleLabel.text = "Filter by people or circle"
        
        addManagedSubview(plusButton)
        plusButton.setConstraintsRelativeToSuperView(leading: 50)
        plusButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).activate()
        plusButton.setSizeConstraints(width: 40, height: 40)
        plusButton.setImage(UIImage(namedInStyleSheet: "plus-button"), for: .normal)
        
        for (index, image) in peopleImages.enumerated() {
            configureImageView(for: image, at: index)
        }
        
        if peopleImages.count > 5 {
            configureMoreButton()
        }
    }
    
    private func configureImageView(for image: UIImage, at index: Int) {
        if index > 4 {
            print("You can add only 5 people")
            return
        }
        
        let imageView = UIImageView()
        imageView.tag = index
        addManagedSubview(imageView)
        peopleImageViews.append(imageView)
        imageView.image = image
        imageView.layer.cornerRadius = imageViewSize / 2
        imageView.setSizeConstraints(width: imageViewSize, height: imageViewSize)
        imageView.topAnchor.constraint(equalTo: plusButton.topAnchor).activate()

        if index == 0 {
            imageView.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 16).activate()
        } else {
            let previosImageView = peopleImageViews[index - 1]
            imageView.leadingAnchor.constraint(equalTo: previosImageView.trailingAnchor, constant: -18).activate()
        }
    }
    
    private func configureMoreButton() {
        addManagedSubview(moreButton)
        moreButton.setTitle("+ \(peopleImages.count - 5) more", for: .normal)
        moreButton.leadingAnchor.constraint(equalTo: peopleImageViews.last!.trailingAnchor, constant: 7).activate()
        moreButton.centerYAnchor.constraint(equalTo: peopleImageViews.last!.centerYAnchor).activate()
        moreButton.setSizeConstraints(width: 80, height: 17)
        moreButton.setTitleColor(AppColor.textFieldTextColor.uiColor, for: .normal)
        moreButton.titleLabel?.font = theme.fontRegular.withSize(16)
    }
}
