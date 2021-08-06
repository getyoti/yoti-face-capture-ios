//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

@propertyWrapper
struct AutoLayoutView<T: UIView> {
    let wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension AutoLayoutView where T: UIImageView {
    init(wrappedValue: T, image: String) {
        self.wrappedValue = wrappedValue
        self.wrappedValue.contentMode = .scaleAspectFill
        self.wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        self.wrappedValue.image = UIImage(named: image)!
    }
}

extension AutoLayoutView where T: UILabel {
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        self.wrappedValue.numberOfLines = 0
        self.wrappedValue.lineBreakMode = .byWordWrapping
        self.wrappedValue.textColor = .black
        self.wrappedValue.font = .boldSystemFont(ofSize: 30)
    }
}
