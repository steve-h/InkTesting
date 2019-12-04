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

final class TabsTests: XCTestCase {

    // ---
    // title: CommonMark Spec
    // author: John MacFarlane
    // version: 0.29
    // date: '2019-04-06'
    // license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0
    // ---
    // # Introduction
    // 
    // ## What is Markdown?
    // 
    // Markdown is a plain text format for writing structured documents,
    // based on conventions for indicating formatting in email
    // and usenet posts.  It was developed by John Gruber (with
    // help from Aaron Swartz) and released in 2004 in the form of a
    // [syntax description](http://daringfireball.net/projects/markdown/syntax)
    // and a Perl script (`Markdown.pl`) for converting Markdown to
    // HTML.  In the next decade, dozens of implementations were
    // developed in many languages.  Some extended the original
    // Markdown syntax with conventions for footnotes, tables, and
    // other document elements.  Some allowed Markdown documents to be
    // rendered in formats other than HTML.  Websites like Reddit,
    // StackOverflow, and GitHub had millions of people using Markdown.
    // And Markdown started to be used beyond the web, to author books,
    // articles, slide shows, letters, and lecture notes.
    // 
    // What distinguishes Markdown from many other lightweight markup
    // syntaxes, which are often easier to write, is its readability.
    // As Gruber writes:
    // 
    // > The overriding design goal for Markdown's formatting syntax is
    // > to make it as readable as possible. The idea is that a
    // > Markdown-formatted document should be publishable as-is, as
    // > plain text, without looking like it's been marked up with tags
    // > or formatting instructions.
    // > (<http://daringfireball.net/projects/markdown/>)
    // 
    // The point can be illustrated by comparing a sample of
    // [AsciiDoc](http://www.methods.co.nz/asciidoc/) with
    // an equivalent sample of Markdown.  Here is a sample of
    // AsciiDoc from the AsciiDoc manual:
    // 
    // ```
    // 1. List item one.
    // +
    // List item one continued with a second paragraph followed by an
    // Indented block.
    // +
    // .................
    // $ ls *.sh
    // $ mv *.sh ~/tmp
    // .................
    // +
    // List item continued with a third paragraph.
    // 
    // 2. List item two continued with an open block.
    // +
    // --
    // This paragraph is part of the preceding list item.
    // 
    // a. This list is nested and does not require explicit item
    // continuation.
    // +
    // This paragraph is part of the preceding list item.
    // 
    // b. List item b.
    // 
    // This paragraph belongs to item two of the outer list.
    // --
    // ```
    // 
    // And here is the equivalent in Markdown:
    // ```
    // 1.  List item one.
    // 
    //     List item one continued with a second paragraph followed by an
    //     Indented block.
    // 
    //         $ ls *.sh
    //         $ mv *.sh ~/tmp
    // 
    //     List item continued with a third paragraph.
    // 
    // 2.  List item two continued with an open block.
    // 
    //     This paragraph is part of the preceding list item.
    // 
    //     1. This list is nested and does not require explicit item continuation.
    // 
    //        This paragraph is part of the preceding list item.
    // 
    //     2. List item b.
    // 
    //     This paragraph belongs to item two of the outer list.
    // ```
    // 
    // The AsciiDoc version is, arguably, easier to write. You don't need
    // to worry about indentation.  But the Markdown version is much easier
    // to read.  The nesting of list items is apparent to the eye in the
    // source, not just in the processed document.
    // 
    // ## Why is a spec needed?
    // 
    // John Gruber's [canonical description of Markdown's
    // syntax](http://daringfireball.net/projects/markdown/syntax)
    // does not specify the syntax unambiguously.  Here are some examples of
    // questions it does not answer:
    // 
    // 1.  How much indentation is needed for a sublist?  The spec says that
    //     continuation paragraphs need to be indented four spaces, but is
    //     not fully explicit about sublists.  It is natural to think that
    //     they, too, must be indented four spaces, but `Markdown.pl` does
    //     not require that.  This is hardly a "corner case," and divergences
    //     between implementations on this issue often lead to surprises for
    //     users in real documents. (See [this comment by John
    //     Gruber](http://article.gmane.org/gmane.text.markdown.general/1997).)
    // 
    // 2.  Is a blank line needed before a block quote or heading?
    //     Most implementations do not require the blank line.  However,
    //     this can lead to unexpected results in hard-wrapped text, and
    //     also to ambiguities in parsing (note that some implementations
    //     put the heading inside the blockquote, while others do not).
    //     (John Gruber has also spoken [in favor of requiring the blank
    //     lines](http://article.gmane.org/gmane.text.markdown.general/2146).)
    // 
    // 3.  Is a blank line needed before an indented code block?
    //     (`Markdown.pl` requires it, but this is not mentioned in the
    //     documentation, and some implementations do not require it.)
    // 
    //     ``` markdown
    //     paragraph
    //         code?
    //     ```
    // 
    // 4.  What is the exact rule for determining when list items get
    //     wrapped in `<p>` tags?  Can a list be partially "loose" and partially
    //     "tight"?  What should we do with a list like this?
    // 
    //     ``` markdown
    //     1. one
    // 
    //     2. two
    //     3. three
    //     ```
    // 
    //     Or this?
    // 
    //     ``` markdown
    //     1.  one
    //         - a
    // 
    //         - b
    //     2.  two
    //     ```
    // 
    //     (There are some relevant comments by John Gruber
    //     [here](http://article.gmane.org/gmane.text.markdown.general/2554).)
    // 
    // 5.  Can list markers be indented?  Can ordered list markers be right-aligned?
    // 
    //     ``` markdown
    //      8. item 1
    //      9. item 2
    //     10. item 2a
    //     ```
    // 
    // 6.  Is this one list with a thematic break in its second item,
    //     or two lists separated by a thematic break?
    // 
    //     ``` markdown
    //     * a
    //     * * * * *
    //     * b
    //     ```
    // 
    // 7.  When list markers change from numbers to bullets, do we have
    //     two lists or one?  (The Markdown syntax description suggests two,
    //     but the perl scripts and many other implementations produce one.)
    // 
    //     ``` markdown
    //     1. fee
    //     2. fie
    //     -  foe
    //     -  fum
    //     ```
    // 
    // 8.  What are the precedence rules for the markers of inline structure?
    //     For example, is the following a valid link, or does the code span
    //     take precedence ?
    // 
    //     ``` markdown
    //     [a backtick (`)](/url) and [another backtick (`)](/url).
    //     ```
    // 
    // 9.  What are the precedence rules for markers of emphasis and strong
    //     emphasis?  For example, how should the following be parsed?
    // 
    //     ``` markdown
    //     *foo *bar* baz*
    //     ```
    // 
    // 10. What are the precedence rules between block-level and inline-level
    //     structure?  For example, how should the following be parsed?
    // 
    //     ``` markdown
    //     - `a long code span can contain a hyphen like this
    //       - and it can screw things up`
    //     ```
    // 
    // 11. Can list items include section headings?  (`Markdown.pl` does not
    //     allow this, but does allow blockquotes to include headings.)
    // 
    //     ``` markdown
    //     - # Heading
    //     ```
    // 
    // 12. Can list items be empty?
    // 
    //     ``` markdown
    //     * a
    //     *
    //     * b
    //     ```
    // 
    // 13. Can link references be defined inside block quotes or list items?
    // 
    //     ``` markdown
    //     > Blockquote [foo].
    //     >
    //     > [foo]: /url
    //     ```
    // 
    // 14. If there are multiple definitions for the same reference, which takes
    //     precedence?
    // 
    //     ``` markdown
    //     [foo]: /url1
    //     [foo]: /url2
    // 
    //     [foo][]
    //     ```
    // 
    // In the absence of a spec, early implementers consulted `Markdown.pl`
    // to resolve these ambiguities.  But `Markdown.pl` was quite buggy, and
    // gave manifestly bad results in many cases, so it was not a
    // satisfactory replacement for a spec.
    // 
    // Because there is no unambiguous spec, implementations have diverged
    // considerably.  As a result, users are often surprised to find that
    // a document that renders one way on one system (say, a GitHub wiki)
    // renders differently on another (say, converting to docbook using
    // pandoc).  To make matters worse, because nothing in Markdown counts
    // as a "syntax error," the divergence often isn't discovered right away.
    // 
    // ## About this document
    // 
    // This document attempts to specify Markdown syntax unambiguously.
    // It contains many examples with side-by-side Markdown and
    // HTML.  These are intended to double as conformance tests.  An
    // accompanying script `spec_tests.py` can be used to run the tests
    // against any Markdown program:
    // 
    //     python test/spec_tests.py --spec spec.txt --program PROGRAM
    // 
    // Since this document describes how Markdown is to be parsed into
    // an abstract syntax tree, it would have made sense to use an abstract
    // representation of the syntax tree instead of HTML.  But HTML is capable
    // of representing the structural distinctions we need to make, and the
    // choice of HTML for the tests makes it possible to run the tests against
    // an implementation without writing an abstract syntax tree renderer.
    // 
    // This document is generated from a text file, `spec.txt`, written
    // in Markdown with a small extension for the side-by-side tests.
    // The script `tools/makespec.py` can be used to convert `spec.txt` into
    // HTML or CommonMark (which can then be converted into other formats).
    // 
    // In the examples, the `→` character is used to represent tabs.
    // 
    // # Preliminaries
    // 
    // ## Characters and lines
    // 
    // Any sequence of [characters] is a valid CommonMark
    // document.
    // 
    // A [character](@) is a Unicode code point.  Although some
    // code points (for example, combining accents) do not correspond to
    // characters in an intuitive sense, all code points count as characters
    // for purposes of this spec.
    // 
    // This spec does not specify an encoding; it thinks of lines as composed
    // of [characters] rather than bytes.  A conforming parser may be limited
    // to a certain encoding.
    // 
    // A [line](@) is a sequence of zero or more [characters]
    // other than newline (`U+000A`) or carriage return (`U+000D`),
    // followed by a [line ending] or by the end of file.
    // 
    // A [line ending](@) is a newline (`U+000A`), a carriage return
    // (`U+000D`) not followed by a newline, or a carriage return and a
    // following newline.
    // 
    // A line containing no characters, or a line containing only spaces
    // (`U+0020`) or tabs (`U+0009`), is called a [blank line](@).
    // 
    // The following definitions of character classes will be used in this spec:
    // 
    // A [whitespace character](@) is a space
    // (`U+0020`), tab (`U+0009`), newline (`U+000A`), line tabulation (`U+000B`),
    // form feed (`U+000C`), or carriage return (`U+000D`).
    // 
    // [Whitespace](@) is a sequence of one or more [whitespace
    // characters].
    // 
    // A [Unicode whitespace character](@) is
    // any code point in the Unicode `Zs` general category, or a tab (`U+0009`),
    // carriage return (`U+000D`), newline (`U+000A`), or form feed
    // (`U+000C`).
    // 
    // [Unicode whitespace](@) is a sequence of one
    // or more [Unicode whitespace characters].
    // 
    // A [space](@) is `U+0020`.
    // 
    // A [non-whitespace character](@) is any character
    // that is not a [whitespace character].
    // 
    // An [ASCII control character](@) is a character between `U+0000–1F` (both
    // including) or `U+007F`.
    // 
    // An [ASCII punctuation character](@)
    // is `!`, `"`, `#`, `$`, `%`, `&`, `'`, `(`, `)`,
    // `*`, `+`, `,`, `-`, `.`, `/` (U+0021–2F), 
    // `:`, `;`, `<`, `=`, `>`, `?`, `@` (U+003A–0040),
    // `[`, `\`, `]`, `^`, `_`, `` ` `` (U+005B–0060), 
    // `{`, `|`, `}`, or `~` (U+007B–007E).
    // 
    // A [punctuation character](@) is an [ASCII
    // punctuation character] or anything in
    // the general Unicode categories  `Pc`, `Pd`, `Pe`, `Pf`, `Pi`, `Po`, or `Ps`.
    // 
    // ## Tabs
    // 
    // Tabs in lines are not expanded to [spaces].  However,
    // in contexts where whitespace helps to define block structure,
    // tabs behave as if they were replaced by spaces with a tab stop
    // of 4 characters.
    // 
    // Thus, for example, a tab can be used instead of four spaces
    // in an indented code block.  (Note, however, that internal
    // tabs are passed through as literal tabs, not expanded to
    // spaces.)
    // 
    // 
    //     
    // spec.txt lines 354-359
    func testExample1() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        	foo	baz		bim
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <pre><code>foo	baz		bim
        </code></pre>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 361-366
    func testExample2() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          	foo	baz		bim
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <pre><code>foo	baz		bim
        </code></pre>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 368-375
    func testExample3() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            a	a
            ὐ	a
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <pre><code>a	a
        ὐ	a
        </code></pre>
        """#####
        )
    }
    // 
    // In the following example, a continuation paragraph of a list
    // item is indented with a tab; this has exactly the same effect
    // as indentation with four spaces would:
    // 
    // 
    //     
    // spec.txt lines 381-392
    func testExample4() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          - foo
        
        	bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 394-406
    func testExample5() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        
        		bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li><p>foo</p><pre><code>  bar
        </code></pre></li></ul>
        """#####
        )
    }
    // 
    // Normally the `>` that begins a block quote may be followed
    // optionally by a space, which is not considered part of the
    // content.  In the following case `>` is followed by a tab,
    // which is treated as if it were expanded into three spaces.
    // Since one of these spaces is considered part of the
    // delimiter, `foo` is considered to be indented six spaces
    // inside the block quote context, so we get an indented
    // code block starting with two spaces.
    // 
    // 
    //     
    // spec.txt lines 417-424
    func testExample6() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >		foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <blockquote><pre><code>  foo
        </code></pre></blockquote>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 426-435
    func testExample7() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -		foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li><pre><code>  foo
        </code></pre></li></ul>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 438-445
    func testExample8() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            foo
        	bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <pre><code>foo
        bar
        </code></pre>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 447-463
    func testExample9() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         - foo
           - bar
        	 - baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li>foo
        <ul><li>bar
        <ul><li>baz</li></ul></li></ul></li></ul>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 465-469
    func testExample10() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        #	Foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <h1>Foo</h1>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 471-475
    func testExample11() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *	*	*	
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
}

extension TabsTests {
    static var allTests: Linux.TestList<TabsTests> {
        return [
        ("testExample1", testExample1),
        ("testExample2", testExample2),
        ("testExample3", testExample3),
        ("testExample4", testExample4),
        ("testExample5", testExample5),
        ("testExample6", testExample6),
        ("testExample7", testExample7),
        ("testExample8", testExample8),
        ("testExample9", testExample9),
        ("testExample10", testExample10),
        ("testExample11", testExample11)
        ]
    }
}