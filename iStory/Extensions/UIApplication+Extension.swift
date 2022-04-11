//
//  UIApplication+Extension.swift
//  iStory
//
//  Created by Shyft on 4/11/22.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
    }
}
