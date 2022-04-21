//
//  LoginWithEmailViewController.swift
//  iStory
//
//  Created by Shyft on 4/8/22.
//

import Foundation
import UIKit

final class LoginWithEmailViewController: UIViewController {
    private var viewModel: LoginWithEmailViewModel {
        didSet {
            updateUI()
        }
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var emailTextField = UITextField()
    private let submitButton = SubmitButton()
    private let errorMessageLabel = UILabel()
    private let skipButton = UIButton()
    private var router: LoginWithEmailRoutingLogic!
    
    init(viewModel: LoginWithEmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        router = LoginWithEmailRouter(controller: self)
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
        submitButton.isEnabled = viewModel.viewState == .normal
    }
    
    private func setupUI() {
        let smallOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 16 : 26
        let bigOffset: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 45 : 90
        let titleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 30 : 48
        let subtitleFont: CGFloat = UIScreen.main.getDeviceSize().isSmallOrLess ? 15 : 20
        let buttonSize: CGFloat = 44 

        view.addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        titleLabel.setConstraintsRelativeToSuperView(leading: 32, trailing: 32)
        titleLabel.font = .systemFont(ofSize: titleFont)
        titleLabel.text = "Request Code"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        view.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallOffset).activate()
        subtitleLabel.setConstraintsRelativeToSuperView(leading: 24, trailing: 24)
        subtitleLabel.font = .systemFont(ofSize: subtitleFont)
        subtitleLabel.text = "Enter your email to get one time access code."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        view.addManagedSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50).activate()
        emailTextField.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        emailTextField.setHeightConstraint(equalToConstant: 44)
        emailTextField.layer.cornerRadius = 13
        emailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        emailTextField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        
        view.addManagedSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: smallOffset).activate()
        submitButton.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        submitButton.setHeightConstraint(equalToConstant: buttonSize)
        submitButton.titleText = "Get code"
        submitButton.textColor = .black
        submitButton.isEnabled = viewModel.viewState == .normal
        let action = UIAction { [weak self] handler in
            let email = self?.emailTextField.text ?? ""
            self?.router.email = email
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
        skipButton.setTitle("Skip or go Back? No account? Create one!", for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.titleLabel?.font = .systemFont(ofSize: 12)
    }
    
    @objc
    func onTextChange() {
        guard let email = emailTextField.text, !email.isEmpty else {
            viewModel.viewState = .error
            return
        }
        
        let isValid = viewModel.validator.isValid(email)
        viewModel.viewState = isValid ? .normal : .error
    }
}
