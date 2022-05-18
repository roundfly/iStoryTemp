//
//  DateView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/17/22.
//

import Foundation
import UIKit

enum DateFilterType {
    case from
    case to
}

final class DateView: UIView {
    private var type: DateFilterType = .from
    private let squaredContentView = UIView()
    
    convenience init(type: DateFilterType) {
        self.init(frame: .zero)
        self.type = type
        
        setupUI()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addManagedSubview(squaredContentView)
        
    }
    
}
