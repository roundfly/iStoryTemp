//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import UIKit

public extension UIImage {
    private class Klass {}
    static var logo: UIImage? {
        .init(named: "main-logo", in: Bundle(for: Klass.self), with: nil)
    }
}
