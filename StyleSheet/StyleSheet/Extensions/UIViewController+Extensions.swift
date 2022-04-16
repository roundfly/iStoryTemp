//
//  UIViewController+Extensions.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit

public extension UIViewController {
    /// Adds a child view controller to the parent container
    /// - Parameter child: UIViewController instance which is to be added
    func add(_ child: UIViewController) {
        guard child.parent == nil else { return }
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Removes a child view controller from it's parent container
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
