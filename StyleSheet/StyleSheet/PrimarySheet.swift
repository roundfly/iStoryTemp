//
//  PrimarySheet.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 16.4.22..
//

import UIKit

/// Configures UI and behaviour of the UISheetPresentationController instance
/// - Parameter viewController: The view controller instance which is managed
/// by the presentation controller
public func primarySheet(for viewController: UIViewController) {
    guard let presentationController = viewController.presentationController as? UISheetPresentationController else {
        assertionFailure("UISheetPresentationController not supported for \(type(of: viewController))")
        return
    }
    presentationController.detents = [.medium(), .large()]
    presentationController.preferredCornerRadius = 20.0
    presentationController.prefersGrabberVisible = true
}
