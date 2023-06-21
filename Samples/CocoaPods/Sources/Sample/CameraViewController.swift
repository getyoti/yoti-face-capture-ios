//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import AVFoundation
import UIKit
import YotiFaceCapture

final class CameraViewController: UIViewController {
    private lazy var faceCaptureViewController: YotiFaceCapture.FaceCaptureViewController = {
        let faceCaptureViewController = FaceCapture.faceCaptureViewController()
        faceCaptureViewController.delegate = self
        faceCaptureViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return faceCaptureViewController
    }()
    
    private lazy var faceCaptureOverlayView: FaceCaptureOverlayViewable & UIView = FaceCaptureOverlayView()
    
    private let faceCenter = CGPoint(x: 0.5, y: 0.45)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFaceCaptureViewController()
        requestCameraAccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeFaceCaptureViewController()
    }
}

// MARK: - FaceCaptureViewDelegate
extension CameraViewController: FaceCaptureViewDelegate {
    func faceCaptureStateDidChange(to state: FaceCaptureState) {
        switch state {
            case .cameraReady:
                faceCaptureOverlayView.setInstructionLabelText("Align your face here")
                startFaceAnalysis()
            case .cameraStopped,
                    .analyzing:
                break
            @unknown default:
                faceCaptureStateFailed(withError: .invalidState)
        }
    }
    
    func faceCaptureStateFailed(withError error: FaceCaptureStateError) {
        showAlert(
            title: "Error",
            message: "An error occurred: \(error)",
            buttons: [
                .init(
                    title: "OK",
                    style: .cancel,
                    handler: nil
                )
            ]
        )
    }
    
    func faceCaptureDidAnalyzeImage(_ originalImage: UIImage?, withAnalysis analysis: FaceCaptureAnalysis) {
        faceCaptureOverlayView.setInstructionLabelText("Valid frame")
        faceCaptureOverlayView.setCapturedImageWithData(analysis.croppedImageData)
        faceCaptureOverlayView.addFaceDetectionLayers(
            faceCenter: CGPoint(
                x: faceCaptureOverlayView.bounds.width * faceCenter.x,
                y: faceCaptureOverlayView.bounds.height * faceCenter.y
            ),
            faceFrame: analysis.originalImageFaceCoordinates,
            croppedFacePoint: analysis.croppedImageFaceCoordinates.origin,
            croppedImageSize: UIImage(data: analysis.croppedImageData)!.size,
            originalImageSize: originalImage!.size
        )
    }
    
    func faceCaptureDidAnalyzeImage(_ originalImage: UIImage?, withError error: FaceCaptureAnalysisError) {
        faceCaptureOverlayView.setInstructionLabelText(error.displayErrorMessage)
        faceCaptureOverlayView.setCapturedImageWithData(nil)
        faceCaptureOverlayView.removeFaceDetectionLayers()
    }
}

// MARK: - Helpers
private extension CameraViewController {
    func setUpView() {
        view.backgroundColor = .systemGray
        setUpOverlayView()
    }
    
    func setUpOverlayView() {
        view.addSubview(faceCaptureOverlayView)
        NSLayoutConstraint.activate([
            faceCaptureOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            faceCaptureOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            faceCaptureOverlayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            faceCaptureOverlayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.startCamera()
                } else {
                    self?.showCameraPermissionDeniedAlert()
                }
            }
        }
    }
    
    func startCamera() {
        faceCaptureViewController.startCamera()
    }
    
    func startFaceAnalysis() {
        let faceCaptureConfiguration = Configuration(
            faceCenter: faceCenter,
            imageQuality: .default
        )
        faceCaptureViewController.startAnalyzing(withConfiguration: faceCaptureConfiguration)
    }
}

// MARK: - Add / Remove child FaceCaptureViewController
private extension CameraViewController {
    func addFaceCaptureViewController() {
        addChild(faceCaptureViewController)
        view.addSubview(faceCaptureViewController.view)
        view.sendSubviewToBack(faceCaptureViewController.view)
        faceCaptureViewController.didMove(toParent: self)
    }
    
    func removeFaceCaptureViewController() {
        faceCaptureViewController.willMove(toParent: nil)
        faceCaptureViewController.view.removeFromSuperview()
        faceCaptureViewController.removeFromParent()
    }
}

// MARK: - CameraPermissionDeniedDisplaying
extension CameraViewController: CameraPermissionDeniedDisplaying {}
