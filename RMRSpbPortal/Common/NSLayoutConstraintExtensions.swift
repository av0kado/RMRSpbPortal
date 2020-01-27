//
//  NSLayoutConstraintExtensions.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 07.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Legacy

@objc extension NSLayoutAnchor {
    @discardableResult
    public func constrain(
        _ relation: NSLayoutConstraint.Relation = .equal,
        to anchor: NSLayoutAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        activate: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
            case .equal:
                constraint = self.constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
            @unknown default:
                fatalError("\(#function) for relation `\(relation)` is not implemented.")
        }
        constraint.priority = priority
        constraint.isActive = activate
        return constraint
    }
}

extension NSLayoutDimension {
    @discardableResult
    public func constrain(
        _ relation: NSLayoutConstraint.Relation = .equal,
        to anchor: NSLayoutDimension,
        constant: CGFloat = 0.0,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority = .required,
        activate: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
            case .equal:
                constraint = self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = self.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            @unknown default:
                fatalError("\(#function) for relation `\(relation)` is not implemented.")
        }
        constraint.priority = priority
        constraint.isActive = activate
        return constraint
    }

    @discardableResult
    public func constrain(
        _ relation: NSLayoutConstraint.Relation = .equal,
        to constant: CGFloat,
        priority: UILayoutPriority = .required,
        activate: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
            case .equal:
                constraint = self.constraint(equalToConstant: constant)
            case .greaterThanOrEqual:
                constraint = self.constraint(greaterThanOrEqualToConstant: constant)
            case .lessThanOrEqual:
                constraint = self.constraint(lessThanOrEqualToConstant: constant)
            @unknown default:
                fatalError("\(#function) for relation `\(relation)` is not implemented.")
        }
        constraint.priority = priority
        constraint.isActive = activate
        return constraint
    }
}


private protocol AnchorProvider {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: AnchorProvider {}
extension UILayoutGuide: AnchorProvider {}

extension UIView {
    func forAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    public enum ConstraintBindingType {
        case none
        case toEdge(CGFloat)
        case toMargin(CGFloat)
        case toSafeArea(CGFloat)
    }

    @discardableResult
    public func constrainToFill(_ view: UIView, with edgeInsets: UIEdgeInsets = .zero, activate: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: edgeInsets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: edgeInsets.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInsets.bottom)
        ]

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func constrainToFill(
        _ view: UIView,
        top: CGFloat? = 0,
        bottom: CGFloat? = 0,
        leading: CGFloat? = 0,
        trailing: CGFloat? = 0,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        top.with { constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: $0)) }
        bottom.with { constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: $0)) }
        leading.with { constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: $0)) }
        trailing.with { constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: $0)) }

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func constrainToFill(
        _ view: UIView,
        top: ConstraintBindingType = .toEdge(0),
        bottom: ConstraintBindingType = .toEdge(0),
        leading: ConstraintBindingType = .toEdge(0),
        trailing: ConstraintBindingType = .toEdge(0),
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        let constraints = [
            constraint(with: view, anchorGetter: { $0.topAnchor }, binding: top, reversed: false),
            constraint(with: view, anchorGetter: { $0.bottomAnchor }, binding: bottom, reversed: true),
            constraint(with: view, anchorGetter: { $0.leadingAnchor }, binding: leading, reversed: false),
            constraint(with: view, anchorGetter: { $0.trailingAnchor }, binding: trailing, reversed: true)
        ]
        .compactMap { $0 }

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func constrainSize(_ size: CGSize, activate: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func constrainToCenter(
        in view: UIView,
        xOffset: CGFloat? = 0,
        yOffset: CGFloat? = 0,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        xOffset.with { constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: $0)) }
        yOffset.with { constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: $0)) }

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    private func constraint<Axis, Anchor: NSLayoutAnchor<Axis>>(
        with view: UIView,
        anchorGetter: ((AnchorProvider) -> Anchor),
        binding: ConstraintBindingType,
        reversed: Bool
    ) -> NSLayoutConstraint? {
        switch binding {
            case .none:
                return nil
            case .toEdge(let constant):
                if reversed {
                    return anchorGetter(view).constraint(equalTo: anchorGetter(self), constant: constant)
                } else {
                    return anchorGetter(self).constraint(equalTo: anchorGetter(view), constant: constant)
                }
            case .toMargin(let constant):
                if reversed {
                    return anchorGetter(view.layoutMarginsGuide).constraint(equalTo: anchorGetter(self), constant: constant)
                } else {
                    return anchorGetter(self).constraint(equalTo: anchorGetter(view.layoutMarginsGuide), constant: constant)
                }
            case .toSafeArea(let constant):
                if reversed {
                    return anchorGetter(view.safeAreaLayoutGuide).constraint(equalTo: anchorGetter(self), constant: constant)
                } else {
                    return anchorGetter(self).constraint(equalTo: anchorGetter(view.safeAreaLayoutGuide), constant: constant)
                }
        }
    }
}
