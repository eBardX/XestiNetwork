// swift-tools-version:5.1

// © 2018 J. G. Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiNetwork",
                      products: [.library(name: "XestiNetwork",
                                          targets: ["XestiNetwork"])],
                      targets: [.target(name: "XestiNetwork")])
