//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit
import YotiFaceCapture

final class FaceResultViewController: UIViewController {
    @IBOutlet weak var croppedImageView: UIImageView!
    
    var faceCaptureAnalysis: FaceCaptureAnalysis?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }
}

// MARK: - Helpers
private extension FaceResultViewController {
    func populateView() {
        guard let croppedImageData = faceCaptureAnalysis?.croppedImageData,
              let image = UIImage(data: croppedImageData) else { return }
        croppedImageView.image = image
    }
}
