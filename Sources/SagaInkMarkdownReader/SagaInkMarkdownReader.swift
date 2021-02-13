import Foundation
import Saga
import Ink
import Splash

public extension Reader {
  static func inkMarkdownReader(itemProcessor: ((Item<M>) -> Void)? = nil) -> Self {
    Reader(supportedExtensions: ["md", "markdown"], convert: { absoluteSource, relativeSource, relativeDestination in
      let contents: String = try absoluteSource.read()

      // First we parse the markdown file, and use the Splash syntax highlighter
      var markdownParser = MarkdownParser()
      markdownParser.addModifier(.splashCodeBlocks())
      let markdown = markdownParser.parse(contents)

      // Then we try to decode the embedded metadata within the markdown (which otherwise is just a [String: String] dict)
      let decoder = makeMetadataDecoder(for: markdown.metadata)
      let date = try resolvePublishingDate(from: absoluteSource, decoder: decoder)
      let metadata = try M.init(from: decoder)

      // Create the Page
      let item = Item(
        relativeSource: relativeSource,
        relativeDestination: relativeDestination,
        title: markdown.title ?? relativeSource.lastComponentWithoutExtension,
        rawContent: contents,
        body: markdown.html,
        date: date,
        lastModified: absoluteSource.modificationDate ?? Date(),
        metadata: metadata
      )

      // Run the processor, if any, to modify the Page
      if let itemProcessor = itemProcessor {
        itemProcessor(item)
      }

      return item
    })
  }
}

public extension Modifier {
  static func splashCodeBlocks(withFormat format: HTMLOutputFormat = .init()) -> Self {
    let highlighter = SyntaxHighlighter(format: format)

    return Modifier(target: .codeBlocks) { html, markdown in
      var markdown = markdown.dropFirst("```".count)

      guard !markdown.hasPrefix("no-highlight") else {
        return html
      }

      markdown = markdown
        .drop(while: { !$0.isNewline })
        .dropFirst()
        .dropLast("\n```".count)

      let highlighted = highlighter.highlight(String(markdown))
      return "<pre><code>" + highlighted + "\n</code></pre>"
    }
  }
}
