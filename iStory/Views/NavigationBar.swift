//
//  NavigationBar.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/10/22.
//

import Foundation
import UIKit

enum NavigationBarType {
    case empty
    case feed
}

final class NavigationBar: UIView {
    
    private var type: NavigationBarType = .empty
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var searchBar = SearchBar(type: .fullWidth, frame: .zero)
    private var searchBarHeightAnchor: NSLayoutConstraint?
    
    var isRightButtonHidden: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.rightButton.alpha = self.isRightButtonHidden ? 0 : 1
            }
        }
    }
    
    var isSearchBarHidden: Bool = true {
        didSet {
            self.searchBarHeightAnchor?.constant = self.isSearchBarHidden ? 0 : 30
            self.searchBar.layoutIfNeeded()
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(type: NavigationBarType, frame: CGRect) {
        self.init(frame: frame)
        self.type = type
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        switch type {
        case .empty:
            break
        case .feed:
            configureFeedNavigationBar()
        }
    }
    
    private func configureFeedNavigationBar() {
        addManagedSubview(leftButton)
        leftButton.setConstraintsRelativeToSuperView(top: 5, leading: 27)
        leftButton.setSizeConstraints(width: 25, height: 25)
        leftButton.setImage(UIImage(namedInStyleSheet: "bell"), for: .normal)
        
        addManagedSubview(rightButton)
        rightButton.setConstraintsRelativeToSuperView(top: 5, trailing: 32)
        rightButton.setSizeConstraints(width: 25, height: 25)
        rightButton.setImage(UIImage(namedInStyleSheet: "search.filter"), for: .normal)
        rightButton.alpha = 0
        
        addManagedSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 5).activate()
        searchBar.setConstraintsRelativeToSuperView(leading: 27, bottom: 10, trailing: 32)
        searchBarHeightAnchor = searchBar.heightAnchor.constraint(equalToConstant: 30).activate()
        searchBar.clipsToBounds = true
    }
}
