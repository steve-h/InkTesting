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

final class BlockQuotesTests: XCTestCase {

    // 
    // 
    // 
    // # Container blocks
    // 
    // A [container block](#container-blocks) is a block that has other
    // blocks as its contents.  There are two basic kinds of container blocks:
    // [block quotes] and [list items].
    // [Lists] are meta-containers for [list items].
    // 
    // We define the syntax for container blocks recursively.  The general
    // form of the definition is:
    // 
    // > If X is a sequence of blocks, then the result of
    // > transforming X in such-and-such a way is a container of type Y
    // > with these blocks as its content.
    // 
    // So, we explain what counts as a block quote or list item by explaining
    // how these can be *generated* from their contents. This should suffice
    // to define the syntax, although it does not give a recipe for *parsing*
    // these constructions.  (A recipe is provided below in the section entitled
    // [A parsing strategy](#appendix-a-parsing-strategy).)
    // 
    // ## Block quotes
    // 
    // A [block quote marker](@)
    // consists of 0-3 spaces of initial indent, plus (a) the character `>` together
    // with a following space, or (b) a single character `>` not followed by a space.
    // 
    // The following rules define [block quotes]:
    // 
    // 1.  **Basic case.**  If a string of lines *Ls* constitute a sequence
    //     of blocks *Bs*, then the result of prepending a [block quote
    //     marker] to the beginning of each line in *Ls*
    //     is a [block quote](#block-quotes) containing *Bs*.
    // 
    // 2.  **Laziness.**  If a string of lines *Ls* constitute a [block
    //     quote](#block-quotes) with contents *Bs*, then the result of deleting
    //     the initial [block quote marker] from one or
    //     more lines in which the next [non-whitespace character] after the [block
    //     quote marker] is [paragraph continuation
    //     text] is a block quote with *Bs* as its content.
    //     [Paragraph continuation text](@) is text
    //     that will be parsed as part of the content of a paragraph, but does
    //     not occur at the beginning of the paragraph.
    // 
    // 3.  **Consecutiveness.**  A document cannot contain two [block
    //     quotes] in a row unless there is a [blank line] between them.
    // 
    // Nothing else counts as a [block quote](#block-quotes).
    // 
    // Here is a simple example:
    // 
    // 
    //     
    // spec.txt lines 3687-3697
    func testExample228() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > # Foo
        > bar
        > baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar
        baz</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The spaces after the `>` characters can be omitted:
    // 
    // 
    //     
    // spec.txt lines 3702-3712
    func testExample229() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ># Foo
        >bar
        > baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar
        baz</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The `>` characters can be indented 1-3 spaces:
    // 
    // 
    //     
    // spec.txt lines 3717-3727
    func testExample230() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           > # Foo
           > bar
         > baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar
        baz</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Four spaces gives us a code block:
    // 
    // 
    //     
    // spec.txt lines 3732-3741
    func testExample231() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            > # Foo
            > bar
            > baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <pre><code>&gt; # Foo
        &gt; bar
        &gt; baz
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The Laziness clause allows us to omit the `>` before
    // [paragraph continuation text]:
    // 
    // 
    //     
    // spec.txt lines 3747-3757
    func testExample232() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > # Foo
        > bar
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar
        baz</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A block quote can contain some lazy and some non-lazy
    // continuation lines:
    // 
    // 
    //     
    // spec.txt lines 3763-3773
    func testExample233() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > bar
        baz
        > foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>bar
        baz
        foo</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Laziness only applies to lines that would have been continuations of
    // paragraphs had they been prepended with [block quote markers].
    // For example, the `> ` cannot be omitted in the second line of
    // 
    // ``` markdown
    // > foo
    // > ---
    // ```
    // 
    // without changing the meaning:
    // 
    // 
    //     
    // spec.txt lines 3787-3795
    func testExample234() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo</p></blockquote><hr>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Similarly, if we omit the `> ` in the second line of
    // 
    // ``` markdown
    // > - foo
    // > - bar
    // ```
    // 
    // then the block quote ends after the first line:
    // 
    // 
    //     
    // spec.txt lines 3807-3819
    func testExample235() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > - foo
        - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><ul><li>foo</li></ul></blockquote><ul><li>bar</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // For the same reason, we can't omit the `> ` in front of
    // subsequent lines of an indented or fenced code block:
    // 
    // 
    //     
    // spec.txt lines 3825-3835
    func testExample236() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >     foo
            bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><pre><code>foo
        </code></pre></blockquote><pre><code>bar
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3838-3848
    func testExample237() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > ```
        foo
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><pre><code></code></pre></blockquote><p>foo</p><pre><code></code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that in the following case, we have a [lazy
    // continuation line]:
    // 
    // 
    //     
    // spec.txt lines 3854-3862
    func testExample238() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
            - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo
        - bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // To see why, note that in
    // 
    // ```markdown
    // > foo
    // >     - bar
    // ```
    // 
    // the `- bar` is indented too far to start a list, and can't
    // be an indented code block because indented code blocks cannot
    // interrupt paragraphs, so it is [paragraph continuation text].
    // 
    // A block quote can be empty:
    // 
    // 
    //     
    // spec.txt lines 3878-3883
    func testExample239() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3886-3893
    func testExample240() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >
        >  
        > 
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A block quote can have initial or final blank lines:
    // 
    // 
    //     
    // spec.txt lines 3898-3906
    func testExample241() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >
        > foo
        >  
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A blank line always separates block quotes:
    // 
    // 
    //     
    // spec.txt lines 3911-3922
    func testExample242() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo</p></blockquote><blockquote><p>bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // (Most current Markdown implementations, including John Gruber's
    // original `Markdown.pl`, will parse this example as a single block quote
    // with two paragraphs.  But it seems better to allow the author to decide
    // whether two block quotes or one are wanted.)
    // 
    // Consecutiveness means that if we put these block quotes together,
    // we get a single block quote:
    // 
    // 
    //     
    // spec.txt lines 3933-3941
    func testExample243() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo
        bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // To get a block quote with two paragraphs, use:
    // 
    // 
    //     
    // spec.txt lines 3946-3955
    func testExample244() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        >
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>foo</p><p>bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Block quotes can interrupt paragraphs:
    // 
    // 
    //     
    // spec.txt lines 3960-3968
    func testExample245() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo</p><blockquote><p>bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // In general, blank lines are not needed before or after block
    // quotes:
    // 
    // 
    //     
    // spec.txt lines 3974-3986
    func testExample246() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > aaa
        ***
        > bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>aaa</p></blockquote><hr><blockquote><p>bbb</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, because of laziness, a blank line is needed between
    // a block quote and a following paragraph:
    // 
    // 
    //     
    // spec.txt lines 3992-4000
    func testExample247() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > bar
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>bar
        baz</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4003-4012
    func testExample248() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > bar
        
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>bar</p></blockquote><p>baz</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4015-4024
    func testExample249() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > bar
        >
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><p>bar</p></blockquote><p>baz</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // It is a consequence of the Laziness rule that any number
    // of initial `>`s may be omitted on a continuation line of a
    // nested block quote:
    // 
    // 
    //     
    // spec.txt lines 4031-4043
    func testExample250() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > > > foo
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><blockquote><blockquote><p>foo
        bar</p></blockquote></blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4046-4060
    func testExample251() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >>> foo
        > bar
        >>baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><blockquote><blockquote><p>foo
        bar
        baz</p></blockquote></blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // When including an indented code block in a block quote,
    // remember that the [block quote marker] includes
    // both the `>` and a following space.  So *five spaces* are needed after
    // the `>`:
    // 
    // 
    //     
    // spec.txt lines 4068-4080
    func testExample252() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >     code
        
        >    not code
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><pre><code>code
        </code></pre></blockquote><blockquote><p>not code</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension BlockQuotesTests {
    static var allTests: Linux.TestList<BlockQuotesTests> {
        return [
        ("testExample228", testExample228),
        ("testExample229", testExample229),
        ("testExample230", testExample230),
        ("testExample231", testExample231),
        ("testExample232", testExample232),
        ("testExample233", testExample233),
        ("testExample234", testExample234),
        ("testExample235", testExample235),
        ("testExample236", testExample236),
        ("testExample237", testExample237),
        ("testExample238", testExample238),
        ("testExample239", testExample239),
        ("testExample240", testExample240),
        ("testExample241", testExample241),
        ("testExample242", testExample242),
        ("testExample243", testExample243),
        ("testExample244", testExample244),
        ("testExample245", testExample245),
        ("testExample246", testExample246),
        ("testExample247", testExample247),
        ("testExample248", testExample248),
        ("testExample249", testExample249),
        ("testExample250", testExample250),
        ("testExample251", testExample251),
        ("testExample252", testExample252)
        ]
    }
}