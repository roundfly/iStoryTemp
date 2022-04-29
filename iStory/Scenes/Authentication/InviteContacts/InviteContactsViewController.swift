//
//  InviteContactsViewController.swift
//  iStory
//
//  Created by Bratislav Baljak on 4/20/22.
//

import Foundation
import UIKit
import SwiftUI

final class InviteContactsViewController: UIViewController {
    private let contactsService = ContactsService()
    
    //MARK: UI
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let importFromPhoneBookOption = UILabel()
    private let submitButton = SubmitButton()
    private let skipButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAuthenticationStyle(to: view)
        setupUI()
        contactsService.whenGrantedAction = {
            let vc = ContactsListViewController()
            let contacts = self.contactsService.getContacts()
            vc.set(contacts: contacts)
            self.present(vc, animated: true)
        }
    }
    
    private func setupUI() {
        view.addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        titleLabel.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        titleLabel.textAlignment = .center
        titleLabel.text = "Import Contacts"
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 48)
        
        view.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 55).activate()
        subtitleLabel.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus justo elit."
        subtitleLabel.numberOfLines = 3
        subtitleLabel.font = .systemFont(ofSize: 20)

        view.addManagedSubview(importFromPhoneBookOption)
        importFromPhoneBookOption.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 42).activate()
        importFromPhoneBookOption.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        importFromPhoneBookOption.text = "Import from your phone book"
        
        let checkmarkView = UIImageView()
        checkmarkView.image = UIImage(namedInStyleSheet: "checkmark")
        importFromPhoneBookOption.addManagedSubview(checkmarkView)
        checkmarkView.trailingAnchor.constraint(equalTo: importFromPhoneBookOption.trailingAnchor).activate()
        checkmarkView.centerYAnchor.constraint(equalTo: importFromPhoneBookOption.centerYAnchor).activate()
        checkmarkView.setSizeConstraints(width: 15, height: 10)
        
        view.addManagedSubview(submitButton)
        submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).activate()
        submitButton.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        submitButton.setHeightConstraint(equalToConstant: 44)
        submitButton.titleText = "Next"
        submitButton.titleLabel?.font = .systemFont(ofSize: 20)
        submitButton.textColor = .black
        let action = UIAction { [weak self] handler in
            guard let self = self else { return }
            if self.contactsService.isPermissionGranted() {
                self.contactsService.whenGrantedAction?()
            } else {
                self.contactsService.determineActionWhenAccessIsNotGranted()
            }
        }
        submitButton.addAction(action, for: .touchUpInside)
        
        view.addManagedSubview(skipButton)
        skipButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 66).activate()
        skipButton.setSizeConstraints(width: 40, height: 30)
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 12)
        skipButton.setTitleColor(.black, for: .normal)
    }
}
