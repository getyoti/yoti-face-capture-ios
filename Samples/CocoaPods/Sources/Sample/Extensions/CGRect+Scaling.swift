//
// Copyright © 2020 Yoti Ltd. All rights reserved.
//

import CoreGraphics

extension CGRect {
    /// Returns a scaled frame calculated based on originalImageSize and the faceCaptureViewSize
    /// - Parameters:
    ///   - originalImageSize: The size's object of a frame captured by the YotiFaceCapture framework
    ///   - faceCaptureViewSize: The size's object of the FaceCaptureViewController's view
    /// - Returns: A scaled frame based on the parameter sizes passed as parameters
    func scaledBasedOn(
        originalImageSize: CGSize,
        faceCaptureViewSize: CGSize
    ) -> CGRect {
        let scalingXFactor = faceCaptureViewSize.width / originalImageSize.width
        let scalingYFactor = faceCaptureViewSize.height / originalImageSize.height
        
        var scaledFrame = self
        scaledFrame.size.width *= scalingXFactor
        scaledFrame.origin.x *= scalingXFactor
        scaledFrame.size.height *= scalingYFactor
        scaledFrame.origin.y *= scalingYFactor
        return scaledFrame
    }
}
