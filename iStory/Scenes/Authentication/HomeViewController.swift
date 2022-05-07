//
//  HomeViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import UIKit
import StyleSheet

final class HomeViewController: UIViewController {

    private let store: AuthenticationStore
    private let theme = ThemeDefault()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bellImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchBar = SearchBar()

    init(store: AuthenticationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logJwtToken()
        setupScrollView()
        setupUI()
    }
    
    private func setupScrollView() {
        view.backgroundColor = .white
        view.addManagedSubview(scrollView)
        scrollView.setConstraintsEqualToSuperView()
                
        scrollView.addManagedSubview(contentView)
        contentView.setConstraintsEqualToSuperView()

        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didEndSearch))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didEndSearch() {
        searchBar.didEndSearch()
    }
    
    private func setupUI() {
        contentView.addManagedSubview(bellImageView)
        bellImageView.setConstraintsRelativeToSuperView(top: 20, leading: 27)
        bellImageView.setSizeConstraints(width: 25, height: 25)
        bellImageView.contentMode = .scaleAspectFit
        bellImageView.image = UIImage(namedInStyleSheet: "bell")
        
        contentView.addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: bellImageView.bottomAnchor, constant: 11).activate()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).activate()
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 26).activate()
        titleLabel.font = theme.fontBold.withSize(26)
        titleLabel.text = "Hello"
        
        contentView.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).activate()
        subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).activate()
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 26).activate()
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = theme.fontBold.withSize(18)
        subtitleLabel.textColor = AppColor.textFieldTextColor.uiColor
        subtitleLabel.text = "Let’s Explore activities \nof your friends"
        
        contentView.addManagedSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25).activate()
        searchBar.setConstraintsRelativeToSuperView(leading: 26, trailing: 26)
        searchBar.setHeightConstraint(equalToConstant: 30)
        
        let collectionViewDummyExample = UIView()
        contentView.addManagedSubview(collectionViewDummyExample)
        collectionViewDummyExample.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50).activate()
        collectionViewDummyExample.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).activate()
        collectionViewDummyExample.setConstraintsRelativeToSuperView(leading: 0, bottom: 0, trailing: 0)
        collectionViewDummyExample.setSizeConstraints(height: 1600)
        collectionViewDummyExample.backgroundColor = .systemGray
    }
    
    private func logJwtToken() {
        let jwtToken = """
        iStory user: \(store.state.currentUser?.email ?? "")
        JWT: \(store.state.accessToken?.accessToken ?? "nil")
        """
        print(jwtToken)
    }
}
