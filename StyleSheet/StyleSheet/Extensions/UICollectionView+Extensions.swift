//
//  UICollectionView+Extensions.swift
//  StyleSheet
//
//  Created by Nikola Stojanovic on 7.5.22..
//

import UIKit

public extension UICollectionView {
    func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: Cell.self))
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as? Cell else {
            fatalError()
        }
        return cell
    }
}
