// swift-tools-version: 5.10

// © 2018–2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiTools.git",
                                              from: "4.0.0")],
                      targets: [.target(name: "XestiNetwork",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")])],
                      swiftLanguageVersions: [.v5])

let swiftSettings: [SwiftSetting] = [.enableUpcomingFeature("BareSlashRegexLiterals"),
                                     .enableUpcomingFeature("ConciseMagicFile"),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ForwardTrailingClosures"),
                                     .enableUpcomingFeature("ImplicitOpenExistentials")]

for target in package.targets {
    var settings = target.swiftSettings ?? []

    settings.append(contentsOf: swiftSettings)

    target.swiftSettings = settings
}
