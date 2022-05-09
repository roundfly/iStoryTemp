//
//  SearchBar.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/7/22.
//

import Foundation
import UIKit

final class SearchBar: UIView {
    
    private let textField = UITextField()
    private let bottomLineView = UIView()
    private let filterButton = UIButton()
    var placeholder = "Search"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        textField.textColor = .lightGray
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textField.text = placeholder
        
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
    
    func didEndSearch() {
        textField.endEditing(true)
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        print("TEXT is \(text)")
        
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
        
        if text.isEmpty {
            textField.text = placeholder
            textField.textColor = .lightGray
        }
    }
}
