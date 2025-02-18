import Foundation
import Saga
import Ink
import Splash

public extension Reader {
  static var inkMarkdownReader: Self {
    Reader(supportedExtensions: ["md", "markdown"], convert: { absoluteSource in
      let contents: String = try absoluteSource.read()

      var markdownParser = MarkdownParser()
      markdownParser.addModifier(.splashCodeBlocks())
      let document = markdownParser.parse(contents)

      return (document.title, document.html, document.metadata)
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
