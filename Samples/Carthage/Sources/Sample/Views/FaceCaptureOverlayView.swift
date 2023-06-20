//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

protocol FaceCaptureOverlayViewable {
    func setInstructionLabelText(_ text: String)
    func setCapturedImageWithData(_ data: Data?)
    func addFaceDetectionLayers(
        faceCenter: CGPoint,
        faceFrame: CGRect,
        croppedFacePoint: CGPoint,
        croppedImageSize: CGSize,
        originalImageSize: CGSize
    )
    func removeFaceDetectionLayers()
}

final class FaceCaptureOverlayView: UIView {
    @AutoLayoutView(image: "cameraFaceFrame")
    var faceFrameImageView: UIImageView = .init()

    @AutoLayoutView
    var faceDetectionView: UIView = .init()

    @AutoLayoutView
    var instructionLabel: UILabel = .init()

    private lazy var debugButton: RoundedButton = {
        let button = RoundedButton(imageName: "icoScanningArea")
        button.action = debugButtonAction
        button.switchOff()
        return button
    }()

    private lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2.0
        return imageView
    }()

    private lazy var faceDetectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.isHidden = true
        return layer
    }()

    private lazy var croppedFaceDetectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.isHidden = true
        return layer
    }()

    private var captureImageWidthConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    func debugButtonAction(state: RoundedButtonState) {
        switch state {
            case .on:
                faceDetectionLayer.isHidden = false
                croppedFaceDetectionLayer.isHidden = false
            case .off:
                faceDetectionLayer.isHidden = true
                croppedFaceDetectionLayer.isHidden = true
        }
    }
}

// MARK: - Setup
private extension FaceCaptureOverlayView {
    func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        setUpImageView()
        setUpInstructionLabel()
        setUpDebugButton()
        setUpCapturedImageView()
    }

    func setUpImageView() {
        addSubview(faceFrameImageView)
        NSLayoutConstraint.activate([
            faceFrameImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            faceFrameImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            faceFrameImageView.topAnchor.constraint(equalTo: topAnchor),
            faceFrameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setUpInstructionLabel() {
        addSubview(instructionLabel)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .white
        NSLayoutConstraint.activate([
            instructionLabel.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.5
            ),
            instructionLabel.heightAnchor.constraint(
                equalTo: heightAnchor,
                multiplier: 0.15
            ),
            instructionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            .init(
                item: instructionLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 0.6,
                constant: 0
            ),
        ])
    }

    func setUpDebugButton() {
        addSubview(debugButton)
        NSLayoutConstraint.activate([
            debugButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            debugButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
        ])
    }

    func setUpCapturedImageView() {
        addSubview(capturedImageView)
        NSLayoutConstraint.activate([
            capturedImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40.0),
            capturedImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            capturedImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
        ])
    }
}

// MARK: - FaceCaptureOverlayViewable
extension FaceCaptureOverlayView: FaceCaptureOverlayViewable {
    func setInstructionLabelText(_ text: String) {
        instructionLabel.text = text
    }

    func setCapturedImageWithData(_ data: Data?) {
        guard let data, let image = UIImage(data: data) else {
            capturedImageView.isHidden = true
            return
        }
        capturedImageView.isHidden = false
        capturedImageView.image = image

        if let captureImageWidthConstraint { capturedImageView.removeConstraint(captureImageWidthConstraint) }
        captureImageWidthConstraint = capturedImageView.widthAnchor.constraint(
            equalTo: capturedImageView.heightAnchor,
            multiplier: image.size.width / image.size.height
        )
        captureImageWidthConstraint?.isActive = true
    }

    func addFaceDetectionLayers(
        faceCenter: CGPoint,
        faceFrame: CGRect,
        croppedFacePoint: CGPoint,
        croppedImageSize: CGSize,
        originalImageSize: CGSize
    ) {
        guard
            !faceDetectionLayer.isHidden
                && !croppedFaceDetectionLayer.isHidden
        else { return }

        let transformation = CGAffineTransform(scaleX: -1, y: 1)
            .translatedBy(x: -bounds.width, y: 0)

        let scaledFaceDetectionFrame = faceFrame.scaledBasedOn(
            originalImageSize: originalImageSize,
            faceCaptureViewSize: bounds.size
        ).applying(transformation)

        let croppedFaceFrame = CGRect(
            x: croppedFacePoint.x,
            y: croppedFacePoint.y,
            width: croppedImageSize.width,
            height: croppedImageSize.height
        )

        let scaledCroppedFaceDetectionFrame = croppedFaceFrame.scaledBasedOn(
            originalImageSize: originalImageSize,
            faceCaptureViewSize: bounds.size
        ).applying(transformation)

        removeFaceDetectionLayers()

        // Yellow circle - face center
        let faceCenterFrame = CGRect(
            x: faceCenter.x - 5.0,
            y: faceCenter.y - 5.0,
            width: 10.0,
            height: 10.0
        )
        layer.addSublayer(
            layer(
                frame: faceCenterFrame,
                strokeColor: UIColor.yellow.cgColor,
                fillColor: UIColor.yellow.cgColor,
                isCircle: true
            )
        )

        // Red box - detected face
        faceDetectionLayer = layer(
            frame: scaledFaceDetectionFrame,
            strokeColor: UIColor.red.cgColor
        )
        layer.addSublayer(faceDetectionLayer)

        // Red circle - detected face center
        let faceDetectionCenterFrame = CGRect(
            x: scaledFaceDetectionFrame.midX - 5.0,
            y: scaledFaceDetectionFrame.midY - 5.0,
            width: 10.0,
            height: 10.0
        )
        faceDetectionLayer.addSublayer(
            layer(
                frame: faceDetectionCenterFrame,
                strokeColor: UIColor.red.cgColor,
                fillColor: UIColor.red.cgColor,
                isCircle: true
            )
        )

        // Green box - cropped area
        croppedFaceDetectionLayer = layer(
            frame: scaledCroppedFaceDetectionFrame,
            strokeColor: UIColor.green.cgColor
        )
        layer.addSublayer(croppedFaceDetectionLayer)
    }

    func removeFaceDetectionLayers() {
        faceDetectionLayer.removeFromSuperlayer()
        croppedFaceDetectionLayer.removeFromSuperlayer()
    }
}

// MARK: - Helpers
private extension FaceCaptureOverlayView {
    func layer(
        frame: CGRect,
        strokeColor: CGColor,
        fillColor: CGColor = UIColor.clear.cgColor,
        isCircle: Bool = false
    ) -> CAShapeLayer {

        let path = UIBezierPath(
            roundedRect: frame,
            cornerRadius: isCircle ? frame.width * 0.5 : 0.0
        ).cgPath
        let layer = CAShapeLayer()
        layer.path = path
        layer.fillColor = fillColor
        layer.strokeColor = strokeColor
        layer.lineWidth = 2.0
        return layer
    }
}
