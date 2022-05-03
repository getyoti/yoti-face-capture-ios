# YotiFaceCapture

YotiFaceCapture provides a simplified way of capturing a face. It performs face detection from the front facing camera, analyses those frames and produces an optimised cropped image of the captured face.

## Requirements
- iOS 13.0+
- Swift 5.5+

## Installation
Make sure you've installed and are running the latest version of:
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) (Optional)
- [Carthage](https://github.com/Carthage/Carthage) (Optional)

### CocoaPods
Add the following to your [`Podfile`](https://guides.cocoapods.org/using/the-podfile.html) and run `pod install` from its directory:
```bash
platform :ios, '13.0'

target 'TargetName' do
  use_frameworks!
  pod 'YotiFaceCapture'
end
```

### Carthage
#### 1. Locate the necessary files
Please refer to the [Installation](Installation/Carthage) folder of this repository, and locate the [`Cartfile`](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile), `Input.xcfilelist` and `Output.xcfilelist`.

#### 2. Build dependencies
Add the `Cartfile` to the root of your project directory, and run `carthage bootstrap` from there.

#### 3. Copy frameworks
On your application targets' `Build Phases` tab:
- Click `+` icon and choose `New Run Script Phase`
- Create a script with a shell of your choice (e.g. `/bin/sh`)
- Add the following to the script area below the shell:
```bash
/usr/local/bin/carthage copy-frameworks
```
- Add the `Input.xcfilelist` to the `Input File Lists` section of the script
- Add the `Output.xcfilelist` to the `Output File Lists` section of the script

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
        case .environmentTooDark:
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
case environmentTooDark
```
