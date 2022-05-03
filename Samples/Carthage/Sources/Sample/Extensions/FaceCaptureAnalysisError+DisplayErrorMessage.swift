//
// Copyright © 2020 Yoti Ltd. All rights reserved.
//

import YotiFaceCapture

extension FaceCaptureAnalysisError {
    var displayErrorMessage: String {
        switch self {
            case .noFaceDetected:
                return "No face detected"
            case .multipleFaces:
                return "Multiple faces"
            case .faceTooSmall:
                return "Face too small"
            case .faceTooBig:
                return "Face too big"
            case .faceNotCentered:
                return "Face not centered"
            case .faceAnalysisFailed:
                return "Face analysis failed"
            case .eyesNotOpen:
                return "Eyes not open"
            case .faceNotStable:
                return "Face not stable"
            case .faceNotStraight:
                return "Face not straight"
            case .environmentTooDark:
                return "Environment too dark"
            @unknown default:
                return "Invalid Result"
        }
    }
}
