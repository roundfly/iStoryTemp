//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import UIKit

public final class GradientView: UIView {
    private let gradient = CAGradientLayer()
    private let startColor: UIColor
    private var endColor: UIColor

    public static var backgroundNoise: GradientView {
        GradientView(startColor: UIColor.black.withAlphaComponent(0.6),
                     endColor: UIColor.black.withAlphaComponent(0))
    }

    public init(startColor: UIColor, endColor: UIColor) {
        self.startColor = startColor
        self.endColor = endColor
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }

    private func setGradient() {
        gradient.removeFromSuperlayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        layer.addSublayer(gradient)
    }
}
