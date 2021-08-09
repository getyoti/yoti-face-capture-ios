//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   buttons: [UIAlertAction]) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        for button in buttons {
            alertVC.addAction(button)
        }
        present(alertVC,
                animated: true,
                completion: nil)
    }
}
