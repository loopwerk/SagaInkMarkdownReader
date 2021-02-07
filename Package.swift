// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SagaPythonMarkdownReader",
  products: [
    .library(
      name: "SagaPythonMarkdownReader",
      targets: ["SagaPythonMarkdownReader"]),
  ],
  dependencies: [
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", .branch("SwiftMarkdown")),
    .package(name: "SwiftMarkdown", url: "https://github.com/loopwerk/SwiftMarkdown", from: "0.2.0"),
  ],
  targets: [
    .target(
      name: "SagaPythonMarkdownReader",
      dependencies: [
        "Saga",
        "Ink",
        "Splash",
      ]),
    .testTarget(
      name: "SagaPythonMarkdownReaderTests",
      dependencies: ["SagaPythonMarkdownReader"]),
  ]
)
