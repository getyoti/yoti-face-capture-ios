# YotiFaceCapture

YotiFaceCapture provides a simplified way of capturing a face. It performs face detection from the front facing camera, analyses those frames and produces an optimised cropped image of the captured face.

## Requirements
- iOS 13.0+
- Swift 5.5+
- ~75KB • YotiFaceCapture uses native APIs for feature detection and image processing, thus keeping our library small    

## Installation
### Swift Package Manager
Add the following line to your `Package.swift` file:
```swift
.package(url: "https://github.com/getyoti/yoti-face-capture-ios.git", from: "9.0.1")
```
...or add our package in Xcode via `File -> Swift Packages -> Add Package Dependency...` using the URL of this repository.

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

### 4. Receive the capture state and analysis results
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

/*
FaceCaptureStateError contains two instance properties:
- code: FaceCaptureStateErrorCode
- underlyingError: Error?

FaceCaptureStateErrorCode is an enum that contains the following cases
- cameraNotAccessible
- cameraInitializingError
- invalidState
*/

func faceCaptureStateFailed(withError error: FaceCaptureStateError) {
    switch error.code {
        case .cameraNotAccessible:
            print("Print camera permissions not authorized")
        case .cameraInitializingError:
            if let underlyingError = error.underlyingError as NSError? {
                print("Camera initialization failed: \(underlyingError.localizedDescription)")
            }
        default:
            print("Undefined error")
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

### 5. Configure the capture

#### FaceCaptureUIConfiguration
Provides further customization capabilities for the capture.
- `increaseScreenBrigthnessDuringCapture`: Will increase the screen brightness to max level when the face capture UI launches. The default value is `true`

#### Configuration

Provide a Configuration instance when calling the `startAnalyzing` method
```swift
let faceCaptureConfiguration = Configuration(faceCenter: CGPoint(x: 0.5, y: 0.5),
                                             imageQuality: .medium,
                                             validationOptions: [.faceNotStraight])
faceCaptureViewController.startAnalyzing(withConfiguration: faceCaptureConfiguration)    
```
The `faceCenter` parameter is the normalised point, in relation to `faceCaptureViewController.view`, where you expect the centre of the detected face to be.<br>
The frame of the detected face is returned by `FaceCaptureViewDelegate` in `originalImageFaceCoordinates` as part of `FaceCaptureAnalysis`.<br>
The analysis will return a `faceNotCentered` error if the distance between the two points is significant.

Examples:

1. The `faceCenter` is configured to be `CGPoint(x: 0.5, y: 0.45)`, represented by the intersection of the red and blue lines in the image below.<br>
The centre of the detected face should be positioned in the vicinity of that point to result in a valid capture.

<p align="center">
<img src="https://github.com/getyoti/yoti-face-capture-ios/assets/60880814/e63e3845-0c72-4037-8449-e43331c21a35" width="30%" alt="Face centre. x: 0.5, y: 0.45">
</p>

2. The reference shape has been moved up and the `faceCenter` is now configured to `CGPoint(x: 0.5, y: 0.35)`.

<p align="center">
<img src="https://github.com/getyoti/yoti-face-capture-ios/assets/60880814/9563a277-b84c-40c2-aae6-d2618beab93e" width="30%" alt="Face centre. x: 0.5, y: 0.35">
</p>

The validation options available are:
```swift
case eyesNotOpen
case faceNotStraight
case faceNotStable(requiredFrames: Int)
case environmentTooDark(threshold: EnvironmentLuminosityThreshold)
```

The environment luminosity threshold options are:
```swift
case flexible // Reduces luminosity threshold to assist cases of low light
case strict
```

## Support
For any questions or support please contact us [here](https://support.yoti.com). Once we have answered your question, we may contact you again to discuss Yoti products and services. If you'd prefer us not to do this, please let us know when you e-mail.
