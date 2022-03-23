//
//  ViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 18.3.22..
//

import StyleSheet
import UIKit

class TestViewController: UIViewController {
    
    private let theme = ThemeDefault()
    
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme.colorGreen
        label.font = theme.fontBold
        label.font = theme.fontBlack
    }
}
