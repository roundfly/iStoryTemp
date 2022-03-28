//
//  AmazonViewController.swift
//  iStory
//
//  Created by Shyft on 3/25/22.
//

import Foundation
import UIKit
import StyleSheet

final class AmazonViewController: UIViewController {
    private let amazonButton = UIButton()
    private let service = AmazonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addManagedSubview(amazonButton)
        amazonButton.backgroundColor = .blue
        amazonButton.setTitle("Login Amazon", for: .normal)
        amazonButton.setConstraintsRelativeToSuperView(leading: 16, trailing: 16)
        amazonButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).activate()
        amazonButton.setHeightConstraint(equalToConstant: 36)
        
        let action = UIAction { [weak self] _ in
            self?.service.openAuthorizeRequest()
        }
        amazonButton.addAction(action, for: .touchUpInside)
    }
}
