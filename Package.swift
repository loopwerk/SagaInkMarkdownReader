// swift-tools-version:5.10

import PackageDescription

let package = Package(
  name: "SagaInkMarkdownReader",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(
      name: "SagaInkMarkdownReader",
      targets: ["SagaInkMarkdownReader"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga.git", "2.0.3"..<"4.0.0"),
    .package(url: "https://github.com/johnsundell/Ink.git", from: "0.5.0"),
    .package(url: "https://github.com/JohnSundell/Splash", from: "0.16.0"),
  ],
  targets: [
    .target(
      name: "SagaInkMarkdownReader",
      dependencies: [
        "Saga",
        "Ink",
        "Splash",
      ]
    ),
    .testTarget(
      name: "SagaInkMarkdownReaderTests",
      dependencies: ["SagaInkMarkdownReader"],
      resources: [
        .copy("test-content.md"),
        .copy("frontmatter-only.md"),
        .copy("content-only.md"),
        .copy("special-chars.md"),
      ]
    ),
  ]
)
