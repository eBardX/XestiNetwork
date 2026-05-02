// swift-tools-version: 6.2

// © 2018–2026 John Gary Pusey (see LICENSE.md)

import PackageDescription

let swiftSettings: [SwiftSetting] = [.defaultIsolation(nil),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ImmutableWeakCaptures"),
                                     .enableUpcomingFeature("InferIsolatedConformances"),
                                     .enableUpcomingFeature("InternalImportsByDefault"),
                                     .enableUpcomingFeature("MemberImportVisibility"),
                                     .enableUpcomingFeature("NonisolatedNonsendingByDefault")]

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      dependencies: [.package(url: "https://github.com/swiftlang/swift-docc-plugin.git",
                                              .upToNextMajor(from: "1.5.0")),
                                     .package(url: "https://github.com/eBardX/XestiTools.git",
                                              .upToNextMajor(from: "7.3.0"))],
                      targets: [.target(name: "XestiNetwork",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")],
                                        swiftSettings: swiftSettings),
                                .testTarget(name: "XestiNetworkTests",
                                            dependencies: [.target(name: "XestiNetwork")],
                                            swiftSettings: swiftSettings)],
                      swiftLanguageModes: [.v6])
