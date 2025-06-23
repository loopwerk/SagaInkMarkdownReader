---
title: Test Article
date: 2025-06-23
tags: swift, markdown, testing
summary: This is a test article for unit testing
published: true
---
# Test Article

This document tests multiple markdown features together.

## Introduction

Here's some **bold** and *italic* text with `inline code`.

### Code Example

```swift
struct BlogPost {
    let title: String
    let content: String
    let tags: [String]
}
```

### Lists and Links

Here's what we're testing:
1. [Frontmatter parsing](#frontmatter)
2. **Formatting** and *emphasis*
3. Code blocks with syntax highlighting
4. Lists (both ordered and unordered)
5. Links and references

#### Unordered List
- First item
- Second item
- Third item with **bold**

### Blockquotes

> This is a blockquote with **formatting**.
> 
> It can span multiple paragraphs.

### Tables

| Feature | Status | Notes |
|---------|--------|-------|
| Headers | ✅ | Working |
| Lists | ✅ | Working |
| Code | ✅ | With highlighting |

### Links

Here are some links:
- [External link](https://www.example.com)
- [Internal link](/about)
- [Link with title](https://www.github.com "GitHub Homepage")

That's all folks!