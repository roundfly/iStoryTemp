//
//  FilterFlowController.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/21/22.
//

import Foundation
import UIKit

final class FilterFlowController: UIViewController {
    private let navigation: UINavigationController?
    
    init(navigation: UINavigationController? = nil) {
        self.navigation = navigation
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
