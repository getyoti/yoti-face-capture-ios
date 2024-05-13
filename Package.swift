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
            url: "https://github.com/getyoti/yoti-face-capture-ios/releases/download/v5.1.2/YotiFaceCapture.zip",
            checksum: "ad8fa97c5f4e24ee87dd6670b4c7c82c2724802b71c8ecf5a39d090cbc3164ac"
        )
    ]
)
