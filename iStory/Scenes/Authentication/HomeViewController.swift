//
//  HomeViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import UIKit

final class HomeViewController: UIViewController {

    let store: AuthenticationStore

    init(store: AuthenticationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = """
        iStory user: \(store.state.currentUser?.email ?? "")
        JWT: \(store.state.accessToken?.accessToken ?? "nil")
        """
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        view.backgroundColor = .white
        label.frame = view.bounds
        view.addSubview(label)
    }
}
