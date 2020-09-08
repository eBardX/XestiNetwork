// swift-tools-version:5.2

// © 2018–2020 J. G. Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.macOS(.v10_15)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      targets: [.target(name: "XestiNetwork")],
                      swiftLanguageVersions: [.version("5")])
