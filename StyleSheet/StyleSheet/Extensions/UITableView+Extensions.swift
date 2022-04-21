//
//  UITableView+Extensions.swift
//  StyleSheet
//
//  Created by Bratislav Baljak on 4/20/22.
//

import Foundation
import UIKit

public extension UITableView {
    func register<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: Cell.self))
    }

    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell else {
            fatalError()
        }
        return cell
    }
}
