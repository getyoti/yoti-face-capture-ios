# YotiFaceCapture

YotiFaceCapture provides a simplified way of capturing a face. It performs face detection from the front facing camera, analyses those frames and produces an optimised cropped image of the captured face.

## Requirements
- iOS 11.0+
- Swift 5.3+

## Installation
Make sure you've installed and are running the latest version of:
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

### CocoaPods
Add the following to your [`Podfile`](https://guides.cocoapods.org/using/the-podfile.html) and run `pod install` from its directory:
```bash
platform :ios, '11.0'

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
func faceCapture(didTransitionToState state: FaceCaptureState) {
    switch state {
        case .success(.cameraReady):
            break
        case .success(.analyzing):
            break
        case .success(.cameraStopped):
            break
        case .failure(let error):
            break
    }
}

func faceCapture(originalImage: UIImage?, didResult result: FaceCaptureResult) {
    switch result {
        case .success(.validFrame(let information)):
            break
        case .failure(let error):
            break
    }
}
```

### 4. Customize framework configuration
Provide a FaceCaptureConfiguration instance when calling the startAnalyzing method
```swift
let faceCaptureConfiguration = FaceCaptureConfiguration(scanningArea: view.frame,
                                                        imageQuality: .medium)
faceCaptureViewController.startAnalyzing(withConfiguration: faceCaptureConfiguration)    
```
