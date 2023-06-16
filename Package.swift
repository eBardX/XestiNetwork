// swift-tools-version:5.8

// © 2018–2023 J. G. Pusey (see LICENSE.md)

import PackageDescription

let swiftSettings: [SwiftSetting] = [.enableUpcomingFeature("BareSlashRegexLiterals"),
                                     .enableUpcomingFeature("ConciseMagicFile"),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ForwardTrailingClosures"),
                                     .enableUpcomingFeature("ImplicitOpenExistentials")]

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v14),
                                  .macOS(.v11)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      targets: [.target(name: "XestiNetwork",
                                        swiftSettings: swiftSettings)],
                      swiftLanguageVersions: [.version("5")])
