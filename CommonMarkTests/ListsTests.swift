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

final class ListsTests: XCTestCase {

    // 
    // 
    // ### Motivation
    // 
    // John Gruber's Markdown spec says the following about list items:
    // 
    // 1. "List markers typically start at the left margin, but may be indented
    //    by up to three spaces. List markers must be followed by one or more
    //    spaces or a tab."
    // 
    // 2. "To make lists look nice, you can wrap items with hanging indents....
    //    But if you don't want to, you don't have to."
    // 
    // 3. "List items may consist of multiple paragraphs. Each subsequent
    //    paragraph in a list item must be indented by either 4 spaces or one
    //    tab."
    // 
    // 4. "It looks nice if you indent every line of the subsequent paragraphs,
    //    but here again, Markdown will allow you to be lazy."
    // 
    // 5. "To put a blockquote within a list item, the blockquote's `>`
    //    delimiters need to be indented."
    // 
    // 6. "To put a code block within a list item, the code block needs to be
    //    indented twice — 8 spaces or two tabs."
    // 
    // These rules specify that a paragraph under a list item must be indented
    // four spaces (presumably, from the left margin, rather than the start of
    // the list marker, but this is not said), and that code under a list item
    // must be indented eight spaces instead of the usual four.  They also say
    // that a block quote must be indented, but not by how much; however, the
    // example given has four spaces indentation.  Although nothing is said
    // about other kinds of block-level content, it is certainly reasonable to
    // infer that *all* block elements under a list item, including other
    // lists, must be indented four spaces.  This principle has been called the
    // *four-space rule*.
    // 
    // The four-space rule is clear and principled, and if the reference
    // implementation `Markdown.pl` had followed it, it probably would have
    // become the standard.  However, `Markdown.pl` allowed paragraphs and
    // sublists to start with only two spaces indentation, at least on the
    // outer level.  Worse, its behavior was inconsistent: a sublist of an
    // outer-level list needed two spaces indentation, but a sublist of this
    // sublist needed three spaces.  It is not surprising, then, that different
    // implementations of Markdown have developed very different rules for
    // determining what comes under a list item.  (Pandoc and python-Markdown,
    // for example, stuck with Gruber's syntax description and the four-space
    // rule, while discount, redcarpet, marked, PHP Markdown, and others
    // followed `Markdown.pl`'s behavior more closely.)
    // 
    // Unfortunately, given the divergences between implementations, there
    // is no way to give a spec for list items that will be guaranteed not
    // to break any existing documents.  However, the spec given here should
    // correctly handle lists formatted with either the four-space rule or
    // the more forgiving `Markdown.pl` behavior, provided they are laid out
    // in a way that is natural for a human to read.
    // 
    // The strategy here is to let the width and indentation of the list marker
    // determine the indentation necessary for blocks to fall under the list
    // item, rather than having a fixed and arbitrary number.  The writer can
    // think of the body of the list item as a unit which gets indented to the
    // right enough to fit the list marker (and any indentation on the list
    // marker).  (The laziness rule, #5, then allows continuation lines to be
    // unindented if needed.)
    // 
    // This rule is superior, we claim, to any rule requiring a fixed level of
    // indentation from the margin.  The four-space rule is clear but
    // unnatural. It is quite unintuitive that
    // 
    // ``` markdown
    // - foo
    // 
    //   bar
    // 
    //   - baz
    // ```
    // 
    // should be parsed as two lists with an intervening paragraph,
    // 
    // ``` html
    // <ul>
    // <li>foo</li>
    // </ul>
    // <p>bar</p>
    // <ul>
    // <li>baz</li>
    // </ul>
    // ```
    // 
    // as the four-space rule demands, rather than a single list,
    // 
    // ``` html
    // <ul>
    // <li>
    // <p>foo</p>
    // <p>bar</p>
    // <ul>
    // <li>baz</li>
    // </ul>
    // </li>
    // </ul>
    // ```
    // 
    // The choice of four spaces is arbitrary.  It can be learned, but it is
    // not likely to be guessed, and it trips up beginners regularly.
    // 
    // Would it help to adopt a two-space rule?  The problem is that such
    // a rule, together with the rule allowing 1--3 spaces indentation of the
    // initial list marker, allows text that is indented *less than* the
    // original list marker to be included in the list item. For example,
    // `Markdown.pl` parses
    // 
    // ``` markdown
    //    - one
    // 
    //   two
    // ```
    // 
    // as a single list item, with `two` a continuation paragraph:
    // 
    // ``` html
    // <ul>
    // <li>
    // <p>one</p>
    // <p>two</p>
    // </li>
    // </ul>
    // ```
    // 
    // and similarly
    // 
    // ``` markdown
    // >   - one
    // >
    // >  two
    // ```
    // 
    // as
    // 
    // ``` html
    // <blockquote>
    // <ul>
    // <li>
    // <p>one</p>
    // <p>two</p>
    // </li>
    // </ul>
    // </blockquote>
    // ```
    // 
    // This is extremely unintuitive.
    // 
    // Rather than requiring a fixed indent from the margin, we could require
    // a fixed indent (say, two spaces, or even one space) from the list marker (which
    // may itself be indented).  This proposal would remove the last anomaly
    // discussed.  Unlike the spec presented above, it would count the following
    // as a list item with a subparagraph, even though the paragraph `bar`
    // is not indented as far as the first paragraph `foo`:
    // 
    // ``` markdown
    //  10. foo
    // 
    //    bar  
    // ```
    // 
    // Arguably this text does read like a list item with `bar` as a subparagraph,
    // which may count in favor of the proposal.  However, on this proposal indented
    // code would have to be indented six spaces after the list marker.  And this
    // would break a lot of existing Markdown, which has the pattern:
    // 
    // ``` markdown
    // 1.  foo
    // 
    //         indented code
    // ```
    // 
    // where the code is indented eight spaces.  The spec above, by contrast, will
    // parse this text as expected, since the code block's indentation is measured
    // from the beginning of `foo`.
    // 
    // The one case that needs special treatment is a list item that *starts*
    // with indented code.  How much indentation is required in that case, since
    // we don't have a "first paragraph" to measure from?  Rule #2 simply stipulates
    // that in such cases, we require one space indentation from the list marker
    // (and then the normal four spaces for the indented code).  This will match the
    // four-space rule in cases where the list marker plus its initial indentation
    // takes four spaces (a common case), but diverge in other cases.
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4894-4906
    func testExample271() {
        var markdownTest =
        #####"""
        - foo
        - bar
        + baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4909-4921
    func testExample272() {
        var markdownTest =
        #####"""
        1. foo
        2. bar
        3) baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // In CommonMark, a list can interrupt a paragraph. That is,
    // no blank line is needed to separate a paragraph from a following
    // list:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4928-4938
    func testExample273() {
        var markdownTest =
        #####"""
        Foo
        - bar
        - baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5005-5011
    func testExample274() {
        var markdownTest =
        #####"""
        The number of windows in my house is
        14.  The number of doors is 6.
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>The number of windows in my house is
      //14.  The number of doors is 6.</p>
        let normalizedCM = #####"""
        <p>The number of windows in my house is 14.  The number of doors is 6.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // We may still get an unintended result in cases like
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5015-5023
    func testExample275() {
        var markdownTest =
        #####"""
        The number of windows in my house is
        1.  The number of doors is 6.
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>The number of windows in my house is</p>
      //<ol>
      //<li>The number of doors is 6.</li>
      //</ol>
        let normalizedCM = #####"""
        <p>The number of windows in my house is</p><ol><li>The number of doors is 6.</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // but this rule should prevent most spurious list captures.
    // 
    // There can be any number of blank lines between items:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5029-5048
    func testExample276() {
        var markdownTest =
        #####"""
        - foo
        
        - bar
        
        
        - baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5050-5072
    func testExample277() {
        var markdownTest =
        #####"""
        - foo
          - bar
            - baz
        
        
              bim
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // To separate consecutive lists of the same type, or to separate a
    // list from an indented code block that would otherwise be parsed
    // as a subparagraph of the final list item, you can insert a blank HTML
    // comment:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5080-5098
    func testExample278() {
        var markdownTest =
        #####"""
        - foo
        - bar
        
        <!-- -->
        
        - baz
        - bim
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5101-5124
    func testExample279() {
        var markdownTest =
        #####"""
        -   foo
        
            notcode
        
        -   foo
        
        <!-- -->
        
            code
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // List items need not be indented to the same level.  The following
    // list items will be treated as items at the same list level,
    // since none is indented enough to belong to the previous list
    // item:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5132-5150
    func testExample280() {
        var markdownTest =
        #####"""
        - a
         - b
          - c
           - d
          - e
         - f
        - g
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5153-5171
    func testExample281() {
        var markdownTest =
        #####"""
        1. a
        
          2. b
        
           3. c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // Note, however, that list items may not be indented more than
    // three spaces.  Here `- e` is treated as a paragraph continuation
    // line, because it is indented more than three spaces:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5177-5191
    func testExample282() {
        var markdownTest =
        #####"""
        - a
         - b
          - c
           - d
            - e
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // And here, `3. c` is treated as in indented code block,
    // because it is indented four spaces and preceded by a
    // blank line.
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5197-5214
    func testExample283() {
        var markdownTest =
        #####"""
        1. a
        
          2. b
        
            3. c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This is a loose list, because there is a blank line between
    // two of the list items:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5220-5237
    func testExample284() {
        var markdownTest =
        #####"""
        - a
        - b
        
        - c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // So is this, with a empty second item:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5242-5257
    func testExample285() {
        var markdownTest =
        #####"""
        * a
        *
        
        * c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // These are loose lists, even though there is no space between the items,
    // because one of the items directly contains two block-level elements
    // with a blank line between them:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5264-5283
    func testExample286() {
        var markdownTest =
        #####"""
        - a
        - b
        
          c
        - d
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5286-5304
    func testExample287() {
        var markdownTest =
        #####"""
        - a
        - b
        
          [ref]: /url
        - d
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This is a tight list, because the blank lines are in a code block:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5309-5328
    func testExample288() {
        var markdownTest =
        #####"""
        - a
        - ```
          b
        
        
          ```
        - c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This is a tight list, because the blank line is between two
    // paragraphs of a sublist.  So the sublist is loose while
    // the outer list is tight:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5335-5353
    func testExample289() {
        var markdownTest =
        #####"""
        - a
          - b
        
            c
        - d
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This is a tight list, because the blank line is inside the
    // block quote:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5359-5373
    func testExample290() {
        var markdownTest =
        #####"""
        * a
          > b
          >
        * c
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This list is tight, because the consecutive block elements
    // are not separated by blank lines:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5379-5397
    func testExample291() {
        var markdownTest =
        #####"""
        - a
          > b
          ```
          c
          ```
        - d
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A single-paragraph list is tight:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5402-5408
    func testExample292() {
        var markdownTest =
        #####"""
        - a
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5411-5422
    func testExample293() {
        var markdownTest =
        #####"""
        - a
          - b
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // This list is loose, because of the blank line between the
    // two block elements in the list item:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5428-5442
    func testExample294() {
        var markdownTest =
        #####"""
        1. ```
           foo
           ```
        
           bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // Here the outer list is loose, the inner list tight:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5447-5462
    func testExample295() {
        var markdownTest =
        #####"""
        * foo
          * bar
        
          baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5465-5490
    func testExample296() {
        var markdownTest =
        #####"""
        - a
          - b
          - c
        
        - d
          - e
          - f
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
        ("testExample271", testExample271),
        ("testExample272", testExample272),
        ("testExample273", testExample273),
        ("testExample274", testExample274),
        ("testExample275", testExample275),
        ("testExample276", testExample276),
        ("testExample277", testExample277),
        ("testExample278", testExample278),
        ("testExample279", testExample279),
        ("testExample280", testExample280),
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
        ("testExample296", testExample296)
        ]
    }
}