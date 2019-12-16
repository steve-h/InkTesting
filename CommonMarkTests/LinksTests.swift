/**
*  Ink
*  Copyright (c) Steve Hume 2019
*  MIT license, see LICENSE file for details
These tests are extracted from https://spec.commonmark.org/0.29/
title: CommonMark Spec
author: John MacFarlane
version: 0.29
date: '2019-04-06'
license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0
*/

import XCTest
import Ink
import Foundation

final class LinksTests: XCTestCase {

    // 
    // 
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
    //     
    // spec.txt lines 7503-7507
    func testExample481() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/uri "title")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri" title="title">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The title may be omitted:
    // 
    // 
    //     
    // spec.txt lines 7512-7516
    func testExample482() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Both the title and the destination may be omitted:
    // 
    // 
    //     
    // spec.txt lines 7521-7525
    func testExample483() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link]()
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="">link</a></p>
        let normalizedCM = #####"""
        <p><a href="">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7528-7532
    func testExample484() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](<>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="">link</a></p>
        let normalizedCM = #####"""
        <p><a href="">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The destination can only contain spaces if it is
    // enclosed in pointy brackets:
    // 
    // 
    //     
    // spec.txt lines 7537-7541
    func testExample485() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/my uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link](/my uri)</p>
        let normalizedCM = #####"""
        <p>[link](/my uri)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 7543-7547
    func testExample486() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](</my uri>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/my%20uri">link</a></p>
        let normalizedCM = #####"""
        <p>[link](&lt;/my uri&gt;)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The destination cannot contain line breaks,
    // even if enclosed in pointy brackets:
    // 
    // 
    //     
    // spec.txt lines 7552-7558
    func testExample487() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo
        bar)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link](foo
      //bar)</p>
        let normalizedCM = #####"""
        <p>[link](foo bar)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 7560-7566
    func testExample488() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](<foo
        bar>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link](<foo
      //bar>)</p>
        let normalizedCM = #####"""
        <p>[link](<foo
        bar>)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The destination can contain `)` if it is enclosed
    // in pointy brackets:
    // 
    // 
    //     
    // spec.txt lines 7571-7575
    func testExample489() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [a](<b)c>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="b)c">a</a></p>
        let normalizedCM = #####"""
        <p><a href="b)c">a</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Pointy brackets that enclose links must be unescaped:
    // 
    // 
    //     
    // spec.txt lines 7579-7583
    func testExample490() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](<foo\>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link](&lt;foo&gt;)</p>
        let normalizedCM = #####"""
        <p>[link](&lt;foo&gt;)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // These are not links, because the opening pointy bracket
    // is not matched properly:
    // 
    // 
    //     
    // spec.txt lines 7588-7596
    func testExample491() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [a](<b)c
        [a](<b)c>
        [a](<b>c)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[a](&lt;b)c
      //[a](&lt;b)c&gt;
      //[a](<b>c)</p>
        let normalizedCM = #####"""
        <p>[a](&lt;b)c [a](&lt;b)c&gt; [a](<b>c)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Parentheses inside the link destination may be escaped:
    // 
    // 
    //     
    // spec.txt lines 7600-7604
    func testExample492() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](\(foo\))
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="(foo)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="(foo)">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Any number of parentheses are allowed without escaping, as long as they are
    // balanced:
    // 
    // 
    //     
    // spec.txt lines 7609-7613
    func testExample493() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo(and(bar)))
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo(and(bar))">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar))">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // However, if you have unbalanced parentheses, you need to escape or use the
    // `<...>` form:
    // 
    // 
    //     
    // spec.txt lines 7618-7622
    func testExample494() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo\(and\(bar\))
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo(and(bar)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar)">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7625-7629
    func testExample495() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](<foo(and(bar)>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo(and(bar)">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo(and(bar)">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Parentheses and other symbols can also be escaped, as usual
    // in Markdown:
    // 
    // 
    //     
    // spec.txt lines 7635-7639
    func testExample496() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo\)\:)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo):">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo):">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A link can contain fragment identifiers and queries:
    // 
    // 
    //     
    // spec.txt lines 7644-7654
    func testExample497() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](#fragment)
        
        [link](http://example.com#fragment)
        
        [link](http://example.com?foo=3#frag)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="#fragment">link</a></p>
      //<p><a href="http://example.com#fragment">link</a></p>
      //<p><a href="http://example.com?foo=3#frag">link</a></p>
        let normalizedCM = #####"""
        <p><a href="#fragment">link</a></p><p><a href="http://example.com#fragment">link</a></p><p><a href="http://example.com?foo=3#frag">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that a backslash before a non-escapable character is
    // just a backslash:
    // 
    // 
    //     
    // spec.txt lines 7660-7664
    func testExample498() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo\bar)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo%5Cbar">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo%5Cbar">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 7676-7680
    func testExample499() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](foo%20b&auml;)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo%20b%C3%A4">link</a></p>
        let normalizedCM = #####"""
        <p><a href="foo%20b%C3%A4">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that, because titles can often be parsed as destinations,
    // if you try to omit the destination and keep the title, you'll
    // get unexpected results:
    // 
    // 
    //     
    // spec.txt lines 7687-7691
    func testExample500() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link]("title")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="%22title%22">link</a></p>
        let normalizedCM = #####"""
        <p><a href="%22title%22">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Titles may be in single quotes, double quotes, or parentheses:
    // 
    // 
    //     
    // spec.txt lines 7696-7704
    func testExample501() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/url "title")
        [link](/url 'title')
        [link](/url (title))
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">link</a>
      //<a href="/url" title="title">link</a>
      //<a href="/url" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">link</a> <a href="/url" title="title">link</a> <a href="/url" title="title">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Backslash escapes and entity and numeric character references
    // may be used in titles:
    // 
    // 
    //     
    // spec.txt lines 7710-7714
    func testExample502() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/url "title \"&quot;")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title &quot;&quot;">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title &quot;&quot;">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Titles must be separated from the link using a [whitespace].
    // Other [Unicode whitespace] like non-breaking space doesn't work.
    // 
    // 
    //     
    // spec.txt lines 7720-7724
    func testExample503() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/url "title")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url%C2%A0%22title%22">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Nested balanced quotes are not allowed without escaping:
    // 
    // 
    //     
    // spec.txt lines 7729-7733
    func testExample504() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/url "title "and" title")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
        let normalizedCM = #####"""
        <p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // But it is easy to work around this by using a different quote type:
    // 
    // 
    //     
    // spec.txt lines 7738-7742
    func testExample505() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](/url 'title "and" title')
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title &quot;and&quot; title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title &quot;and&quot; title">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 7762-7767
    func testExample506() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link](   /uri
          "title"  )
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri" title="title">link</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri" title="title">link</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // But it is not allowed between the link text and the
    // following parenthesis:
    // 
    // 
    //     
    // spec.txt lines 7773-7777
    func testExample507() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link] (/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link] (/uri)</p>
        let normalizedCM = #####"""
        <p>[link] (/uri)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link text may contain balanced brackets, but not unbalanced ones,
    // unless they are escaped:
    // 
    // 
    //     
    // spec.txt lines 7783-7787
    func testExample508() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link [foo [bar]]](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link [foo [bar]]</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [foo [bar]]</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7790-7794
    func testExample509() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link] bar](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link] bar](/uri)</p>
        let normalizedCM = #####"""
        <p>[link] bar](/uri)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7797-7801
    func testExample510() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link [bar](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[link <a href="/uri">bar</a></p>
        let normalizedCM = #####"""
        <p>[link <a href="/uri">bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7804-7808
    func testExample511() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link \[bar](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link [bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link text may contain inline content:
    // 
    // 
    //     
    // spec.txt lines 7813-7817
    func testExample512() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link *foo **bar** `#`*](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7820-7824
    func testExample513() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [![moon](moon.jpg)](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, links may not contain other links, at any level of nesting.
    // 
    // 
    //     
    // spec.txt lines 7829-7833
    func testExample514() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo [bar](/uri)](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <a href="/uri">bar</a>](/uri)</p>
        let normalizedCM = #####"""
        <p>[foo <a href="/uri">bar</a>](/uri)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7836-7840
    func testExample515() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo *[bar [baz](/uri)](/uri)*](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
        let normalizedCM = #####"""
        <p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7843-7847
    func testExample516() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![[[foo](uri1)](uri2)](uri3)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="uri3" alt="[foo](uri2)" /></p>
        let normalizedCM = #####"""
        <p><img src="uri3" alt="[foo](uri2)" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // These cases illustrate the precedence of link text grouping over
    // emphasis grouping:
    // 
    // 
    //     
    // spec.txt lines 7853-7857
    func testExample517() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *[foo*](/uri)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<a href="/uri">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/uri">foo*</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7860-7864
    func testExample518() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo *bar](baz*)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="baz*">foo *bar</a></p>
        let normalizedCM = #####"""
        <p><a href="baz*">foo *bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that brackets that *aren't* part of links do not take
    // precedence:
    // 
    // 
    //     
    // spec.txt lines 7870-7874
    func testExample519() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo [bar* baz]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo [bar</em> baz]</p>
        let normalizedCM = #####"""
        <p><em>foo [bar</em> baz]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // These cases illustrate the precedence of HTML tags, code spans,
    // and autolinks over link grouping:
    // 
    // 
    //     
    // spec.txt lines 7880-7884
    func testExample520() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo <bar attr="](baz)">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <bar attr="](baz)"></p>
        let normalizedCM = #####"""
        <p>[foo <bar attr="](baz)"></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7887-7891
    func testExample521() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo`](/uri)`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo<code>](/uri)</code></p>
        let normalizedCM = #####"""
        <p>[foo<code>](/uri)</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7894-7898
    func testExample522() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo<http://example.com/?search=](uri)>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>
        let normalizedCM = #####"""
        <p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 7932-7938
    func testExample523() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][bar]
        
        [bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The rules for the [link text] are the same as with
    // [inline links].  Thus:
    // 
    // The link text may contain balanced brackets, but not unbalanced ones,
    // unless they are escaped:
    // 
    // 
    //     
    // spec.txt lines 7947-7953
    func testExample524() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link [foo [bar]]][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link [foo [bar]]</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [foo [bar]]</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7956-7962
    func testExample525() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link \[bar][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link [bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link [bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link text may contain inline content:
    // 
    // 
    //     
    // spec.txt lines 7967-7973
    func testExample526() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [link *foo **bar** `#`*][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7976-7982
    func testExample527() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [![moon](moon.jpg)][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        let normalizedCM = #####"""
        <p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, links may not contain other links, at any level of nesting.
    // 
    // 
    //     
    // spec.txt lines 7987-7993
    func testExample528() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo [bar](/uri)][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
        let normalizedCM = #####"""
        <p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7996-8002
    func testExample529() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo *bar [baz][ref]*][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
        let normalizedCM = #####"""
        <p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // (In the examples above, we have two [shortcut reference links]
    // instead of one [full reference link].)
    // 
    // The following cases illustrate the precedence of link text grouping over
    // emphasis grouping:
    // 
    // 
    //     
    // spec.txt lines 8011-8017
    func testExample530() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *[foo*][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<a href="/uri">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/uri">foo*</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8020-8026
    func testExample531() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo *bar][ref]
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">foo *bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">foo *bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // These cases illustrate the precedence of HTML tags, code spans,
    // and autolinks over link grouping:
    // 
    // 
    //     
    // spec.txt lines 8032-8038
    func testExample532() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo <bar attr="][ref]">
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo <bar attr="][ref]"></p>
        let normalizedCM = #####"""
        <p>[foo <bar attr="][ref]"></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8041-8047
    func testExample533() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo`][ref]`
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo<code>][ref]</code></p>
        let normalizedCM = #####"""
        <p>[foo<code>][ref]</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8050-8056
    func testExample534() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo<http://example.com/?search=][ref]>
        
        [ref]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>
        let normalizedCM = #####"""
        <p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Matching is case-insensitive:
    // 
    // 
    //     
    // spec.txt lines 8061-8067
    func testExample535() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][BaR]
        
        [bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Unicode case fold is used:
    // 
    // 
    //     
    // spec.txt lines 8072-8078
    func testExample536() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Толпой][Толпой] is a Russian word.
        
        [ТОЛПОЙ]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">Толпой</a> is a Russian word.</p>
        let normalizedCM = #####"""
        <p><a href="/url">Толпой</a> is a Russian word.</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Consecutive internal [whitespace] is treated as one space for
    // purposes of determining matching:
    // 
    // 
    //     
    // spec.txt lines 8084-8091
    func testExample537() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo
          bar]: /url
        
        [Baz][Foo bar]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">Baz</a></p>
        let normalizedCM = #####"""
        <p><a href="/url">Baz</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // No [whitespace] is allowed between the [link text] and the
    // [link label]:
    // 
    // 
    //     
    // spec.txt lines 8097-8103
    func testExample538() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo] [bar]
        
        [bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo] <a href="/url" title="title">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo] <a href="/url" title="title">bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8106-8114
    func testExample539() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        [bar]
        
        [bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]
      //<a href="/url" title="title">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo] <a href="/url" title="title">bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 8147-8155
    func testExample540() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url1
        
        [foo]: /url2
        
        [bar][foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url1">bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url1">bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that matching is performed on normalized strings, not parsed
    // inline content.  So the following does not match, even though the
    // labels define equivalent inline content:
    // 
    // 
    //     
    // spec.txt lines 8162-8168
    func testExample541() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [bar][foo\!]
        
        [foo!]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[bar][foo!]</p>
        let normalizedCM = #####"""
        <p>[bar][foo!]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Link labels] cannot contain brackets, unless they are
    // backslash-escaped:
    // 
    // 
    //     
    // spec.txt lines 8174-8181
    func testExample542() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][ref[]
        
        [ref[]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo][ref[]</p>
      //<p>[ref[]: /uri</p>
        let normalizedCM = #####"""
        <p>[foo][ref[]</p><p>[ref[]: /uri</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8184-8191
    func testExample543() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][ref[bar]]
        
        [ref[bar]]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo][ref[bar]]</p>
      //<p>[ref[bar]]: /uri</p>
        let normalizedCM = #####"""
        <p>[foo][ref[bar]]</p><p>[ref[bar]]: /uri</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8194-8201
    func testExample544() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [[[foo]]]
        
        [[[foo]]]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[[[foo]]]</p>
      //<p>[[[foo]]]: /url</p>
        let normalizedCM = #####"""
        <p>[[[foo]]]</p><p>[[[foo]]]: /url</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8204-8210
    func testExample545() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][ref\[]
        
        [ref\[]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that in this example `]` is not backslash-escaped:
    // 
    // 
    //     
    // spec.txt lines 8215-8221
    func testExample546() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [bar\\]: /uri
        
        [bar\\]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/uri">bar\</a></p>
        let normalizedCM = #####"""
        <p><a href="/uri">bar\</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A [link label] must contain at least one [non-whitespace character]:
    // 
    // 
    //     
    // spec.txt lines 8226-8233
    func testExample547() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        []
        
        []: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[]</p>
      //<p>[]: /uri</p>
        let normalizedCM = #####"""
        <p>[]</p><p>[]: /uri</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8236-8247
    func testExample548() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [
         ]
        
        [
         ]: /uri
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[
      //]</p>
      //<p>[
      //]: /uri</p>
        let normalizedCM = #####"""
        <p>[ ]</p><p>[ ]: /uri</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 8259-8265
    func testExample549() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8268-8274
    func testExample550() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [*foo* bar][]
        
        [*foo* bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title"><em>foo</em> bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title"><em>foo</em> bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link labels are case-insensitive:
    // 
    // 
    //     
    // spec.txt lines 8279-8285
    func testExample551() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo][]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">Foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">Foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    // As with full reference links, [whitespace] is not
    // allowed between the two sets of brackets:
    // 
    // 
    //     
    // spec.txt lines 8292-8300
    func testExample552() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo] 
        []
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a>
      //[]</p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a> []</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
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
    //     
    // spec.txt lines 8312-8318
    func testExample553() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8321-8327
    func testExample554() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [*foo* bar]
        
        [*foo* bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title"><em>foo</em> bar</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title"><em>foo</em> bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8330-8336
    func testExample555() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [[*foo* bar]]
        
        [*foo* bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
        let normalizedCM = #####"""
        <p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8339-8345
    func testExample556() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [[bar [foo]
        
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[[bar <a href="/url">foo</a></p>
        let normalizedCM = #####"""
        <p>[[bar <a href="/url">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link labels are case-insensitive:
    // 
    // 
    //     
    // spec.txt lines 8350-8356
    func testExample557() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">Foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">Foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A space after the link text should be preserved:
    // 
    // 
    //     
    // spec.txt lines 8361-8367
    func testExample558() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo] bar
        
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">foo</a> bar</p>
        let normalizedCM = #####"""
        <p><a href="/url">foo</a> bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // If you just want bracketed text, you can backslash-escape the
    // opening bracket to avoid links:
    // 
    // 
    //     
    // spec.txt lines 8373-8379
    func testExample559() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        \[foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that this is a link, because a link label ends with the first
    // following closing bracket:
    // 
    // 
    //     
    // spec.txt lines 8385-8391
    func testExample560() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo*]: /url
        
        *[foo*]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<a href="/url">foo*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/url">foo*</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Full and compact references take precedence over shortcut
    // references:
    // 
    // 
    //     
    // spec.txt lines 8397-8404
    func testExample561() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][bar]
        
        [foo]: /url1
        [bar]: /url2
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url2">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url2">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 8406-8412
    func testExample562() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][]
        
        [foo]: /url1
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url1">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url1">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Inline links also take precedence:
    // 
    // 
    //     
    // spec.txt lines 8416-8422
    func testExample563() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]()
        
        [foo]: /url1
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 8424-8430
    func testExample564() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo](not a link)
        
        [foo]: /url1
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url1">foo</a>(not a link)</p>
        let normalizedCM = #####"""
        <p><a href="/url1">foo</a>(not a link)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // In the following case `[bar][baz]` is parsed as a reference,
    // `[foo]` as normal text:
    // 
    // 
    //     
    // spec.txt lines 8435-8441
    func testExample565() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]<a href="/url">bar</a></p>
        let normalizedCM = #####"""
        <p>[foo]<a href="/url">bar</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here, though, `[foo][bar]` is parsed as a reference, since
    // `[bar]` is defined:
    // 
    // 
    //     
    // spec.txt lines 8447-8454
    func testExample566() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url1
        [bar]: /url2
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url2">foo</a><a href="/url1">baz</a></p>
        let normalizedCM = #####"""
        <p><a href="/url2">foo</a><a href="/url1">baz</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here `[foo]` is not parsed as a shortcut reference, because it
    // is followed by a link label (even though `[bar]` is not defined):
    // 
    // 
    //     
    // spec.txt lines 8460-8467
    func testExample567() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo][bar][baz]
        
        [baz]: /url1
        [foo]: /url2
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
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
        ("testExample481", testExample481),
        ("testExample482", testExample482),
        ("testExample483", testExample483),
        ("testExample484", testExample484),
        ("testExample485", testExample485),
        ("testExample486", testExample486),
        ("testExample487", testExample487),
        ("testExample488", testExample488),
        ("testExample489", testExample489),
        ("testExample490", testExample490),
        ("testExample491", testExample491),
        ("testExample492", testExample492),
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
        ("testExample567", testExample567)
        ]
    }
}