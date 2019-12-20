/**
*  Ink
*  Copyright (c) Steve Hume 2019
*  MIT license, see LICENSE file for details
---
title: GitHub Flavored Markdown Spec
version: 0.29
date: '2019-04-06'
license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)'
...
*/

import XCTest
import Ink
import Foundation

final class LinksTests: XCTestCase {

    // </div>
    // 
    // ## Links
    // 
    // A link contains [link text] (the visible text), a [link destination]
    // (the URI that is the link destination), and optionally a [link title].
    // There are two basic kinds of links in Markdown.  In [inline links] the
    // destination and title are given immediately after the link text.  In
    // [reference links] the destination and title are defined elsewhere in
    // the document.
    // 
    // A [link text](@) consists of a sequence of zero or more
    // inline elements enclosed by square brackets (`[` and `]`).  The
    // following rules apply:
    // 
    // - Links may not contain other links, at any level of nesting. If
    //   multiple otherwise valid link definitions appear nested inside each
    //   other, the inner-most definition is used.
    // 
    // - Brackets are allowed in the [link text] only if (a) they
    //   are backslash-escaped or (b) they appear as a matched pair of brackets,
    //   with an open bracket `[`, a sequence of zero or more inlines, and
    //   a close bracket `]`.
    // 
    // - Backtick [code spans], [autolinks], and raw [HTML tags] bind more tightly
    //   than the brackets in link text.  Thus, for example,
    //   `` [foo`]` `` could not be a link text, since the second `]`
    //   is part of a code span.
    // 
    // - The brackets in link text bind more tightly than markers for
    //   [emphasis and strong emphasis]. Thus, for example, `*[foo*](url)` is a link.
    // 
    // A [link destination](@) consists of either
    // 
    // - a sequence of zero or more characters between an opening `<` and a
    //   closing `>` that contains no line breaks or unescaped
    //   `<` or `>` characters, or
    // 
    // - a nonempty sequence of characters that does not start with
    //   `<`, does not include ASCII space or control characters, and
    //   includes parentheses only if (a) they are backslash-escaped or
    //   (b) they are part of a balanced pair of unescaped parentheses.
    //   (Implementations may impose limits on parentheses nesting to
    //   avoid performance issues, but at least three levels of nesting
    //   should be supported.)
    // 
    // A [link title](@)  consists of either
    // 
    // - a sequence of zero or more characters between straight double-quote
    //   characters (`"`), including a `"` character only if it is
    //   backslash-escaped, or
    // 
    // - a sequence of zero or more characters between straight single-quote
    //   characters (`'`), including a `'` character only if it is
    //   backslash-escaped, or
    // 
    // - a sequence of zero or more characters between matching parentheses
    //   (`(...)`), including a `(` or `)` character only if it is
    //   backslash-escaped.
    // 
    // Although [link titles] may span multiple lines, they may not contain
    // a [blank line].
    // 
    // An [inline link](@) consists of a [link text] followed immediately
    // by a left parenthesis `(`, optional [whitespace], an optional
    // [link destination], an optional [link title] separated from the link
    // destination by [whitespace], optional [whitespace], and a right
    // parenthesis `)`. The link's text consists of the inlines contained
    // in the [link text] (excluding the enclosing square brackets).
    // The link's URI consists of the link destination, excluding enclosing
    // `<...>` if present, with backslash-escapes in effect as described
    // above.  The link's title consists of the link title, excluding its
    // enclosing delimiters, with backslash-escapes in effect as described
    // above.
    // 
    // Here is a simple inline link:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7812-7816
    func testExample493() {
        let markdownTest =
        #####"""
        [link](/uri "title")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri" title="title">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The title may be omitted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7821-7825
    func testExample494() {
        let markdownTest =
        #####"""
        [link](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Both the title and the destination may be omitted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7830-7834
    func testExample495() {
        let markdownTest =
        #####"""
        [link]()
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="">link</a></p>
        let normalizedCM = #####"""
        <p><a href="">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7837-7841
    func testExample496() {
        let markdownTest =
        #####"""
        [link](<>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="">link</a></p>
        let normalizedCM = #####"""
        <p><a href="">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The destination can only contain spaces if it is
    // enclosed in pointy brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7846-7850
    func testExample497() {
        let markdownTest =
        #####"""
        [link](/my uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link](/my uri)</p>
        let normalizedCM = #####"""
        <p>[link](/my uri)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7852-7856
    func testExample498() {
        let markdownTest =
        #####"""
        [link](</my uri>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/my%20uri">link</a></p>
        let normalizedCM = #####"""
        <p>[link](&lt;/my uri&gt;)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The destination cannot contain line breaks,
    // even if enclosed in pointy brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7861-7867
    func testExample499() {
        let markdownTest =
        #####"""
        [link](foo
        bar)\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[link](foo
      //bar)</p>
        let normalizedCM = #####"""
        <p>[link](foo bar)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7869-7875
    func testExample500() {
        let markdownTest =
        #####"""
        [link](<foo
        bar>)\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[link](<foo
      //bar>)</p>
        let normalizedCM = #####"""
        <p>[link](<foo
        bar>)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The destination can contain `)` if it is enclosed
    // in pointy brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7880-7884
    func testExample501() {
        let markdownTest =
        #####"""
        [a](<b)c>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="b)c">a</a></p>
        let normalizedCM = #####"""
        <p><a href="b)c">a</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Pointy brackets that enclose links must be unescaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7888-7892
    func testExample502() {
        let markdownTest =
        #####"""
        [link](<foo\>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link](&lt;foo&gt;)</p>
        let normalizedCM = #####"""
        <p>[link](&lt;foo&gt;)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These are not links, because the opening pointy bracket
    // is not matched properly:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7897-7905
    func testExample503() {
        let markdownTest =
        #####"""
        [a](<b)c
        [a](<b)c>
        [a](<b>c)\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[a](&lt;b)c
      //[a](&lt;b)c&gt;
      //[a](<b>c)</p>
        let normalizedCM = #####"""
        <p>[a](&lt;b)c [a](&lt;b)c&gt; [a](<b>c)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Parentheses inside the link destination may be escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7909-7913
    func testExample504() {
        let markdownTest =
        #####"""
        [link](\(foo\))
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="(foo)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="(foo)">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Any number of parentheses are allowed without escaping, as long as they are
    // balanced:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7918-7922
    func testExample505() {
        let markdownTest =
        #####"""
        [link](foo(and(bar)))
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo(and(bar))">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar))">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, if you have unbalanced parentheses, you need to escape or use the
    // `<...>` form:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7927-7931
    func testExample506() {
        let markdownTest =
        #####"""
        [link](foo\(and\(bar\))
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo(and(bar)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar)">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7934-7938
    func testExample507() {
        let markdownTest =
        #####"""
        [link](<foo(and(bar)>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo(and(bar)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar)">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Parentheses and other symbols can also be escaped, as usual
    // in Markdown:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7944-7948
    func testExample508() {
        let markdownTest =
        #####"""
        [link](foo\)\:)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo):">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo):">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A link can contain fragment identifiers and queries:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7953-7963
    func testExample509() {
        let markdownTest =
        #####"""
        [link](#fragment)
        
        [link](http://example.com#fragment)
        
        [link](http://example.com?foo=3#frag)\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="#fragment">link</a></p>
      //<p><a href="http://example.com#fragment">link</a></p>
      //<p><a href="http://example.com?foo=3#frag">link</a></p>
        let normalizedCM = #####"""
        <p><a href="#fragment">link</a></p><p><a href="http://example.com#fragment">link</a></p><p><a href="http://example.com?foo=3#frag">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that a backslash before a non-escapable character is
    // just a backslash:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7969-7973
    func testExample510() {
        let markdownTest =
        #####"""
        [link](foo\bar)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo%5Cbar">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo%5Cbar">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // URL-escaping should be left alone inside the destination, as all
    // URL-escaped characters are also valid URL characters. Entity and
    // numerical character references in the destination will be parsed
    // into the corresponding Unicode code points, as usual.  These may
    // be optionally URL-escaped when written as HTML, but this spec
    // does not enforce any particular policy for rendering URLs in
    // HTML or other formats.  Renderers may make different decisions
    // about how to escape or normalize URLs in the output.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7985-7989
    func testExample511() {
        let markdownTest =
        #####"""
        [link](foo%20b&auml;)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="foo%20b%C3%A4">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo%20b%C3%A4">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that, because titles can often be parsed as destinations,
    // if you try to omit the destination and keep the title, you'll
    // get unexpected results:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7996-8000
    func testExample512() {
        let markdownTest =
        #####"""
        [link]("title")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="%22title%22">link</a></p>
        let normalizedCM = #####"""
        <p><a href="%22title%22">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Titles may be in single quotes, double quotes, or parentheses:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8005-8013
    func testExample513() {
        let markdownTest =
        #####"""
        [link](/url "title")
        [link](/url 'title')
        [link](/url (title))\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">link</a>
      //<a href="/url" title="title">link</a>
      //<a href="/url" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">link</a> <a href="/url" title="title">link</a> <a href="/url" title="title">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash escapes and entity and numeric character references
    // may be used in titles:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8019-8023
    func testExample514() {
        let markdownTest =
        #####"""
        [link](/url "title \"&quot;")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/url" title="title &quot;&quot;">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title &quot;&quot;">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Titles must be separated from the link using a [whitespace].
    // Other [Unicode whitespace] like non-breaking space doesn't work.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8029-8033
    func testExample515() {
        let markdownTest =
        #####"""
        [link](/url "title")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/url%C2%A0%22title%22">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Nested balanced quotes are not allowed without escaping:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8038-8042
    func testExample516() {
        let markdownTest =
        #####"""
        [link](/url "title "and" title")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
        let normalizedCM = #####"""
        <p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // But it is easy to work around this by using a different quote type:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8047-8051
    func testExample517() {
        let markdownTest =
        #####"""
        [link](/url 'title "and" title')
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/url" title="title &quot;and&quot; title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title &quot;and&quot; title">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // (Note:  `Markdown.pl` did allow double quotes inside a double-quoted
    // title, and its test suite included a test demonstrating this.
    // But it is hard to see a good rationale for the extra complexity this
    // brings, since there are already many ways---backslash escaping,
    // entity and numeric character references, or using a different
    // quote type for the enclosing title---to write titles containing
    // double quotes.  `Markdown.pl`'s handling of titles has a number
    // of other strange features.  For example, it allows single-quoted
    // titles in inline links, but not reference links.  And, in
    // reference links but not inline links, it allows a title to begin
    // with `"` and end with `)`.  `Markdown.pl` 1.0.1 even allows
    // titles with no closing quotation mark, though 1.0.2b8 does not.
    // It seems preferable to adopt a simple, rational rule that works
    // the same way in inline links and link reference definitions.)
    // 
    // [Whitespace] is allowed around the destination and title:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8071-8076
    func testExample518() {
        let markdownTest =
        #####"""
        [link](   /uri
          "title"  )\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri" title="title">link</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // But it is not allowed between the link text and the
    // following parenthesis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8082-8086
    func testExample519() {
        let markdownTest =
        #####"""
        [link] (/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link] (/uri)</p>
        let normalizedCM = #####"""
        <p>[link] (/uri)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link text may contain balanced brackets, but not unbalanced ones,
    // unless they are escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8092-8096
    func testExample520() {
        let markdownTest =
        #####"""
        [link [foo [bar]]](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri">link [foo [bar]]</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [foo [bar]]</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8099-8103
    func testExample521() {
        let markdownTest =
        #####"""
        [link] bar](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link] bar](/uri)</p>
        let normalizedCM = #####"""
        <p>[link] bar](/uri)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8106-8110
    func testExample522() {
        let markdownTest =
        #####"""
        [link [bar](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[link <a href="/uri">bar</a></p>
        let normalizedCM = #####"""
        <p>[link <a href="/uri">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8113-8117
    func testExample523() {
        let markdownTest =
        #####"""
        [link \[bar](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri">link [bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link text may contain inline content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8122-8126
    func testExample524() {
        let markdownTest =
        #####"""
        [link *foo **bar** `#`*](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8129-8133
    func testExample525() {
        let markdownTest =
        #####"""
        [![moon](moon.jpg)](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, links may not contain other links, at any level of nesting.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8138-8142
    func testExample526() {
        let markdownTest =
        #####"""
        [foo [bar](/uri)](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[foo <a href="/uri">bar</a>](/uri)</p>
        let normalizedCM = #####"""
        <p>[foo <a href="/uri">bar</a>](/uri)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8145-8149
    func testExample527() {
        let markdownTest =
        #####"""
        [foo *[bar [baz](/uri)](/uri)*](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
        let normalizedCM = #####"""
        <p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8152-8156
    func testExample528() {
        let markdownTest =
        #####"""
        ![[[foo](uri1)](uri2)](uri3)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><img src="uri3" alt="[foo](uri2)" /></p>
        let normalizedCM = #####"""
        <p><img src="uri3" alt="[foo](uri2)" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These cases illustrate the precedence of link text grouping over
    // emphasis grouping:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8162-8166
    func testExample529() {
        let markdownTest =
        #####"""
        *[foo*](/uri)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>*<a href="/uri">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/uri">foo*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8169-8173
    func testExample530() {
        let markdownTest =
        #####"""
        [foo *bar](baz*)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="baz*">foo *bar</a></p>
        let normalizedCM = #####"""
        <p><a href="baz*">foo *bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that brackets that *aren't* part of links do not take
    // precedence:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8179-8183
    func testExample531() {
        let markdownTest =
        #####"""
        *foo [bar* baz]
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><em>foo [bar</em> baz]</p>
        let normalizedCM = #####"""
        <p><em>foo [bar</em> baz]</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These cases illustrate the precedence of HTML tags, code spans,
    // and autolinks over link grouping:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8189-8193
    func testExample532() {
        let markdownTest =
        #####"""
        [foo <bar attr="](baz)">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[foo <bar attr="](baz)"></p>
        let normalizedCM = #####"""
        <p>[foo <bar attr="](baz)"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8196-8200
    func testExample533() {
        let markdownTest =
        #####"""
        [foo`](/uri)`
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[foo<code>](/uri)</code></p>
        let normalizedCM = #####"""
        <p>[foo<code>](/uri)</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8203-8207
    func testExample534() {
        let markdownTest =
        #####"""
        [foo<http://example.com/?search=](uri)>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>
        let normalizedCM = #####"""
        <p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // There are three kinds of [reference link](@)s:
    // [full](#full-reference-link), [collapsed](#collapsed-reference-link),
    // and [shortcut](#shortcut-reference-link).
    // 
    // A [full reference link](@)
    // consists of a [link text] immediately followed by a [link label]
    // that [matches] a [link reference definition] elsewhere in the document.
    // 
    // A [link label](@)  begins with a left bracket (`[`) and ends
    // with the first right bracket (`]`) that is not backslash-escaped.
    // Between these brackets there must be at least one [non-whitespace character].
    // Unescaped square bracket characters are not allowed inside the
    // opening and closing square brackets of [link labels].  A link
    // label can have at most 999 characters inside the square
    // brackets.
    // 
    // One label [matches](@)
    // another just in case their normalized forms are equal.  To normalize a
    // label, strip off the opening and closing brackets,
    // perform the *Unicode case fold*, strip leading and trailing
    // [whitespace] and collapse consecutive internal
    // [whitespace] to a single space.  If there are multiple
    // matching reference link definitions, the one that comes first in the
    // document is used.  (It is desirable in such cases to emit a warning.)
    // 
    // The contents of the first link label are parsed as inlines, which are
    // used as the link's text.  The link's URI and title are provided by the
    // matching [link reference definition].
    // 
    // Here is a simple example:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8241-8247
    func testExample535() {
        let markdownTest =
        #####"""
        [foo][bar]
        
        [bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The rules for the [link text] are the same as with
    // [inline links].  Thus:
    // 
    // The link text may contain balanced brackets, but not unbalanced ones,
    // unless they are escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8256-8262
    func testExample536() {
        let markdownTest =
        #####"""
        [link [foo [bar]]][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">link [foo [bar]]</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [foo [bar]]</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8265-8271
    func testExample537() {
        let markdownTest =
        #####"""
        [link \[bar][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">link [bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link text may contain inline content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8276-8282
    func testExample538() {
        let markdownTest =
        #####"""
        [link *foo **bar** `#`*][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8285-8291
    func testExample539() {
        let markdownTest =
        #####"""
        [![moon](moon.jpg)][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, links may not contain other links, at any level of nesting.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8296-8302
    func testExample540() {
        let markdownTest =
        #####"""
        [foo [bar](/uri)][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
        let normalizedCM = #####"""
        <p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8305-8311
    func testExample541() {
        let markdownTest =
        #####"""
        [foo *bar [baz][ref]*][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
        let normalizedCM = #####"""
        <p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // (In the examples above, we have two [shortcut reference links]
    // instead of one [full reference link].)
    // 
    // The following cases illustrate the precedence of link text grouping over
    // emphasis grouping:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8320-8326
    func testExample542() {
        let markdownTest =
        #####"""
        *[foo*][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>*<a href="/uri">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/uri">foo*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8329-8335
    func testExample543() {
        let markdownTest =
        #####"""
        [foo *bar][ref]
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">foo *bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">foo *bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These cases illustrate the precedence of HTML tags, code spans,
    // and autolinks over link grouping:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8341-8347
    func testExample544() {
        let markdownTest =
        #####"""
        [foo <bar attr="][ref]">
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo <bar attr="][ref]"></p>
        let normalizedCM = #####"""
        <p>[foo <bar attr="][ref]"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8350-8356
    func testExample545() {
        let markdownTest =
        #####"""
        [foo`][ref]`
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo<code>][ref]</code></p>
        let normalizedCM = #####"""
        <p>[foo<code>][ref]</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8359-8365
    func testExample546() {
        let markdownTest =
        #####"""
        [foo<http://example.com/?search=][ref]>
        
        [ref]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>
        let normalizedCM = #####"""
        <p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Matching is case-insensitive:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8370-8376
    func testExample547() {
        let markdownTest =
        #####"""
        [foo][BaR]
        
        [bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Unicode case fold is used:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8381-8387
    func testExample548() {
        let markdownTest =
        #####"""
        [Толпой][Толпой] is a Russian word.
        
        [ТОЛПОЙ]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url">Толпой</a> is a Russian word.</p>
        let normalizedCM = #####"""
        <p><a href="/url">Толпой</a> is a Russian word.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Consecutive internal [whitespace] is treated as one space for
    // purposes of determining matching:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8393-8400
    func testExample549() {
        let markdownTest =
        #####"""
        [Foo
          bar]: /url
        
        [Baz][Foo bar]\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url">Baz</a></p>
        let normalizedCM = #####"""
        <p><a href="/url">Baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // No [whitespace] is allowed between the [link text] and the
    // [link label]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8406-8412
    func testExample550() {
        let markdownTest =
        #####"""
        [foo] [bar]
        
        [bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo] <a href="/url" title="title">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo] <a href="/url" title="title">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8415-8423
    func testExample551() {
        let markdownTest =
        #####"""
        [foo]
        [bar]
        
        [bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo]
      //<a href="/url" title="title">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo] <a href="/url" title="title">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is a departure from John Gruber's original Markdown syntax
    // description, which explicitly allows whitespace between the link
    // text and the link label.  It brings reference links in line with
    // [inline links], which (according to both original Markdown and
    // this spec) cannot have whitespace after the link text.  More
    // importantly, it prevents inadvertent capture of consecutive
    // [shortcut reference links]. If whitespace is allowed between the
    // link text and the link label, then in the following we will have
    // a single reference link, not two shortcut reference links, as
    // intended:
    // 
    // ``` markdown
    // [foo]
    // [bar]
    // 
    // [foo]: /url1
    // [bar]: /url2
    // ```
    // 
    // (Note that [shortcut reference links] were introduced by Gruber
    // himself in a beta version of `Markdown.pl`, but never included
    // in the official syntax description.  Without shortcut reference
    // links, it is harmless to allow space between the link text and
    // link label; but once shortcut references are introduced, it is
    // too dangerous to allow this, as it frequently leads to
    // unintended results.)
    // 
    // When there are multiple matching [link reference definitions],
    // the first is used:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8456-8464
    func testExample552() {
        let markdownTest =
        #####"""
        [foo]: /url1
        
        [foo]: /url2
        
        [bar][foo]\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url1">bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url1">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that matching is performed on normalized strings, not parsed
    // inline content.  So the following does not match, even though the
    // labels define equivalent inline content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8471-8477
    func testExample553() {
        let markdownTest =
        #####"""
        [bar][foo\!]
        
        [foo!]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[bar][foo!]</p>
        let normalizedCM = #####"""
        <p>[bar][foo!]</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // [Link labels] cannot contain brackets, unless they are
    // backslash-escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8483-8490
    func testExample554() {
        let markdownTest =
        #####"""
        [foo][ref[]
        
        [ref[]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo][ref[]</p>
      //<p>[ref[]: /uri</p>
        let normalizedCM = #####"""
        <p>[foo][ref[]</p><p>[ref[]: /uri</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8493-8500
    func testExample555() {
        let markdownTest =
        #####"""
        [foo][ref[bar]]
        
        [ref[bar]]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo][ref[bar]]</p>
      //<p>[ref[bar]]: /uri</p>
        let normalizedCM = #####"""
        <p>[foo][ref[bar]]</p><p>[ref[bar]]: /uri</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8503-8510
    func testExample556() {
        let markdownTest =
        #####"""
        [[[foo]]]
        
        [[[foo]]]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[[[foo]]]</p>
      //<p>[[[foo]]]: /url</p>
        let normalizedCM = #####"""
        <p>[[[foo]]]</p><p>[[[foo]]]: /url</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8513-8519
    func testExample557() {
        let markdownTest =
        #####"""
        [foo][ref\[]
        
        [ref\[]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that in this example `]` is not backslash-escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8524-8530
    func testExample558() {
        let markdownTest =
        #####"""
        [bar\\]: /uri
        
        [bar\\]\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/uri">bar\</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">bar\</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A [link label] must contain at least one [non-whitespace character]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8535-8542
    func testExample559() {
        let markdownTest =
        #####"""
        []
        
        []: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[]</p>
      //<p>[]: /uri</p>
        let normalizedCM = #####"""
        <p>[]</p><p>[]: /uri</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8545-8556
    func testExample560() {
        let markdownTest =
        #####"""
        [
         ]
        
        [
         ]: /uri\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[
      //]</p>
      //<p>[
      //]: /uri</p>
        let normalizedCM = #####"""
        <p>[ ]</p><p>[ ]: /uri</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A [collapsed reference link](@)
    // consists of a [link label] that [matches] a
    // [link reference definition] elsewhere in the
    // document, followed by the string `[]`.
    // The contents of the first link label are parsed as inlines,
    // which are used as the link's text.  The link's URI and title are
    // provided by the matching reference link definition.  Thus,
    // `[foo][]` is equivalent to `[foo][foo]`.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8568-8574
    func testExample561() {
        let markdownTest =
        #####"""
        [foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8577-8583
    func testExample562() {
        let markdownTest =
        #####"""
        [*foo* bar][]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title"><em>foo</em> bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title"><em>foo</em> bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link labels are case-insensitive:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8588-8594
    func testExample563() {
        let markdownTest =
        #####"""
        [Foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">Foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">Foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // As with full reference links, [whitespace] is not
    // allowed between the two sets of brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8601-8609
    func testExample564() {
        let markdownTest =
        #####"""
        [foo]
        []
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">foo</a>
      //[]</p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a> []</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A [shortcut reference link](@)
    // consists of a [link label] that [matches] a
    // [link reference definition] elsewhere in the
    // document and is not followed by `[]` or a link label.
    // The contents of the first link label are parsed as inlines,
    // which are used as the link's text.  The link's URI and title
    // are provided by the matching link reference definition.
    // Thus, `[foo]` is equivalent to `[foo][]`.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8621-8627
    func testExample565() {
        let markdownTest =
        #####"""
        [foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8630-8636
    func testExample566() {
        let markdownTest =
        #####"""
        [*foo* bar]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title"><em>foo</em> bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title"><em>foo</em> bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8639-8645
    func testExample567() {
        let markdownTest =
        #####"""
        [[*foo* bar]]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
        let normalizedCM = #####"""
        <p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8648-8654
    func testExample568() {
        let markdownTest =
        #####"""
        [[bar [foo]
        
        [foo]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[[bar <a href="/url">foo</a></p>
        let normalizedCM = #####"""
        <p>[[bar <a href="/url">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link labels are case-insensitive:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8659-8665
    func testExample569() {
        let markdownTest =
        #####"""
        [Foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url" title="title">Foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">Foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A space after the link text should be preserved:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8670-8676
    func testExample570() {
        let markdownTest =
        #####"""
        [foo] bar
        
        [foo]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url">foo</a> bar</p>
        let normalizedCM = #####"""
        <p><a href="/url">foo</a> bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If you just want bracketed text, you can backslash-escape the
    // opening bracket to avoid links:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8682-8688
    func testExample571() {
        let markdownTest =
        #####"""
        \[foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <p>[foo]</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that this is a link, because a link label ends with the first
    // following closing bracket:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8694-8700
    func testExample572() {
        let markdownTest =
        #####"""
        [foo*]: /url
        
        *[foo*]\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>*<a href="/url">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/url">foo*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Full and compact references take precedence over shortcut
    // references:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8706-8713
    func testExample573() {
        let markdownTest =
        #####"""
        [foo][bar]
        
        [foo]: /url1
        [bar]: /url2\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url2">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url2">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8715-8721
    func testExample574() {
        let markdownTest =
        #####"""
        [foo][]
        
        [foo]: /url1\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url1">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url1">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Inline links also take precedence:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8725-8731
    func testExample575() {
        let markdownTest =
        #####"""
        [foo]()
        
        [foo]: /url1\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8733-8739
    func testExample576() {
        let markdownTest =
        #####"""
        [foo](not a link)
        
        [foo]: /url1\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url1">foo</a>(not a link)</p>
        let normalizedCM = #####"""
        <p><a href="/url1">foo</a>(not a link)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In the following case `[bar][baz]` is parsed as a reference,
    // `[foo]` as normal text:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8744-8750
    func testExample577() {
        let markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo]<a href="/url">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo]<a href="/url">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here, though, `[foo][bar]` is parsed as a reference, since
    // `[bar]` is defined:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8756-8763
    func testExample578() {
        let markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url1
        [bar]: /url2\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/url2">foo</a><a href="/url1">baz</a></p>
        let normalizedCM = #####"""
        <p><a href="/url2">foo</a><a href="/url1">baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here `[foo]` is not parsed as a shortcut reference, because it
    // is followed by a link label (even though `[bar]` is not defined):
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8769-8776
    func testExample579() {
        let markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url1
        [foo]: /url2\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>[foo]<a href="/url1">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo]<a href="/url1">bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension LinksTests {
    static var allTests: Linux.TestList<LinksTests> {
        return [
        ("testExample493", testExample493),
        ("testExample494", testExample494),
        ("testExample495", testExample495),
        ("testExample496", testExample496),
        ("testExample497", testExample497),
        ("testExample498", testExample498),
        ("testExample499", testExample499),
        ("testExample500", testExample500),
        ("testExample501", testExample501),
        ("testExample502", testExample502),
        ("testExample503", testExample503),
        ("testExample504", testExample504),
        ("testExample505", testExample505),
        ("testExample506", testExample506),
        ("testExample507", testExample507),
        ("testExample508", testExample508),
        ("testExample509", testExample509),
        ("testExample510", testExample510),
        ("testExample511", testExample511),
        ("testExample512", testExample512),
        ("testExample513", testExample513),
        ("testExample514", testExample514),
        ("testExample515", testExample515),
        ("testExample516", testExample516),
        ("testExample517", testExample517),
        ("testExample518", testExample518),
        ("testExample519", testExample519),
        ("testExample520", testExample520),
        ("testExample521", testExample521),
        ("testExample522", testExample522),
        ("testExample523", testExample523),
        ("testExample524", testExample524),
        ("testExample525", testExample525),
        ("testExample526", testExample526),
        ("testExample527", testExample527),
        ("testExample528", testExample528),
        ("testExample529", testExample529),
        ("testExample530", testExample530),
        ("testExample531", testExample531),
        ("testExample532", testExample532),
        ("testExample533", testExample533),
        ("testExample534", testExample534),
        ("testExample535", testExample535),
        ("testExample536", testExample536),
        ("testExample537", testExample537),
        ("testExample538", testExample538),
        ("testExample539", testExample539),
        ("testExample540", testExample540),
        ("testExample541", testExample541),
        ("testExample542", testExample542),
        ("testExample543", testExample543),
        ("testExample544", testExample544),
        ("testExample545", testExample545),
        ("testExample546", testExample546),
        ("testExample547", testExample547),
        ("testExample548", testExample548),
        ("testExample549", testExample549),
        ("testExample550", testExample550),
        ("testExample551", testExample551),
        ("testExample552", testExample552),
        ("testExample553", testExample553),
        ("testExample554", testExample554),
        ("testExample555", testExample555),
        ("testExample556", testExample556),
        ("testExample557", testExample557),
        ("testExample558", testExample558),
        ("testExample559", testExample559),
        ("testExample560", testExample560),
        ("testExample561", testExample561),
        ("testExample562", testExample562),
        ("testExample563", testExample563),
        ("testExample564", testExample564),
        ("testExample565", testExample565),
        ("testExample566", testExample566),
        ("testExample567", testExample567),
        ("testExample568", testExample568),
        ("testExample569", testExample569),
        ("testExample570", testExample570),
        ("testExample571", testExample571),
        ("testExample572", testExample572),
        ("testExample573", testExample573),
        ("testExample574", testExample574),
        ("testExample575", testExample575),
        ("testExample576", testExample576),
        ("testExample577", testExample577),
        ("testExample578", testExample578),
        ("testExample579", testExample579)
        ]
    }
}