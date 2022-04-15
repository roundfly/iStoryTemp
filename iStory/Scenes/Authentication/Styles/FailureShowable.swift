//
//  FailureShowable.swift
//  iStory
//
//  Created by Nikola Stojanovic on 11.4.22..
//

import UIKit

protocol FailureShowable: UIViewController {
    var errorLabel: UILabel { get set }
    var authInputView: AuthenticationInputView! { get set }
}

extension FailureShowable {
    func show(failureReason: String) {
        errorLabel.text = failureReason
        guard errorLabel.superview == nil else { return }
        errorLabel.alpha = 0.0
        errorLabel.font = .preferredFont(forTextStyle: .body)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        view.addManagedSubview(errorLabel)
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        errorLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        errorLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        errorLabel.topAnchor.constraint(equalTo: authInputView.bottomAnchor, constant: 40).activate()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.errorLabel.alpha = 1.0
        })
    }

    func hideFailureLabel() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.errorLabel.alpha = 0.0
        }) { position in
            if position == .end {
                self.errorLabel.removeFromSuperview()
            }
        }
    }
}
