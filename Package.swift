// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SagaInkMarkdownReader",
  products: [
    .library(
      name: "SagaInkMarkdownReader",
      targets: ["SagaInkMarkdownReader"]),
  ],
  dependencies: [
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", from: "0.14.0"),
    .package(name: "Ink", url: "https://github.com/johnsundell/ink.git", from: "0.2.0"),
    .package(name: "Splash", url: "https://github.com/JohnSundell/Splash", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "SagaInkMarkdownReader",
      dependencies: [
        "Saga",
        "Ink",
        "Splash",
      ]),
    .testTarget(
      name: "SagaInkMarkdownReaderTests",
      dependencies: ["SagaInkMarkdownReader"]),
  ]
)
