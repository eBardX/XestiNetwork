// swift-tools-version:5.8

// © 2018–2023 J. G. Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v14),
                                  .macOS(.v11)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      targets: [.target(name: "XestiNetwork")],
                      swiftLanguageVersions: [.version("5")])
