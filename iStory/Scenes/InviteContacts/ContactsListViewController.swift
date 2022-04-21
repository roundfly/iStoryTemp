//
//  ContactsListViewController.swift
//  iStory
//
//  Created by Bratislav Baljak on 4/20/22.
//

import Foundation
import StyleSheet
import UIKit

final class ContactsListViewController: UIViewController {
    private let theme = ThemeDefault()
    
    private let backgroundView = UIView()
    private let popupView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private var contacts: [PhoneBookContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupUI()
    }
    
    func set(contacts: [PhoneBookContactModel]) {
        self.contacts = contacts
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.addManagedSubview(backgroundView)
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        backgroundView.addGestureRecognizer(closeTapGesture)
        backgroundView.setConstraintsEqualToSuperView()

        view.addManagedSubview(popupView)
        popupView.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        popupView.setHeightConstraint(equalToConstant: view.frame.height / 2)
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).activate()
        popupView.backgroundColor = .white.withAlphaComponent(0.9)
        popupView.layer.cornerRadius = 12
        popupView.clipsToBounds = true
        
        popupView.addManagedSubview(closeButton)
        closeButton.setConstraintsRelativeToSuperView(top: 20, trailing: 20)
        closeButton.setSizeConstraints(width: 20, height: 20)
        closeButton.setImage(UIImage(namedInStyleSheet: "close-button"), for: .normal)
        let closeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        closeButton.addGestureRecognizer(closeButtonTapGesture)

        popupView.addManagedSubview(titleLabel)
        titleLabel.setConstraintsRelativeToSuperView(top: 40, leading: 16, trailing: 16)
        titleLabel.textAlignment = .center
        titleLabel.font = theme.fontBold.withSize(22)
        titleLabel.text = "Friends on iStory"
        
        popupView.addManagedSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).activate()
        tableView.setConstraintsRelativeToSuperView(leading: 0, bottom: 0, trailing: 0)
        tableView.backgroundColor = .white.withAlphaComponent(0.9)
        tableView.register(ContactsTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(for: indexPath) as ContactsTableViewCell
        cell.config(using: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
