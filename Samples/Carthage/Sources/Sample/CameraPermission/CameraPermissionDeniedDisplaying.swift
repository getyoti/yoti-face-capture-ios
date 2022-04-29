//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

protocol CameraPermissionDeniedDisplaying {
    func showCameraPermissionDeniedAlert()
}

extension CameraPermissionDeniedDisplaying where Self: UIViewController {
    func showCameraPermissionDeniedAlert() {
        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        let settingsButton = UIAlertAction(
            title: "Settings",
            style: .default
        ) { [weak self] _ in
            self?.openSettings()
        }

        showAlert(
            title: "Camera permissions needed",
            message: "Open Settings and allow access to your camera so you can continue.",
            buttons: [
                cancelButton,
                settingsButton,
            ]
        )
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
