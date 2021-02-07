# SagaInkMarkdownReader

A Markdown reader for [Saga](https://github.com/loopwerk/Saga), which uses [Ink](https://github.com/JohnSundell/Ink) and [Splash](https://github.com/JohnSundell/Splash).

## Usage
Include `SagaInkMarkdownReader` in your Package.swift as usual:

``` swift
let package = Package(
  name: "MyWebsite",
  dependencies: [
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", from: "0.11.0"),
    .package(name: "SagaInkMarkdownReader", url: "https://github.com/loopwerk/SagaInkMarkdownReader", from: "0.3.0"),
  ],
  targets: [
    .target(
      name: "MyWebsite",
      dependencies: ["Saga", "SagaInkMarkdownReader"]),
  ]
)
```

And then in your website you can `import SagaInkMarkdownReader` and use `inkMarkdownReader` as you would do the default `markdownReader`.
