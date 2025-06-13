// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "YotiFaceCapture",
    products: [
        .library(name: "YotiFaceCapture", targets: ["YotiFaceCapture"]),
    ],
    targets: [
        .binaryTarget(
            name: "YotiFaceCapture",
            url: "https://github.com/getyoti/yoti-face-capture-ios/releases/download/v8.0.0/YotiFaceCapture.zip",
            checksum: "97550b604051f56038d1d7af7a6976527694be9d228cca83fbd3f25e7fa0caa9"
        )
    ]
)
