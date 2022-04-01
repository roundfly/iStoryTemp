//
//  AppFlowController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit
import StyleSheet

final class AppFlowController: UIViewController {
    // MARK: - Instance variables

    private let navigation = UINavigationController()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }

    // MARK: - Subview setup

    private func setupNavigationController() {
        add(navigation)
    }

    
}
