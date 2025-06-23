import Foundation
import PathKit
import Saga
@testable import SagaInkMarkdownReader
import XCTest

final class SagaInkMarkdownReaderTests: XCTestCase {
  // MARK: - Basic Markdown Parsing Tests

  func testComplexDocument() async throws {
    let reader = Reader.inkMarkdownReader
    let testFile = Path(#file).parent() + "test-content.md"

    let result = try await reader.convert(testFile)

    // Test frontmatter
    XCTAssertEqual(result.title, "Test Article")
    let frontmatter = result.frontmatter!
    XCTAssertEqual(frontmatter["date"], "2025-06-23")
    XCTAssertEqual(frontmatter["tags"], "swift, markdown, testing")
    XCTAssertEqual(frontmatter["summary"], "This is a test article for unit testing")
    XCTAssertEqual(frontmatter["published"], "true")

    // Test various HTML elements are present (note: title is in frontmatter, not body)
    XCTAssertTrue(result.body.contains("<h1>Test Article</h1>"))
    XCTAssertTrue(result.body.contains("<h2>Introduction</h2>"))
    XCTAssertTrue(result.body.contains("<h3>Code Example</h3>"))
    XCTAssertTrue(result.body.contains("<strong>bold</strong>"))
    XCTAssertTrue(result.body.contains("<em>italic</em>"))
    XCTAssertTrue(result.body.contains("<code>inline code</code>"))
    XCTAssertTrue(result.body.contains("<ul>"))
    XCTAssertTrue(result.body.contains("<blockquote>"))
    XCTAssertTrue(result.body.contains("<table>"))
    XCTAssertTrue(result.body.contains("<a href=\"https://www.example.com\">External link</a>"))
    XCTAssertTrue(result.body.contains("<a href=\"/about\">Internal link</a>"))
  }

  // MARK: - Error Handling Tests

  func testMissingFile() async {
    let reader = Reader.inkMarkdownReader
    let missingFile = Path("/tmp/nonexistent-file-\(UUID().uuidString).md")

    do {
      _ = try await reader.convert(missingFile)
      XCTFail("Should throw error for missing file")
    } catch {
      // Expected behavior
      XCTAssertTrue(true, "Correctly threw error for missing file")
    }
  }

  // MARK: - Edge Case Tests

  func testOnlyFrontmatter() async throws {
    let reader = Reader.inkMarkdownReader
    let testFile = Path(#file).parent() + "frontmatter-only.md"

    let result = try await reader.convert(testFile)

    XCTAssertNil(result.title)
    XCTAssertTrue(result.body.isEmpty)
    XCTAssertEqual(result.frontmatter?["title"], "Only Frontmatter")
    XCTAssertEqual(result.frontmatter?["author"], "Test Author")
  }

  func testOnlyMarkdownContent() async throws {
    let reader = Reader.inkMarkdownReader
    let testFile = Path(#file).parent() + "content-only.md"

    let result = try await reader.convert(testFile)

    XCTAssertEqual(result.title, "Simple Title")
    XCTAssertEqual(result.frontmatter, [:])
    XCTAssertEqual(result.body, "<h1>Simple Title</h1><p>Just some <strong>bold</strong> text and a <a href=\"https://example.com\">link</a>.</p>")
  }

  // MARK: - Markdown Feature Tests

  func testSpecialCharactersAndEntities() async throws {
    let reader = Reader.inkMarkdownReader
    let testFile = Path(#file).parent() + "special-chars.md"

    let result = try await reader.convert(testFile)

    // HTML entities should be properly encoded
    XCTAssertTrue(result.body.contains("&amp;"))
    XCTAssertTrue(result.body.contains("🚀"))
    XCTAssertTrue(result.body.contains("α"))
  }

  static var allTests = [
    ("testComplexDocument", testComplexDocument),
    ("testMissingFile", testMissingFile),
    ("testOnlyFrontmatter", testOnlyFrontmatter),
    ("testOnlyMarkdownContent", testOnlyMarkdownContent),
    ("testSpecialCharactersAndEntities", testSpecialCharactersAndEntities),
  ]
}
