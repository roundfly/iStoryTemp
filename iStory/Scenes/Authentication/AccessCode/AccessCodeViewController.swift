//
//  AccessCodeViewController.swift
//  iStory
//
//  Created by Shyft on 4/5/22.
//

import Foundation
import UIKit
import Combine
import StyleSheet

final class AccessCodeViewController: UIViewController {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    private let accessCodeTextFields = [UITextField(), UITextField(), UITextField(), UITextField(), UITextField(), UITextField()]
    private let submitButton = SubmitButton()
    private let upperLabel = UILabel()
    private let midLabel = UILabel()
    private let lowerLabel = UILabel()
    private let viewModel: AccessCodeViewModel
    var accessCodeCompletePublisher: AnyPublisher<Void, Never> {
        accessCodeCompleteSubject.eraseToAnyPublisher()
    }
    private let accessCodeCompleteSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AccessCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.store.$state
            .dropFirst()
            .sink { [weak self] authState in
                if let error = authState.accessCodeFailure {
                    // show error
                } else if authState.currentUser?.didSubmitValidAccessCodeInSession == true {
                    self?.accessCodeCompleteSubject.send()
                }
            }.store(in: &cancellables)
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
        let buttonSize: CGFloat = 44

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
        subtitleLabel.attributedText = "We have sent the access code to: \n\(viewModel.receiver)".bolded(text: "We have sent the access code to", font: .systemFont(ofSize: subtitleFont))
        subtitleLabel.textAlignment = .center
        
        view.addManagedSubview(stackView)
        stackView.axis = .horizontal
        stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: smallOffset).activate()
        stackView.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        stackView.setHeightConstraint(equalToConstant: 55)
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        accessCodeTextFields.forEach { textField in
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
        let action = UIAction { [weak self] action in
            self?.viewModel.submitCode()
        }
        submitButton.addAction(action, for: .touchUpInside)

        view.addManagedSubview(lowerLabel)
        lowerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).activate()
        lowerLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        lowerLabel.numberOfLines = 0
        lowerLabel.font = .systemFont(ofSize: 12)
        lowerLabel.attributedText = "Skip and check the app. \nAlready have account LogIn!".bolded(text: "Skip", font: .systemFont(ofSize: 12))
        lowerLabel.textAlignment = .center
        
        view.addManagedSubview(midLabel)
        midLabel.bottomAnchor.constraint(equalTo: lowerLabel.topAnchor, constant: -40).activate()
        midLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        midLabel.numberOfLines = 0
        midLabel.font = .systemFont(ofSize: 14)
        midLabel.attributedText = "Didn’t receive a code? Resend".bolded(text: "Resend", font: .systemFont(ofSize: 14))
        midLabel.textAlignment = .center
        
        view.addManagedSubview(upperLabel)
        upperLabel.bottomAnchor.constraint(equalTo: midLabel.topAnchor, constant: -bigOffset).activate()
        upperLabel.setConstraintsRelativeToSuperView(leading: 20, trailing: 20)
        upperLabel.numberOfLines = 0
        upperLabel.font = .systemFont(ofSize: 16)
        upperLabel.attributedText = "This code will expire in 5 minutes.\niStory may use your phone number to  send emails to your account."
            .bolded(text: "This code will expire in 5 minutes.", font: .systemFont(ofSize: 16))
        upperLabel.textAlignment = .center
    }
}

extension AccessCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            textField.text = string
            for (index, accessCodeTextField) in accessCodeTextFields.enumerated() {
                if textField == accessCodeTextFields.last {
                    accessCodeTextFields.last?.resignFirstResponder()
                    break
                } else if textField == accessCodeTextField {
                    accessCodeTextFields[index + 1].becomeFirstResponder()
                }
            }
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.consumeAccessCode(from: accessCodeTextFields)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
}
