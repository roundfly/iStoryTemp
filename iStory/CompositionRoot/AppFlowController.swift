//
//  AppFlowController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 1.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AppFlowController: UIViewController {
    // MARK: - Instance variables

    private let navigation: UINavigationController
    private let authenticationFlow: AuthenticationFlowController
    private var timerCancellable: Cancellable?
    let dependencies: AppDependencies

    init(dependencies: AppDependencies = .init()) {
        let navigationController = UINavigationController()
        self.navigation = navigationController
        self.authenticationFlow = AuthenticationFlowController(navigation: navigationController, dependencies: dependencies)
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(window: UIWindow?) {
        window?.rootViewController = self
        window?.makeKeyAndVisible()
        navigation.pushViewController(SplashViewController(), animated: false)
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        finishSplash()
    }

    // MARK: - Subview setup

    private func setupNavigationController() {
        add(navigation)
    }

    // MARK: - Implementation details

    private func finishSplash() {
        let now: Date = .now
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerCancellable = timer
            .sink { [navigation, authenticationFlow] date in
                if date.timeIntervalSince(now) > 1 {
                    timer.upstream.connect().cancel()
                    navigation.setViewControllers([authenticationFlow], animated: true)
                }
            }
    }
}
