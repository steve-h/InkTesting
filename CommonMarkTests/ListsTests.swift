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

final class ListsTests: XCTestCase {

    // </div>
    // 
    // ## Lists
    // 
    // A [list](@) is a sequence of one or more
    // list items [of the same type].  The list items
    // may be separated by any number of blank lines.
    // 
    // Two list items are [of the same type](@)
    // if they begin with a [list marker] of the same type.
    // Two list markers are of the
    // same type if (a) they are bullet list markers using the same character
    // (`-`, `+`, or `*`) or (b) they are ordered list numbers with the same
    // delimiter (either `.` or `)`).
    // 
    // A list is an [ordered list](@)
    // if its constituent list items begin with
    // [ordered list markers], and a
    // [bullet list](@) if its constituent list
    // items begin with [bullet list markers].
    // 
    // The [start number](@)
    // of an [ordered list] is determined by the list number of
    // its initial list item.  The numbers of subsequent list items are
    // disregarded.
    // 
    // A list is [loose](@) if any of its constituent
    // list items are separated by blank lines, or if any of its constituent
    // list items directly contain two block-level elements with a blank line
    // between them.  Otherwise a list is [tight](@).
    // (The difference in HTML output is that paragraphs in a loose list are
    // wrapped in `<p>` tags, while paragraphs in a tight list are not.)
    // 
    // Changing the bullet or ordered list delimiter starts a new list:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5175-5187
    func testExample281() {
        let markdownTest =
        #####"""
        - foo
        - bar
        + baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li>bar</li>
      //</ul>
      //<ul>
      //<li>baz</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li>bar</li></ul><ul><li>baz</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5190-5202
    func testExample282() {
        let markdownTest =
        #####"""
        1. foo
        2. bar
        3) baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>foo</li>
      //<li>bar</li>
      //</ol>
      //<ol start="3">
      //<li>baz</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li>foo</li><li>bar</li></ol><ol start="3"><li>baz</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In CommonMark, a list can interrupt a paragraph. That is,
    // no blank line is needed to separate a paragraph from a following
    // list:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5209-5219
    func testExample283() {
        let markdownTest =
        #####"""
        Foo
        - bar
        - baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo</p>
      //<ul>
      //<li>bar</li>
      //<li>baz</li>
      //</ul>
        let normalizedCM = #####"""
        <p>Foo</p><ul><li>bar</li><li>baz</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // `Markdown.pl` does not allow this, through fear of triggering a list
    // via a numeral in a hard-wrapped line:
    // 
    // ``` markdown
    // The number of windows in my house is
    // 14.  The number of doors is 6.
    // ```
    // 
    // Oddly, though, `Markdown.pl` *does* allow a blockquote to
    // interrupt a paragraph, even though the same considerations might
    // apply.
    // 
    // In CommonMark, we do allow lists to interrupt paragraphs, for
    // two reasons.  First, it is natural and not uncommon for people
    // to start lists without blank lines:
    // 
    // ``` markdown
    // I need to buy
    // - new shoes
    // - a coat
    // - a plane ticket
    // ```
    // 
    // Second, we are attracted to a
    // 
    // > [principle of uniformity](@):
    // > if a chunk of text has a certain
    // > meaning, it will continue to have the same meaning when put into a
    // > container block (such as a list item or blockquote).
    // 
    // (Indeed, the spec for [list items] and [block quotes] presupposes
    // this principle.) This principle implies that if
    // 
    // ``` markdown
    //   * I need to buy
    //     - new shoes
    //     - a coat
    //     - a plane ticket
    // ```
    // 
    // is a list item containing a paragraph followed by a nested sublist,
    // as all Markdown implementations agree it is (though the paragraph
    // may be rendered without `<p>` tags, since the list is "tight"),
    // then
    // 
    // ``` markdown
    // I need to buy
    // - new shoes
    // - a coat
    // - a plane ticket
    // ```
    // 
    // by itself should be a paragraph followed by a nested sublist.
    // 
    // Since it is well established Markdown practice to allow lists to
    // interrupt paragraphs inside list items, the [principle of
    // uniformity] requires us to allow this outside list items as
    // well.  ([reStructuredText](http://docutils.sourceforge.net/rst.html)
    // takes a different approach, requiring blank lines before lists
    // even inside other list items.)
    // 
    // In order to solve of unwanted lists in paragraphs with
    // hard-wrapped numerals, we allow only lists starting with `1` to
    // interrupt paragraphs.  Thus,
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5286-5292
    func testExample284() {
        let markdownTest =
        #####"""
        The number of windows in my house is
        14.  The number of doors is 6.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>The number of windows in my house is
      //14.  The number of doors is 6.</p>
        let normalizedCM = #####"""
        <p>The number of windows in my house is 14.  The number of doors is 6.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // We may still get an unintended result in cases like
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5296-5304
    func testExample285() {
        let markdownTest =
        #####"""
        The number of windows in my house is
        1.  The number of doors is 6.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>The number of windows in my house is</p>
      //<ol>
      //<li>The number of doors is 6.</li>
      //</ol>
        let normalizedCM = #####"""
        <p>The number of windows in my house is</p><ol><li>The number of doors is 6.</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // but this rule should prevent most spurious list captures.
    // 
    // There can be any number of blank lines between items:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5310-5329
    func testExample286() {
        let markdownTest =
        #####"""
        - foo
        
        - bar
        
        
        - baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //</li>
      //<li>
      //<p>bar</p>
      //</li>
      //<li>
      //<p>baz</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p></li><li><p>bar</p></li><li><p>baz</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5331-5353
    func testExample287() {
        let markdownTest =
        #####"""
        - foo
          - bar
            - baz
        
        
              bim\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo
      //<ul>
      //<li>bar
      //<ul>
      //<li>
      //<p>baz</p>
      //<p>bim</p>
      //</li>
      //</ul>
      //</li>
      //</ul>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo
        <ul><li>bar
        <ul><li><p>baz</p><p>bim</p></li></ul></li></ul></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // To separate consecutive lists of the same type, or to separate a
    // list from an indented code block that would otherwise be parsed
    // as a subparagraph of the final list item, you can insert a blank HTML
    // comment:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5361-5379
    func testExample288() {
        let markdownTest =
        #####"""
        - foo
        - bar
        
        <!-- -->
        
        - baz
        - bim\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li>bar</li>
      //</ul>
      //<!-- -->
      //<ul>
      //<li>baz</li>
      //<li>bim</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li>bar</li></ul><!-- --><ul><li>baz</li><li>bim</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5382-5405
    func testExample289() {
        let markdownTest =
        #####"""
        -   foo
        
            notcode
        
        -   foo
        
        <!-- -->
        
            code\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<p>notcode</p>
      //</li>
      //<li>
      //<p>foo</p>
      //</li>
      //</ul>
      //<!-- -->
      //<pre><code>code
      //</code></pre>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>notcode</p></li><li><p>foo</p></li></ul><!-- --><pre><code>code
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // List items need not be indented to the same level.  The following
    // list items will be treated as items at the same list level,
    // since none is indented enough to belong to the previous list
    // item:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5413-5431
    func testExample290() {
        let markdownTest =
        #####"""
        - a
         - b
          - c
           - d
          - e
         - f
        - g\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a</li>
      //<li>b</li>
      //<li>c</li>
      //<li>d</li>
      //<li>e</li>
      //<li>f</li>
      //<li>g</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a</li><li>b</li><li>c</li><li>d</li><li>e</li><li>f</li><li>g</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5434-5452
    func testExample291() {
        let markdownTest =
        #####"""
        1. a
        
          2. b
        
           3. c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>a</p>
      //</li>
      //<li>
      //<p>b</p>
      //</li>
      //<li>
      //<p>c</p>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>a</p></li><li><p>b</p></li><li><p>c</p></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note, however, that list items may not be indented more than
    // three spaces.  Here `- e` is treated as a paragraph continuation
    // line, because it is indented more than three spaces:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5458-5472
    func testExample292() {
        let markdownTest =
        #####"""
        - a
         - b
          - c
           - d
            - e\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a</li>
      //<li>b</li>
      //<li>c</li>
      //<li>d
      //- e</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a</li><li>b</li><li>c</li><li>d</li><li>e</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // And here, `3. c` is treated as in indented code block,
    // because it is indented four spaces and preceded by a
    // blank line.
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5478-5495
    func testExample293() {
        let markdownTest =
        #####"""
        1. a
        
          2. b
        
            3. c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>a</p>
      //</li>
      //<li>
      //<p>b</p>
      //</li>
      //</ol>
      //<pre><code>3. c
      //</code></pre>
        let normalizedCM = #####"""
        <ol><li><p>a</p></li><li><p>b</p></li><li><p>c</p></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is a loose list, because there is a blank line between
    // two of the list items:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5501-5518
    func testExample294() {
        let markdownTest =
        #####"""
        - a
        - b
        
        - c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>a</p>
      //</li>
      //<li>
      //<p>b</p>
      //</li>
      //<li>
      //<p>c</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>a</p></li><li><p>b</p></li><li><p>c</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // So is this, with a empty second item:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5523-5538
    func testExample295() {
        let markdownTest =
        #####"""
        * a
        *
        
        * c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>a</p>
      //</li>
      //<li></li>
      //<li>
      //<p>c</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>a</p></li><li></li><li><p>c</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These are loose lists, even though there is no space between the items,
    // because one of the items directly contains two block-level elements
    // with a blank line between them:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5545-5564
    func testExample296() {
        let markdownTest =
        #####"""
        - a
        - b
        
          c
        - d\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>a</p>
      //</li>
      //<li>
      //<p>b</p>
      //<p>c</p>
      //</li>
      //<li>
      //<p>d</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>a</p></li><li><p>b</p><p>c</p></li><li><p>d</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5567-5585
    func testExample297() {
        let markdownTest =
        #####"""
        - a
        - b
        
          [ref]: /url
        - d\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>a</p>
      //</li>
      //<li>
      //<p>b</p>
      //</li>
      //<li>
      //<p>d</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>a</p></li><li><p>b</p></li><li><p>d</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is a tight list, because the blank lines are in a code block:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5590-5609
    func testExample298() {
        let markdownTest =
        #####"""
        - a
        - ```
          b
        
        
          ```
        - c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a</li>
      //<li>
      //<pre><code>b
      //
      //
      //</code></pre>
      //</li>
      //<li>c</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a</li><li><pre><code>b
        
        
        </code></pre></li><li>c</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is a tight list, because the blank line is between two
    // paragraphs of a sublist.  So the sublist is loose while
    // the outer list is tight:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5616-5634
    func testExample299() {
        let markdownTest =
        #####"""
        - a
          - b
        
            c
        - d\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a
      //<ul>
      //<li>
      //<p>b</p>
      //<p>c</p>
      //</li>
      //</ul>
      //</li>
      //<li>d</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a
        <ul><li><p>b</p><p>c</p></li></ul></li><li>d</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is a tight list, because the blank line is inside the
    // block quote:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5640-5654
    func testExample300() {
        let markdownTest =
        #####"""
        * a
          > b
          >
        * c\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a
      //<blockquote>
      //<p>b</p>
      //</blockquote>
      //</li>
      //<li>c</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a
        <blockquote><p>b</p></blockquote></li><li>c</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This list is tight, because the consecutive block elements
    // are not separated by blank lines:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5660-5678
    func testExample301() {
        let markdownTest =
        #####"""
        - a
          > b
          ```
          c
          ```
        - d\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a
      //<blockquote>
      //<p>b</p>
      //</blockquote>
      //<pre><code>c
      //</code></pre>
      //</li>
      //<li>d</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a
        <blockquote><p>b</p></blockquote><pre><code>c
        </code></pre></li><li>d</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A single-paragraph list is tight:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5683-5689
    func testExample302() {
        let markdownTest =
        #####"""
        - a
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ul>
      //<li>a</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5692-5703
    func testExample303() {
        let markdownTest =
        #####"""
        - a
          - b\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>a
      //<ul>
      //<li>b</li>
      //</ul>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>a
        <ul><li>b</li></ul></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This list is loose, because of the blank line between the
    // two block elements in the list item:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5709-5723
    func testExample304() {
        let markdownTest =
        #####"""
        1. ```
           foo
           ```
        
           bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<pre><code>foo
      //</code></pre>
      //<p>bar</p>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><pre><code>foo
        </code></pre><p>bar</p></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here the outer list is loose, the inner list tight:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5728-5743
    func testExample305() {
        let markdownTest =
        #####"""
        * foo
          * bar
        
          baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<ul>
      //<li>bar</li>
      //</ul>
      //<p>baz</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><ul><li>bar</li></ul><p>baz</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5746-5771
    func testExample306() {
        let markdownTest =
        #####"""
        - a
          - b
          - c
        
        - d
          - e
          - f\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>a</p>
      //<ul>
      //<li>b</li>
      //<li>c</li>
      //</ul>
      //</li>
      //<li>
      //<p>d</p>
      //<ul>
      //<li>e</li>
      //<li>f</li>
      //</ul>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>a</p><ul><li>b</li><li>c</li></ul></li><li><p>d</p><ul><li>e</li><li>f</li></ul></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension ListsTests {
    static var allTests: Linux.TestList<ListsTests> {
        return [
        ("testExample281", testExample281),
        ("testExample282", testExample282),
        ("testExample283", testExample283),
        ("testExample284", testExample284),
        ("testExample285", testExample285),
        ("testExample286", testExample286),
        ("testExample287", testExample287),
        ("testExample288", testExample288),
        ("testExample289", testExample289),
        ("testExample290", testExample290),
        ("testExample291", testExample291),
        ("testExample292", testExample292),
        ("testExample293", testExample293),
        ("testExample294", testExample294),
        ("testExample295", testExample295),
        ("testExample296", testExample296),
        ("testExample297", testExample297),
        ("testExample298", testExample298),
        ("testExample299", testExample299),
        ("testExample300", testExample300),
        ("testExample301", testExample301),
        ("testExample302", testExample302),
        ("testExample303", testExample303),
        ("testExample304", testExample304),
        ("testExample305", testExample305),
        ("testExample306", testExample306)
        ]
    }
}