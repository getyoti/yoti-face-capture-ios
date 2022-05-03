//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(
        color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1)
    ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
