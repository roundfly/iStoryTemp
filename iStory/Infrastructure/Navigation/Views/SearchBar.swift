//
//  SearchBar.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/7/22.
//

import Foundation
import UIKit

enum SearchBarType {
    case withFilterButton
    case fullWidth
}

protocol SearchBarDelegate: AnyObject {
    func didEnterSearch(query: String)
}

final class SearchBar: UIView {
    private var type: SearchBarType = .withFilterButton
    private let textField = UITextField()
    private let bottomLineView = UIView()
    private let filterButton = UIButton()
    var placeholder = "Search"
    weak var delegate: SearchBarDelegate?
    
    convenience init(type: SearchBarType, frame: CGRect) {
        self.init(frame: frame)
        self.type = type
        
        setupUI()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func perform(search: String) {
        textField.text = search
    }
    
    func removeSearchEntry() {
        textField.text?.removeAll()
        didEndSearch()
    }
    
    func didEndSearch() {
        textField.endEditing(true)
    }
    
    private func setupUI() {
        textField.delegate = self
        textField.textColor = .lightGray
        textField.text = placeholder

        switch type {
        case .withFilterButton:
            configureWithFilterButton()
        case .fullWidth:
            configureFullWidth()
        }
    }
    
    private func configureWithFilterButton() {
        addManagedSubview(textField)
        textField.setConstraintsRelativeToSuperView(top: 0, leading: 0, bottom: 1, trailing: 26)
        
        addManagedSubview(bottomLineView)
        bottomLineView.backgroundColor = .black.withAlphaComponent(0.5)
        bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor).activate()
        bottomLineView.setSizeConstraints(height: 1)
        bottomLineView.setConstraintsRelativeToSuperView(leading: 0, trailing: 26)
        
        addManagedSubview(filterButton)
        filterButton.setSizeConstraints(width: 25, height: 25)
        filterButton.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).activate()
        filterButton.setImage(UIImage(namedInStyleSheet: "search.filter"), for: .normal)
    }
    
    private func configureFullWidth() {
        addManagedSubview(textField)
        textField.setConstraintsRelativeToSuperView(top: 0, leading: 0, bottom: 1, trailing: 0)
        
        addManagedSubview(bottomLineView)
        bottomLineView.backgroundColor = .black.withAlphaComponent(0.5)
        bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor).activate()
        bottomLineView.setSizeConstraints(height: 1)
        bottomLineView.setConstraintsRelativeToSuperView(leading: 0, trailing: 0)
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        delegate?.didEnterSearch(query: text)
                
        if text.isEmpty {
            textField.text = placeholder
            textField.textColor = .lightGray
        } else if textField.text == placeholder {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        delegate?.didEnterSearch(query: text)
        
        if text.isEmpty {
            textField.text = placeholder
            textField.textColor = .lightGray
        }
    }
}
