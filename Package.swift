// swift-tools-version: 6.1

// © 2018–2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      platforms: [.iOS(.v16),
                                  .macOS(.v15)],
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiTools.git",
                                              branch: "swift-6-support")],
                      targets: [.target(name: "XestiNetwork",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")])],
                      swiftLanguageModes: [.version("6")])
