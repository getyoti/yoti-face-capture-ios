//
// Copyright © 2020 Yoti Ltd. All rights reserved.
//

import UIKit

enum RoundedButtonState {
    case on
    case off

    var isSwitchedOn: Bool { self == .on }
}

final class RoundedButton: UIButton {
    private let width: CGFloat = 60.0

    private var pressedState: RoundedButtonState = .off {
        didSet {
            switch pressedState {
                case .on:
                    backgroundColor = .black
                case .off:
                    backgroundColor = .lightGray
            }
        }
    }

    typealias Action = (RoundedButtonState) -> Void
    var action: Action?

    convenience init(imageName: String) {
        self.init(frame: .zero)
        setUp(imageName: imageName)
    }

    func switchOn() {
        pressedState = .on
    }

    func switchOff() {
        pressedState = .off
    }
}

// MARK: - Helpers
private extension RoundedButton {
    func setUp(imageName: String) {
        translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: imageName)
        setImage(image, for: .normal)
        adjustsImageWhenHighlighted = false
        tintColor = .white
        layer.cornerRadius = width / 2
        clipsToBounds = true
        pressedState = .off
        addTarget(self, action: #selector(handleTouchUpInsideEvent), for: .touchUpInside)

        addConstraints([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    @objc func handleTouchUpInsideEvent() {
        pressedState = pressedState.isSwitchedOn ? .off : .on
        action?(pressedState)
    }
}
