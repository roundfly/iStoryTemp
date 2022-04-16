//
//  AccessCodeViewController.swift
//  iStory
//
//  Created by Shyft on 4/5/22.
//

import Foundation
import UIKit

final class SMSAccessCodeViewController: UIViewController {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    private let passwordTextFields = [UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField()]
    private let submitButton = SubmitButton()
    
    private let upperLabel = UILabel()
    private let midLabel = UILabel()
    private let lowerLabel = UILabel()
    
    private var receiver: String = ""
    
    init(receiver: String) {
        super.init(nibName: nil, bundle: nil)
        self.receiver = receiver
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAuthenticationStyle(to: view)
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI() {
        let smallOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 20 : 40
        let bigOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 25 : 45
        let titleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 30 : 40
        let subtitleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 15 : 20
        let buttonSize: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 44 : 60

        view.addManagedSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: titleFont)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        titleLabel.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        titleLabel.text = "Enter your access code"
        titleLabel.textAlignment = .center
        
        view.addManagedSubview(subtitleLabel)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = .systemFont(ofSize: subtitleFont)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).activate()
        subtitleLabel.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        subtitleLabel.text = "We have sent the access code to: \n\(receiver)"
        subtitleLabel.textAlignment = .center
        
        view.addManagedSubview(stackView)
        stackView.axis = .horizontal
        stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: smallOffset).activate()
        stackView.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        stackView.setHeightConstraint(equalToConstant: 55)
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        passwordTextFields.forEach { textField in
            stackView.addArrangedSubview(textField)
            textField.textContentType = .oneTimeCode
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 13
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        
        view.addManagedSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: smallOffset).activate()
        submitButton.setConstraintsRelativeToSuperView(leading: 8, trailing: 8)
        submitButton.setHeightConstraint(equalToConstant: buttonSize)
        submitButton.titleText = "Submit code"
        submitButton.textColor = .black

        view.addManagedSubview(lowerLabel)
        lowerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).activate()
        lowerLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        lowerLabel.numberOfLines = 0
        lowerLabel.text = "Skip and check the app. \nOr go Back? \nAlready have account LogIn!"
        lowerLabel.textAlignment = .center
        lowerLabel.font = .systemFont(ofSize: 12)
        
        view.addManagedSubview(midLabel)
        midLabel.bottomAnchor.constraint(equalTo: lowerLabel.topAnchor, constant: -40).activate()
        midLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        midLabel.numberOfLines = 0
        midLabel.text = "Didn’t receive a code? Resend"
        midLabel.textAlignment = .center
        midLabel.font = .systemFont(ofSize: 14)
        
        view.addManagedSubview(upperLabel)
        upperLabel.bottomAnchor.constraint(equalTo: midLabel.topAnchor, constant: -bigOffset).activate()
        upperLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        upperLabel.numberOfLines = 0
        upperLabel.text = "This code will expire in 5 minutes. iStory may use your phone number to  send emails to your account."
        upperLabel.textAlignment = .center
        upperLabel.font = .systemFont(ofSize: 16)
    }
}

extension SMSAccessCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            textField.text = string
            for (index, passwordTextField) in passwordTextFields.enumerated() {
                if textField == passwordTextFields.last {
                    passwordTextFields.last?.resignFirstResponder()
                    break
                } else if textField == passwordTextField {
                    passwordTextFields[index + 1].becomeFirstResponder()
                }
            }
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
}
