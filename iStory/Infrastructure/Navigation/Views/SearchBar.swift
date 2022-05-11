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
    private var filterButton: UIButton?
    private let magnifierImageView = UIImageView()
    
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
        
    func update(search: String) {
        guard let text = textField.text else {
            return
        }
        
        if search == text {
            return
        }
        
        if search == placeholder {
            return
        }
        
        textField.text = search
        applyStyle(for: search)
    }
    
    func removeSearchEntry() {
        textField.text?.removeAll()
        applyStyle(for: "")
        didEndSearch()
    }
    
    func didEndSearch() {
        textField.endEditing(true)
    }
    
    private func setupUI() {
        textField.delegate = self
        textField.textColor = .lightGray
        textField.text = placeholder
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

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
        
        filterButton = UIButton()
        addManagedSubview(filterButton!)
        filterButton!.setSizeConstraints(width: 25, height: 25)
        filterButton!.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        filterButton!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).activate()
        filterButton!.setImage(UIImage(namedInStyleSheet: "search.filter"), for: .normal)
        
        addManagedSubview(magnifierImageView)
        magnifierImageView.setSizeConstraints(width: 25, height: 25)
        magnifierImageView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        magnifierImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).activate()
        magnifierImageView.image = UIImage(namedInStyleSheet: "search.magnifier")
        magnifierImageView.alpha = 0
    }
    
    private func configureFullWidth() {
        addManagedSubview(textField)
        textField.setConstraintsRelativeToSuperView(top: 0, leading: 0, bottom: 1, trailing: 0)
        
        addManagedSubview(bottomLineView)
        bottomLineView.backgroundColor = .black.withAlphaComponent(0.5)
        bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor).activate()
        bottomLineView.setSizeConstraints(height: 1)
        bottomLineView.setConstraintsRelativeToSuperView(leading: 0, trailing: 0)
        
        addManagedSubview(magnifierImageView)
        magnifierImageView.setSizeConstraints(width: 25, height: 25)
        magnifierImageView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        magnifierImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).activate()
        magnifierImageView.image = UIImage(namedInStyleSheet: "search.magnifier")
        magnifierImageView.alpha = 0
    }
    
    private func applyStyle(for text: String) {
        setMagnifierfImageView(visible: !text.isEmpty)
        
        if text.isEmpty {
            textField.text = placeholder
            textField.textColor = .lightGray
        } else if textField.text == placeholder {
            textField.text = ""
            textField.textColor = .black
        } else {
            textField.textColor = .black
        }
    }
    
    private func setMagnifierfImageView(visible: Bool) {        
        magnifierImageView.alpha = visible ? 1 : 0
        filterButton?.alpha = visible ? 0 : 1
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        delegate?.didEnterSearch(query: text)
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        applyStyle(for: text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        applyStyle(for: text)
    }
}
