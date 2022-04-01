//
//  AuthenticationStyle.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import StyleSheet

func applyAuthenticationStyle(to view: UIView) {
    view.backgroundColor = AppColor.yellow.uiColor
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    view.addManagedSubview(imageView)
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).activate()
    imageView.image = UIImage(namedInStyleSheet: "onboarding-background")
}
