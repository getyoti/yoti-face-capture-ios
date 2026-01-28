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
            url: "https://github.com/getyoti/yoti-face-capture-ios/releases/download/v9.0.1/YotiFaceCapture.zip",
            checksum: "45fbac0232f53269bc792bceeb79df8135ffe417706a509cef80e0f53218e8d5"
        )
    ]
)
