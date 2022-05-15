//
//  UIView+Extensions.swift
//  StyleSheet
//
//  Created by Shyft on 3/26/22.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}

public extension UIView {

    @discardableResult
    func setConstraintsEqualToSuperView() -> ConstraintGroup? {
        setConstraintsRelativeToSuperView(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    @discardableResult
    func setConstraintsRelativeToSuperView(top: CGFloat? = nil,
                                           leading: CGFloat? = nil,
                                           bottom: CGFloat? = nil,
                                           trailing: CGFloat? = nil) -> ConstraintGroup? {

        translatesAutoresizingMaskIntoConstraints = false
        guard let sv = superview else { return nil }
        var cg = ConstraintGroup()
        cg.leading = leading.map { leadingAnchor.constraint(equalTo: sv.leadingAnchor, constant: $0) }
        cg.trailing = trailing.map { trailingAnchor.constraint(equalTo: sv.trailingAnchor, constant: -$0) }
        cg.top = top.map { topAnchor.constraint(equalTo: sv.topAnchor, constant: $0) }
        cg.bottom = bottom.map { bottomAnchor.constraint(equalTo: sv.bottomAnchor, constant: -$0) }
        cg.activate()
        return cg
    }

    @discardableResult
    func setSizeConstraints(width: CGFloat? = nil, height: CGFloat? = nil) -> ConstraintGroup? {
        var cg = ConstraintGroup()
        cg.width = width.map { setWidthConstraint(equalToConstant: $0) }
        cg.height = height.map { setHeightConstraint(equalToConstant: $0) }
        cg.activate()
        return cg
    }

    @discardableResult
    func setWidthConstraint(equalTo otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        let c = widthAnchor.constraint(equalTo: otherView.widthAnchor, constant: constant)
        c.activate()
        return c
    }

    @discardableResult
    func setWidthConstraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        let c = widthAnchor.constraint(equalToConstant: constant)
        c.activate()
        return c
    }

    @discardableResult
    func setHeightConstraint(equalTo otherView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        let c = heightAnchor.constraint(equalTo: otherView.heightAnchor, constant: constant)
        c.activate()
        return c
    }

    @discardableResult
    func setHeightConstraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        let c = heightAnchor.constraint(equalToConstant: constant)
        c.activate()
        return c
    }

    @discardableResult
    func setCenterXConstraint(equalTo otherView: UIView? = nil) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        guard let other = otherView ?? superview else { fatalError("Missing otherView or superview") }
        let c = centerXAnchor.constraint(equalTo: other.centerXAnchor)
        c.activate()
        return c
    }

    @discardableResult
    func setCenterYConstraint(equalTo otherView: UIView? = nil) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        guard let other = otherView ?? superview else { fatalError("Missing otherView or superview") }
        let c = centerYAnchor.constraint(equalTo: other.centerYAnchor)
        c.activate()
        return c
    }
    
    func addManagedSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }

    @discardableResult
    func pinEdgesToSuperview(inset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("View has no parent")
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset)
        ]
        constraints.forEach { $0.activate() }
        return constraints
    }
}

public struct ConstraintGroup {

    var top: NSLayoutConstraint?
    var leading: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?

    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?

    func activate() {
        [top, leading, bottom, trailing, width, height].forEach {
            $0?.activate()
        }
    }
}
