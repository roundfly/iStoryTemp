//
//  ContactsTableViewCell.swift
//  iStory
//
//  Created by Bratislav Baljak on 4/20/22.
//

import Foundation
import UIKit
import StyleSheet

final class ContactsTableViewCell: UITableViewCell {
    private let theme = ThemeDefault()

    private let personImageView = UIImageView()
    private let personTitleLabel = UILabel()
    private let personSubtitleLabel = UILabel()
    private let followButton = SubmitButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(using model: PhoneBookContactModel) {
        personTitleLabel.text = model.firstName + " " + model.lastName
    }
    
    private func setupUI() {
        addManagedSubview(personImageView)
        personImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        personImageView.setSizeConstraints(width: 45, height: 45)
        personImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).activate()
        personImageView.image = UIImage(namedInStyleSheet: "person.circle")
        
        addManagedSubview(personTitleLabel)
        personTitleLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).activate()
        personTitleLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15).activate()
        personTitleLabel.font = theme.fontMedium.withSize(14)
        
        addManagedSubview(personSubtitleLabel)
        personSubtitleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).activate()
        personSubtitleLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15).activate()
        personSubtitleLabel.font = theme.fontMedium.withSize(12)
        personSubtitleLabel.text = "From your contacts"

        addManagedSubview(followButton)
        followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21).activate()
        followButton.setSizeConstraints(width: 90, height: 25)
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        followButton.titleText = "Follow"
        followButton.textColor = .black
        followButton.titleLabel?.font = theme.fontMedium.withSize(14)
        followButton.isEnabled = true
    }
}
