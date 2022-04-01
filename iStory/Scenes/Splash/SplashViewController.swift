//
//  SplashViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import UIKit
import StyleSheet

final class SplashViewController: UIViewController {

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.yellow.uiColor
        setupImageView()
        setupAssetImageViews()
    }

    // MARK: - Subview setup

    private func setupImageView() {
        let imageView = UIImageView()
        view.addManagedSubview(imageView)
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFill
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).activate()
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).activate()
    }

    private func setupAssetImageViews() {
        let topAsset = UIImageView(), bottomAsset = UIImageView()
        topAsset.image = UIImage(namedInStyleSheet: "green 1")
        bottomAsset.image = UIImage(namedInStyleSheet: "yellow 1")
        [topAsset, bottomAsset].forEach(view.addManagedSubview(_:))
        topAsset.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        topAsset.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).activate()
        topAsset.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).activate()

        bottomAsset.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        bottomAsset.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        bottomAsset.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        bottomAsset.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).activate()
    }
}
