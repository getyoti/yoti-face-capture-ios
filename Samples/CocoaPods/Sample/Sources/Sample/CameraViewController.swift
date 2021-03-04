//
// Copyright © 2021 Yoti Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import YotiFaceCapture

final class CameraViewController: UIViewController {
    private lazy var faceCaptureViewController: YotiFaceCapture.FaceCaptureViewController = {
        let faceCaptureViewController = FaceCapture.faceCaptureViewController()
        faceCaptureViewController.delegate = self
        faceCaptureViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return faceCaptureViewController
    }()
    
    private lazy var faceCaptureOverlayView: FaceCaptureOverlayViewable & UIView = FaceCaptureOverlayView(action: startFaceAnalysis)
    
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
        
    func startCamera() {
        faceCaptureViewController.startCamera()
    }
    
    @objc private func startFaceAnalysis() {
        let faceCaptureConfiguration = FaceCaptureConfiguration(scanningArea: faceCaptureOverlayView.faceDetectionArea,
                                                                imageQuality: .default)
        faceCaptureViewController.startAnalyzing(withConfiguration: faceCaptureConfiguration)
    }
}

// MARK: - FaceCaptureViewDelegate
extension CameraViewController: FaceCaptureViewDelegate {
    func faceCapture(didTransitionToState state: FaceCaptureState) {
        switch state {
            case .success(.cameraReady):
                faceCaptureOverlayView.isButtonEnabled = true
                faceCaptureOverlayView.setInstructionLabelText("Align your face here")
            case .success(.cameraStopped),
                 .success(.analyzing):
                faceCaptureOverlayView.isButtonEnabled = false
            case .failure(let error):
                faceCaptureOverlayView.isButtonEnabled = false
                showAlert(title: "Error",
                          message: "An error occurred: \(error)",
                          buttons: [.init(title: "OK",
                                          style: .cancel,
                                          handler: nil)])
        }
    }
    
    func faceCapture(originalImage: UIImage?,
                     didResult result: FaceCaptureResult) {
        switch result {
            case .success(let successResult):
                guard case .validFrame(let analysisInformation) = successResult else { return }
                faceCaptureOverlayView.setInstructionLabelText("Valid frame")
                faceCaptureViewController.stopAnalyzing()
                navigateToFaceResultView(with: analysisInformation)
            case .failure(let error):
                faceCaptureOverlayView.setInstructionLabelText(error.displayErrorMessage)
        }
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
            faceCaptureOverlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            faceCaptureOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            faceCaptureOverlayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            faceCaptureOverlayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
    
    func navigateToFaceResultView(with information: FaceCaptureAnalysisInformation) {
        guard let faceResultViewController = storyboard?.instantiateViewController(withIdentifier: "FaceResultViewController") as? FaceResultViewController else { return }
        faceResultViewController.analysisInformation = information
        navigationController?.pushViewController(faceResultViewController,
                                                 animated: true)
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
