import Foundation
import Saga
import Ink
import Splash
import Codextended
import PathKit
import Slugify

public extension Reader {
  static func inkMarkdownReader(pageProcessor: ((Page<M>) -> Void)? = nil) -> Self {
    Reader(supportedExtensions: ["md", "markdown"], convert: { path, relativePath in
      let contents: String = try path.read()

      // First we parse the markdown file, and use the Splash syntax highlighter
      var markdownParser = MarkdownParser()
      markdownParser.addModifier(.splashCodeBlocks())
      let markdown = markdownParser.parse(contents)

      // Then we try to decode the embedded metadata within the markdown (which otherwise is just a [String: String] dict)
      let decoder = makeMetadataDecoder(for: markdown.metadata)
      let date = try resolvePublishingDate(from: path, decoder: decoder)
      let metadata = try M.init(from: decoder)
      let template = try decoder.decodeIfPresent("template", as: String.self)

      // Create the Page
      let page = Page(
        relativeSource: relativePath,
        title: markdown.title ?? path.lastComponentWithoutExtension,
        rawContent: contents,
        body: markdown.html,
        date: date,
        lastModified: path.modificationDate ?? Date(),
        metadata: metadata,
        template: template != nil ? Path(template!) : nil
      )

      // Run the processor, if any, to modify the Page
      if let pageProcessor = pageProcessor {
        pageProcessor(page)
      }

      return page
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
