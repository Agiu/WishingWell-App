// swift-tools-version: 5.8

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "WishingWell",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "WishingWell",
            targets: ["AppModule"],
            bundleIdentifier: "com.kaelub.WishingWell",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .sparkle),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .phone,
                .pad
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources/AppModule"
        )
    ]
)
