//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

@propertyWrapper
struct PrimaryButton<T: UIButton> {
    let wrappedValue: T

    init(wrappedValue: T, title: String) {
        self.wrappedValue = wrappedValue
        self.wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        self.wrappedValue.setTitleColor(.white,
                                        for: .normal)
        self.wrappedValue.setTitle(title,
                                   for: .normal)
        self.wrappedValue.setBackgroundImage(.imageWithColor(color: .primaryButtonColor),
                                             for: .normal)
        self.wrappedValue.setBackgroundImage(.imageWithColor(color: UIColor.primaryButtonColor.withAlphaComponent(0.5)),
                                             for: .selected)
        self.wrappedValue.contentEdgeInsets = .init(top: 16,
                                                    left: 16,
                                                    bottom: 16,
                                                    right: 16)
        self.wrappedValue.layer.cornerRadius = 8.0
        self.wrappedValue.clipsToBounds = true
    }
}
