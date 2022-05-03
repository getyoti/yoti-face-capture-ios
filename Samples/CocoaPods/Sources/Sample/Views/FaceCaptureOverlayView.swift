//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit

protocol FaceCaptureOverlayViewable {
    var faceDetectionArea: CGRect { get }
    var isButtonEnabled: Bool { get set }
    func setInstructionLabelText(_ text: String)
    func setPrimaryButtonText(_ text: String)
}

final class FaceCaptureOverlayView: UIView {
    typealias Action = () -> Void

    var action: Action?

    @AutoLayoutView(image: "cameraFaceFrame")
    var faceFrameImageView: UIImageView = .init()

    @AutoLayoutView
    var faceDetectionView: UIView = .init()

    @AutoLayoutView
    var instructionLabel: UILabel = .init()

    @PrimaryButton(title: "Start Face Analysis")
    var primaryButton: UIButton = .init()

    convenience init(action: @escaping Action) {
        self.init()
        self.action = action
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    @objc func primaryButtonAction() {
        action?()
    }
}

// MARK: - Helpers
private extension FaceCaptureOverlayView {
    func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        setUpImageView()
        setUpFaceDetectionView()
        setUpInstructionLabel()
        setUpStartAnalysisButton()
        isButtonEnabled = false
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

    func setUpFaceDetectionView() {
        addSubview(faceDetectionView)
        faceDetectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            faceDetectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            faceDetectionView.widthAnchor.constraint(
                equalTo: safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.9
            ),
            faceDetectionView.heightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.65
            ),
            .init(
                item: faceDetectionView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 0.85,
                constant: 0
            ),
        ])
        bringSubviewToFront(faceDetectionView)
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
                multiplier: 0.88,
                constant: 0
            ),
        ])
    }

    func setUpStartAnalysisButton() {
        addSubview(primaryButton)
        primaryButton.addTarget(
            self,
            action: #selector(primaryButtonAction),
            for: .touchUpInside
        )
        NSLayoutConstraint.activate([
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            .init(
                item: primaryButton,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1.5,
                constant: 0
            ),
        ])
    }
}

// MARK: - FaceCaptureOverlayViewable
extension FaceCaptureOverlayView: FaceCaptureOverlayViewable {
    var faceDetectionArea: CGRect {
        faceDetectionView.frame
    }

    var isButtonEnabled: Bool {
        get {
            primaryButton.isEnabled
        }
        set {
            primaryButton.isEnabled = newValue
        }
    }

    func setInstructionLabelText(_ text: String) {
        instructionLabel.text = text
    }

    func setPrimaryButtonText(_ text: String) {
        primaryButton.setTitle(
            text,
            for: .normal
        )
    }
}
