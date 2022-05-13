// swift-tools-version:5.6

// © 2018–2022 J. G. Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.macOS(.v11)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      targets: [.target(name: "XestiNetwork")],
                      swiftLanguageVersions: [.version("5")])
