//
//  LoginWithSMSViewController.swift
//  iStory
//
//  Created by Shyft on 4/2/22.
//

import Foundation
import UIKit
import StyleSheet

final class LoginWithSMSViewController: UIViewController {
    // MARK: DI
    private let phoneNumberService = PhoneNumberService()
    
    // MARK: UI Elements
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let phoneNumberTextFieldTitleLabel = UILabel()
    private var phoneNumberTextField: UITextField!
    private let submitButton = UIButton()
    private let errorMessageLabel = UILabel()
    private let skipButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAuthenticationStyle(to: view)
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI() {
        let smallOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 16 : 26
        let bigOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 45 : 90
        let titleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 30 : 48
        let subtitleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 15 : 20

        view.addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        titleLabel.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        titleLabel.font = .systemFont(ofSize: titleFont)
        titleLabel.text = "Welcome \nback"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        view.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallOffset).activate()
        subtitleLabel.setConstraintsRelativeToSuperView(leading: 24, trailing: 24)
        subtitleLabel.font = .systemFont(ofSize: subtitleFont)
        subtitleLabel.text = "Enter your phone number \nto receive verification code"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center

        view.addManagedSubview(phoneNumberTextFieldTitleLabel)
        phoneNumberTextFieldTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: bigOffset).activate()
        phoneNumberTextFieldTitleLabel.setConstraintsRelativeToSuperView(leading: 18, trailing: 18)
        phoneNumberTextFieldTitleLabel.font = .systemFont(ofSize: 15)
        phoneNumberTextFieldTitleLabel.text = "Mobile number"
        
        phoneNumberTextField = phoneNumberService.createPhoneNumberTextField()
        view.addManagedSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberTextFieldTitleLabel.bottomAnchor, constant: smallOffset).activate()
        phoneNumberTextField.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        phoneNumberTextField.setHeightConstraint(equalToConstant: 44)
        phoneNumberTextField.layer.cornerRadius = 13
        phoneNumberTextField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        view.addManagedSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: smallOffset).activate()
        submitButton.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        submitButton.setHeightConstraint(equalToConstant: 44)
        submitButton.layer.cornerRadius = 13
        submitButton.setTitle("Get code", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.backgroundColor = AppColor.blue.uiColor
        
        view.addManagedSubview(errorMessageLabel)
        errorMessageLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: bigOffset).activate()
        errorMessageLabel.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        errorMessageLabel.font = .systemFont(ofSize: 17)
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.text = "Please confirm your country code and enter your phone number"
        errorMessageLabel.textAlignment = .center
        
        //TODO: Extract to separate Views, maybe apply atomic design. Add last bottom label. Implement invalid state for screen. Commit. New Jira ticket.
    }
}
