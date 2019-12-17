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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3344-3354
    func testExample198() {
        var markdownTest =
        #####"""
        > # Foo
        > bar
        > baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<h1>Foo</h1>
      //<p>bar
      //baz</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar baz</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // The spaces after the `>` characters can be omitted:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3359-3369
    func testExample199() {
        var markdownTest =
        #####"""
        ># Foo
        >bar
        > baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<h1>Foo</h1>
      //<p>bar
      //baz</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar baz</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // The `>` characters can be indented 1-3 spaces:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3374-3384
    func testExample200() {
        var markdownTest =
        #####"""
           > # Foo
           > bar
         > baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<h1>Foo</h1>
      //<p>bar
      //baz</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar baz</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Four spaces gives us a code block:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3389-3398
    func testExample201() {
        var markdownTest =
        #####"""
            > # Foo
            > bar
            > baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>&gt; # Foo
      //&gt; bar
      //&gt; baz
      //</code></pre>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3404-3414
    func testExample202() {
        var markdownTest =
        #####"""
        > # Foo
        > bar
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<h1>Foo</h1>
      //<p>bar
      //baz</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><h1>Foo</h1><p>bar baz</p></blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3420-3430
    func testExample203() {
        var markdownTest =
        #####"""
        > bar
        baz
        > foo
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>bar
      //baz
      //foo</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><p>bar baz foo</p></blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3444-3452
    func testExample204() {
        var markdownTest =
        #####"""
        > foo
        ---
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo</p>
      //</blockquote>
      //<hr />
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3464-3476
    func testExample205() {
        var markdownTest =
        #####"""
        > - foo
        - bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<ul>
      //<li>foo</li>
      //</ul>
      //</blockquote>
      //<ul>
      //<li>bar</li>
      //</ul>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3482-3492
    func testExample206() {
        var markdownTest =
        #####"""
        >     foo
            bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<pre><code>foo
      //</code></pre>
      //</blockquote>
      //<pre><code>bar
      //</code></pre>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3495-3505
    func testExample207() {
        var markdownTest =
        #####"""
        > ```
        foo
        ```
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<pre><code></code></pre>
      //</blockquote>
      //<p>foo</p>
      //<pre><code></code></pre>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3511-3519
    func testExample208() {
        var markdownTest =
        #####"""
        > foo
            - bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo
      //- bar</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><p>foo - bar</p></blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3535-3540
    func testExample209() {
        var markdownTest =
        #####"""
        >
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3543-3550
    func testExample210() {
        var markdownTest =
        #####"""
        >
        >  
        > 
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3555-3563
    func testExample211() {
        var markdownTest =
        #####"""
        >
        > foo
        >  
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo</p>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3568-3579
    func testExample212() {
        var markdownTest =
        #####"""
        > foo
        
        > bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo</p>
      //</blockquote>
      //<blockquote>
      //<p>bar</p>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3590-3598
    func testExample213() {
        var markdownTest =
        #####"""
        > foo
        > bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo
      //bar</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><p>foo bar</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // To get a block quote with two paragraphs, use:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3603-3612
    func testExample214() {
        var markdownTest =
        #####"""
        > foo
        >
        > bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>foo</p>
      //<p>bar</p>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3617-3625
    func testExample215() {
        var markdownTest =
        #####"""
        foo
        > bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo</p>
      //<blockquote>
      //<p>bar</p>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3631-3643
    func testExample216() {
        var markdownTest =
        #####"""
        > aaa
        ***
        > bbb
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>aaa</p>
      //</blockquote>
      //<hr />
      //<blockquote>
      //<p>bbb</p>
      //</blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3649-3657
    func testExample217() {
        var markdownTest =
        #####"""
        > bar
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>bar
      //baz</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><p>bar baz</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3660-3669
    func testExample218() {
        var markdownTest =
        #####"""
        > bar
        
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>bar</p>
      //</blockquote>
      //<p>baz</p>
        let normalizedCM = #####"""
        <blockquote><p>bar</p></blockquote><p>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3672-3681
    func testExample219() {
        var markdownTest =
        #####"""
        > bar
        >
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<p>bar</p>
      //</blockquote>
      //<p>baz</p>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3688-3700
    func testExample220() {
        var markdownTest =
        #####"""
        > > > foo
        bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<blockquote>
      //<blockquote>
      //<p>foo
      //bar</p>
      //</blockquote>
      //</blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><blockquote><blockquote><p>foo bar</p></blockquote></blockquote></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3703-3717
    func testExample221() {
        var markdownTest =
        #####"""
        >>> foo
        > bar
        >>baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<blockquote>
      //<blockquote>
      //<p>foo
      //bar
      //baz</p>
      //</blockquote>
      //</blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><blockquote><blockquote><p>foo bar baz</p></blockquote></blockquote></blockquote>
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3725-3737
    func testExample222() {
        var markdownTest =
        #####"""
        >     code
        
        >    not code
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<pre><code>code
      //</code></pre>
      //</blockquote>
      //<blockquote>
      //<p>not code</p>
      //</blockquote>
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
        ("testExample198", testExample198),
        ("testExample199", testExample199),
        ("testExample200", testExample200),
        ("testExample201", testExample201),
        ("testExample202", testExample202),
        ("testExample203", testExample203),
        ("testExample204", testExample204),
        ("testExample205", testExample205),
        ("testExample206", testExample206),
        ("testExample207", testExample207),
        ("testExample208", testExample208),
        ("testExample209", testExample209),
        ("testExample210", testExample210),
        ("testExample211", testExample211),
        ("testExample212", testExample212),
        ("testExample213", testExample213),
        ("testExample214", testExample214),
        ("testExample215", testExample215),
        ("testExample216", testExample216),
        ("testExample217", testExample217),
        ("testExample218", testExample218),
        ("testExample219", testExample219),
        ("testExample220", testExample220),
        ("testExample221", testExample221),
        ("testExample222", testExample222)
        ]
    }
}