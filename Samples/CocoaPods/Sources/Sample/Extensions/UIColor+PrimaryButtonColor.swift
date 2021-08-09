//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

extension UIColor {
    static let primaryButtonColor = UIColor(red: 47, green: 157, blue: 255)
    
    convenience init(red: UInt, green: UInt, blue: UInt) {
        assert(red <= 255, "Invalid red component")
        assert(green <= 255, "Invalid green component")
        assert(blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(1))
    }
}
