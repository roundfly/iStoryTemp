//
//  AddPeopleFilterViewController.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/21/22.
//

import Foundation
import UIKit

final class AddPeopleFilterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.backgroundColor = .white
        
        let title = UILabel()
        view.addManagedSubview(title)
        title.setConstraintsRelativeToSuperView(top: 50, leading: 10, bottom: 60, trailing: 10)
        title.textAlignment = .center
        title.text = "Add more people to filter view"
    }
}
