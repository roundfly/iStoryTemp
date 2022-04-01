//
//  LoginWithSMSViewController.swift
//  iStory
//
//  Created by Shyft on 4/2/22.
//

import Foundation
import UIKit

final class LoginWithSMSViewController: UIViewController {
    private let phoneNumberService = PhoneNumberService()
    
    private var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        setupUI()
    }
    
    private func setupUI() {
        phoneNumberTextField = phoneNumberService.createPhoneNumberTextField()
        phoneNumberTextField.delegate = self
        view.addManagedSubview(phoneNumberTextField)
        phoneNumberTextField.setConstraintsRelativeToSuperView(top: 300, leading: 16, trailing: 16)
        phoneNumberTextField.setHeightConstraint(equalToConstant: 65)
        phoneNumberTextField.layer.cornerRadius = 13
        phoneNumberTextField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
}

extension LoginWithSMSViewController: UITextFieldDelegate {
    
}
