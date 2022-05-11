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

protocol NavigationBarDelegate: AnyObject {
    func didEnterNavigationSearch(query: String)
}

final class NavigationBar: UIView {
    
    private var type: NavigationBarType = .empty
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private let searchBar = SearchBar(type: .fullWidth, frame: .zero)
    private var searchBarHeightAnchor: NSLayoutConstraint?
    weak var delegate: NavigationBarDelegate?
    
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
    
    func updateSearchBar(with query: String) {
        searchBar.update(search: query)
    }
    
    func didEndSearch() {
        searchBar.didEndSearch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        searchBar.delegate = self
        
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

extension NavigationBar: SearchBarDelegate {    
    func didEnterSearch(query: String) {
        delegate?.didEnterNavigationSearch(query: query)
    }
}
