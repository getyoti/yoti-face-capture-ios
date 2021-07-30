# YotiFaceCapture

YotiFaceCapture provides a simplified way of capturing a face. It performs face detection from the front facing camera, analyses those frames and produces an optimised cropped image of the captured face.

## Requirements
- iOS 12.0+
- Swift 5.3+

## Installation
Make sure you've installed and are running the latest version of:
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

### CocoaPods
Add the following to your [`Podfile`](https://guides.cocoapods.org/using/the-podfile.html) and run `pod install` from its directory:
```bash
platform :ios, '12.0'

target 'TargetName' do
  use_frameworks!
  pod 'YotiFaceCapture'
end
```

## Integration
### 1. Import frameworks
Import the framework in your implementation:
```swift
import YotiFaceCapture
```

### 2. Create FaceCaptureViewController
Fetch FaceCaptureViewController from framework and set delegate
```swift
let faceCaptureViewController = FaceCapture.faceCaptureViewController()
faceCaptureViewController.delegate = self
```

### 3. Start camera feed and analysis
Start the camera feed
```swift
faceCaptureViewController.startCamera()
```
Start the analysis
```swift
faceCaptureViewController.startAnalyzing(withConfiguration: .default)
```

Whenever required, both camera feed and analysis process can be stopped
```swift
faceCaptureViewController.stopCamera()
faceCaptureViewController.stopAnalyzing()
```

### 4. Receive framework state and analysis results
Conform to FaceCaptureViewDelegate
```swift
func faceCaptureStateDidChange(to state: FaceCaptureState) {
    switch state {
        case .cameraReady:
            break
        case .analyzing:
            break
        case .cameraStopped:
            break
    }
}

func faceCaptureStateFailed(withError error: FaceCaptureStateError) {
    switch error {
        case .cameraNotAccessible:
            break
        case .cameraInitializingError:
            break
        case .invalidState:
            break
    }
}

func faceCaptureDidAnalyzeImage(_ originalImage: UIImage?, withAnalysis analysis: FaceCaptureAnalysis) {

}

func faceCaptureDidAnalyzeImage(_ originalImage: UIImage?, withError error: FaceCaptureAnalysisError) {
    switch error {
        case .faceAnalysisFailed:
            break
        case .noFaceDetected:
            break
        case .multipleFaces:
            break
        case .eyesNotOpen:
            break
        case .faceTooSmall:
            break
        case .faceTooBig:
            break
        case .faceNotCentered:
            break
        case .faceNotStable:
            break
        case .faceNotStraight:
            break
    }
}
```

### 5. Customize framework configuration
Provide a Configuration instance when calling the startAnalyzing method
```swift
let faceCaptureConfiguration = Configuration(scanningArea: view.frame,
                                             imageQuality: .medium,
                                             validationOptions: [.faceNotStraight])
faceCaptureViewController.startAnalyzing(withConfiguration: faceCaptureConfiguration)    
```

The validation options available are:
```swift
case eyesNotOpen
case faceNotStraight
case faceNotStable(requiredFrames: Int)
```
