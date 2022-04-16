//
//  UIButton+Extensions.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Combine
import UIKit

public extension UIButton {
    convenience init<Output>(configuration: UIButton.Configuration = .filled(), output: Output, publisher: PassthroughSubject<Output, Never>) {
        self.init(configuration: configuration, primaryAction: UIAction { [weak publisher] _ in
            publisher?.send(output)
        })
    }

    convenience init(configuration: UIButton.Configuration = .filled(), publisher: PassthroughSubject<Void, Never>) {
        self.init(configuration: configuration, primaryAction: UIAction { [weak publisher] _ in
            publisher?.send(())
        })
    }

}
