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
    private var viewModel: LoginWithSMSViewModel {
        didSet {
            updateUI()
        }
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let phoneNumberTextFieldTitleLabel = UILabel()
    private var phoneNumberTextField: UITextField!
    private let submitButton = SubmitButton()
    private let errorMessageLabel = UILabel()
    private let skipButton = UIButton()
    private var router: LoginWithSMSRoutingLogic!
    
    init(viewModel: LoginWithSMSViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        router = LoginWithSMSRouter(controller: self)
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
    
    private func updateUI() {
        errorMessageLabel.text = viewModel.viewState == .normal ? viewModel.normalStateErrorMessage : viewModel.errorStateErrorMessage
        submitButton.isEnabled = viewModel.viewState == .normal
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
        
        phoneNumberTextField = viewModel.dependency.createPhoneNumberTextField()
        view.addManagedSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberTextFieldTitleLabel.bottomAnchor, constant: smallOffset).activate()
        phoneNumberTextField.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        phoneNumberTextField.setHeightConstraint(equalToConstant: 44)
        phoneNumberTextField.layer.cornerRadius = 13
        phoneNumberTextField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        phoneNumberTextField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        
        view.addManagedSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: smallOffset).activate()
        submitButton.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        submitButton.setHeightConstraint(equalToConstant: 44)
        submitButton.titleText = "Get code"
        submitButton.textColor = .black
        submitButton.isEnabled = viewModel.viewState == .normal
        let action = UIAction { [weak self] handler in
            let number = self?.phoneNumberTextField.text ?? ""
            self?.router.number = number
            self?.router.showAccessCodeScreen()
        }
        submitButton.addAction(action, for: .touchUpInside)
        
        view.addManagedSubview(errorMessageLabel)
        errorMessageLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: bigOffset).activate()
        errorMessageLabel.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        errorMessageLabel.font = .systemFont(ofSize: 17)
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        
        view.addManagedSubview(skipButton)
        skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).activate()
        skipButton.setConstraintsRelativeToSuperView(leading: 8, trailing: 8)
        skipButton.setTitle("Skip and check the app? No account? Create one!", for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.titleLabel?.font = .systemFont(ofSize: 12)
    }
    
    @objc
    func onTextChange() {
        guard let phone = phoneNumberTextField.text, !phone.isEmpty else {
            viewModel.viewState = .error
            return
        }
        
        let isValid = viewModel.dependency.isValidPhone(number: phone)
        viewModel.viewState = isValid ? .normal : .error
    }
}
