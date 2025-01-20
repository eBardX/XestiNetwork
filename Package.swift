// swift-tools-version:6.0

// © 2018–2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v15),
                                  .macOS(.v13)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiTools.git",
                                              branch: "swift-6-support")],
                      targets: [.target(name: "XestiNetwork",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")])],
                      swiftLanguageModes: [.version("6")])
