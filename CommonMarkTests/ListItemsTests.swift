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

final class ListItemsTests: XCTestCase {

    // 
    // 
    // 
    // ## List items
    // 
    // A [list marker](@) is a
    // [bullet list marker] or an [ordered list marker].
    // 
    // A [bullet list marker](@)
    // is a `-`, `+`, or `*` character.
    // 
    // An [ordered list marker](@)
    // is a sequence of 1--9 arabic digits (`0-9`), followed by either a
    // `.` character or a `)` character.  (The reason for the length
    // limit is that with 10 digits we start seeing integer overflows
    // in some browsers.)
    // 
    // The following rules define [list items]:
    // 
    // 1.  **Basic case.**  If a sequence of lines *Ls* constitute a sequence of
    //     blocks *Bs* starting with a [non-whitespace character], and *M* is a
    //     list marker of width *W* followed by 1 ≤ *N* ≤ 4 spaces, then the result
    //     of prepending *M* and the following spaces to the first line of
    //     *Ls*, and indenting subsequent lines of *Ls* by *W + N* spaces, is a
    //     list item with *Bs* as its contents.  The type of the list item
    //     (bullet or ordered) is determined by the type of its list marker.
    //     If the list item is ordered, then it is also assigned a start
    //     number, based on the ordered list marker.
    // 
    //     Exceptions:
    // 
    //     1. When the first list item in a [list] interrupts
    //        a paragraph---that is, when it starts on a line that would
    //        otherwise count as [paragraph continuation text]---then (a)
    //        the lines *Ls* must not begin with a blank line, and (b) if
    //        the list item is ordered, the start number must be 1.
    //     2. If any line is a [thematic break][thematic breaks] then
    //        that line is not a list item.
    // 
    // For example, let *Ls* be the lines
    // 
    // 
    //     
    // spec.txt lines 4122-4137
    func testExample253() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        A paragraph
        with two lines.
        
            indented code
        
        > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // And let *M* be the marker `1.`, and *N* = 2.  Then rule #1 says
    // that the following is an ordered list item with start number 1,
    // and the same contents as *Ls*:
    // 
    // 
    //     
    // spec.txt lines 4144-4163
    func testExample254() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1.  A paragraph
            with two lines.
        
                indented code
        
            > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The most important thing to notice is that the position of
    // the text after the list marker determines how much indentation
    // is needed in subsequent blocks in the list item.  If the list
    // marker takes up two spaces, and there are three spaces between
    // the list marker and the next [non-whitespace character], then blocks
    // must be indented five spaces in order to fall under the list
    // item.
    // 
    // Here are some examples showing how far content must be indented to be
    // put under the list item:
    // 
    // 
    //     
    // spec.txt lines 4177-4186
    func testExample255() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - one
        
         two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>one</li></ul><p>two</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4189-4200
    func testExample256() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - one
        
          two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>one</p><p>two</p></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4203-4213
    func testExample257() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         -    one
        
             two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>one</li></ul><pre><code> two
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4216-4227
    func testExample258() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         -    one
        
              two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>one</p><p>two</p></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // It is tempting to think of this in terms of columns:  the continuation
    // blocks must be indented at least to the column of the first
    // [non-whitespace character] after the list marker. However, that is not quite right.
    // The spaces after the list marker determine how much relative indentation
    // is needed.  Which column this indentation reaches will depend on
    // how the list item is embedded in other constructions, as shown by
    // this example:
    // 
    // 
    //     
    // spec.txt lines 4238-4253
    func testExample259() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           > > 1.  one
        >>
        >>     two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><blockquote><ol><li><p>one</p><p>two</p></li></ol></blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here `two` occurs in the same column as the list marker `1.`,
    // but is actually contained in the list item, because there is
    // sufficient indentation after the last containing blockquote marker.
    // 
    // The converse is also possible.  In the following example, the word `two`
    // occurs far to the right of the initial text of the list item, `one`, but
    // it is not considered part of the list item, because it is not indented
    // far enough past the blockquote marker:
    // 
    // 
    //     
    // spec.txt lines 4265-4278
    func testExample260() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        >>- one
        >>
          >  > two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><blockquote><ul><li>one</li></ul><p>two</p></blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that at least one space is needed between the list marker and
    // any following content, so these are not list items:
    // 
    // 
    //     
    // spec.txt lines 4284-4291
    func testExample261() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -one
        
        2.two
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>-one</p><p>2.two</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list item may contain blocks that are separated by more than
    // one blank line.
    // 
    // 
    //     
    // spec.txt lines 4297-4309
    func testExample262() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        
        
          bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list item may contain any kind of block:
    // 
    // 
    //     
    // spec.txt lines 4314-4336
    func testExample263() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1.  foo
        
            ```
            bar
            ```
        
            baz
        
            > bam
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>foo</p><pre><code>bar
        </code></pre><p>baz</p><blockquote><p>bam</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list item that contains an indented code block will preserve
    // empty lines within the code block verbatim.
    // 
    // 
    //     
    // spec.txt lines 4342-4360
    func testExample264() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - Foo
        
              bar
        
        
              baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>Foo</p><pre><code>bar
        
        
        baz
        </code></pre></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Note that ordered list start numbers must be nine digits or less:
    // 
    // 
    //     
    // spec.txt lines 4364-4370
    func testExample265() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        123456789. ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="123456789"><li>ok</li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4373-4377
    func testExample266() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1234567890. not ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>1234567890. not ok</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A start number may begin with 0s:
    // 
    // 
    //     
    // spec.txt lines 4382-4388
    func testExample267() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        0. ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="0"><li>ok</li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4391-4397
    func testExample268() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        003. ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="3"><li>ok</li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A start number may not be negative:
    // 
    // 
    //     
    // spec.txt lines 4402-4406
    func testExample269() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -1. not ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>-1. not ok</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    // 2.  **Item starting with indented code.**  If a sequence of lines *Ls*
    //     constitute a sequence of blocks *Bs* starting with an indented code
    //     block, and *M* is a list marker of width *W* followed by
    //     one space, then the result of prepending *M* and the following
    //     space to the first line of *Ls*, and indenting subsequent lines of
    //     *Ls* by *W + 1* spaces, is a list item with *Bs* as its contents.
    //     If a line is empty, then it need not be indented.  The type of the
    //     list item (bullet or ordered) is determined by the type of its list
    //     marker.  If the list item is ordered, then it is also assigned a
    //     start number, based on the ordered list marker.
    // 
    // An indented code block will have to be indented four spaces beyond
    // the edge of the region where text will be included in the list item.
    // In the following case that is 6 spaces:
    // 
    // 
    //     
    // spec.txt lines 4425-4437
    func testExample270() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        
              bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>foo</p><pre><code>bar
        </code></pre></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // And in this case it is 11 spaces:
    // 
    // 
    //     
    // spec.txt lines 4442-4454
    func testExample271() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          10.  foo
        
                   bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="10"><li><p>foo</p><pre><code>bar
        </code></pre></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // If the *first* block in the list item is an indented code block,
    // then by rule #2, the contents must be indented *one* space after the
    // list marker:
    // 
    // 
    //     
    // spec.txt lines 4461-4473
    func testExample272() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            indented code
        
        paragraph
        
            more code
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <pre><code>indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4476-4492
    func testExample273() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1.     indented code
        
           paragraph
        
               more code
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><pre><code>indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that an additional space indent is interpreted as space
    // inside the code block:
    // 
    // 
    //     
    // spec.txt lines 4498-4514
    func testExample274() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1.      indented code
        
           paragraph
        
               more code
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><pre><code> indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that rules #1 and #2 only apply to two cases:  (a) cases
    // in which the lines to be included in a list item begin with a
    // [non-whitespace character], and (b) cases in which
    // they begin with an indented code
    // block.  In a case like the following, where the first block begins with
    // a three-space indent, the rules do not allow us to form a list item by
    // indenting the whole thing and prepending a list marker:
    // 
    // 
    //     
    // spec.txt lines 4525-4532
    func testExample275() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           foo
        
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo</p><p>bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4535-4544
    func testExample276() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -    foo
        
          bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li></ul><p>bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a significant restriction, because when a block begins
    // with 1-3 spaces indent, the indentation can always be removed without
    // a change in interpretation, allowing rule #1 to be applied.  So, in
    // the above case:
    // 
    // 
    //     
    // spec.txt lines 4552-4563
    func testExample277() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -  foo
        
           bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 3.  **Item starting with a blank line.**  If a sequence of lines *Ls*
    //     starting with a single [blank line] constitute a (possibly empty)
    //     sequence of blocks *Bs*, not separated from each other by more than
    //     one blank line, and *M* is a list marker of width *W*,
    //     then the result of prepending *M* to the first line of *Ls*, and
    //     indenting subsequent lines of *Ls* by *W + 1* spaces, is a list
    //     item with *Bs* as its contents.
    //     If a line is empty, then it need not be indented.  The type of the
    //     list item (bullet or ordered) is determined by the type of its list
    //     marker.  If the list item is ordered, then it is also assigned a
    //     start number, based on the ordered list marker.
    // 
    // Here are some list items that start with a blank line but are not empty:
    // 
    // 
    //     
    // spec.txt lines 4580-4601
    func testExample278() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -
          foo
        -
          ```
          bar
          ```
        -
              baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li><li><pre><code>bar
        </code></pre></li><li><pre><code>baz
        </code></pre></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // When the list item starts with a blank line, the number of spaces
    // following the list marker doesn't change the required indentation:
    // 
    // 
    //     
    // spec.txt lines 4606-4613
    func testExample279() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -   
          foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list item can begin with at most one blank line.
    // In the following example, `foo` is not part of the list
    // item:
    // 
    // 
    //     
    // spec.txt lines 4620-4629
    func testExample280() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -
        
          foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li></li></ul><p>foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here is an empty bullet list item:
    // 
    // 
    //     
    // spec.txt lines 4634-4644
    func testExample281() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        -
        - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li><li></li><li>bar</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // It does not matter whether there are spaces following the [list marker]:
    // 
    // 
    //     
    // spec.txt lines 4649-4659
    func testExample282() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        -   
        - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li><li></li><li>bar</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here is an empty ordered list item:
    // 
    // 
    //     
    // spec.txt lines 4664-4674
    func testExample283() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1. foo
        2.
        3. bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li>foo</li><li></li><li>bar</li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list may start or end with an empty list item:
    // 
    // 
    //     
    // spec.txt lines 4679-4685
    func testExample284() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // However, an empty list item cannot interrupt a paragraph:
    // 
    // 
    //     
    // spec.txt lines 4689-4700
    func testExample285() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
        *
        
        foo
        1.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo
        *</p><p>foo
        1.</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 4.  **Indentation.**  If a sequence of lines *Ls* constitutes a list item
    //     according to rule #1, #2, or #3, then the result of indenting each line
    //     of *Ls* by 1-3 spaces (the same for each line) also constitutes a
    //     list item with the same contents and attributes.  If a line is
    //     empty, then it need not be indented.
    // 
    // Indented one space:
    // 
    // 
    //     
    // spec.txt lines 4711-4730
    func testExample286() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         1.  A paragraph
             with two lines.
        
                 indented code
        
             > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Indented two spaces:
    // 
    // 
    //     
    // spec.txt lines 4735-4754
    func testExample287() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          1.  A paragraph
              with two lines.
        
                  indented code
        
              > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Indented three spaces:
    // 
    // 
    //     
    // spec.txt lines 4759-4778
    func testExample288() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           1.  A paragraph
               with two lines.
        
                   indented code
        
               > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Four spaces indent gives a code block:
    // 
    // 
    //     
    // spec.txt lines 4783-4798
    func testExample289() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            1.  A paragraph
                with two lines.
        
                    indented code
        
                > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <pre><code>1.  A paragraph
            with two lines.
        
                indented code
        
            &gt; A block quote.
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    // 5.  **Laziness.**  If a string of lines *Ls* constitute a [list
    //     item](#list-items) with contents *Bs*, then the result of deleting
    //     some or all of the indentation from one or more lines in which the
    //     next [non-whitespace character] after the indentation is
    //     [paragraph continuation text] is a
    //     list item with the same contents and attributes.  The unindented
    //     lines are called
    //     [lazy continuation line](@)s.
    // 
    // Here is an example with [lazy continuation lines]:
    // 
    // 
    //     
    // spec.txt lines 4813-4832
    func testExample290() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          1.  A paragraph
        with two lines.
        
                  indented code
        
              > A block quote.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><p>A paragraph
        with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Indentation can be partially deleted:
    // 
    // 
    //     
    // spec.txt lines 4837-4845
    func testExample291() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          1.  A paragraph
            with two lines.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li>A paragraph
        with two lines.</li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // These examples show how laziness can work in nested structures:
    // 
    // 
    //     
    // spec.txt lines 4850-4864
    func testExample292() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > 1. > Blockquote
        continued here.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><ol><li><blockquote><p>Blockquote
        continued here.</p></blockquote></li></ol></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4867-4881
    func testExample293() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > 1. > Blockquote
        > continued here.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <blockquote><ol><li><blockquote><p>Blockquote
        continued here.</p></blockquote></li></ol></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    // 6.  **That's all.** Nothing that is not counted as a list item by rules
    //     #1--5 counts as a [list item](#list-items).
    // 
    // The rules for sublists follow from the general rules
    // [above][List items].  A sublist must be indented the same number
    // of spaces a paragraph would need to be in order to be included
    // in the list item.
    // 
    // So, in this case we need two spaces indent:
    // 
    // 
    //     
    // spec.txt lines 4895-4916
    func testExample294() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
          - bar
            - baz
              - boo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo
        <ul><li>bar
        <ul><li>baz
        <ul><li>boo</li></ul></li></ul></li></ul></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // One is not enough:
    // 
    // 
    //     
    // spec.txt lines 4921-4933
    func testExample295() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
         - bar
          - baz
           - boo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li>foo</li><li>bar</li><li>baz</li><li>boo</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here we need four, because the list marker is wider:
    // 
    // 
    //     
    // spec.txt lines 4938-4949
    func testExample296() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        10) foo
            - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="10"><li>foo
        <ul><li>bar</li></ul></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Three is not enough:
    // 
    // 
    //     
    // spec.txt lines 4954-4964
    func testExample297() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        10) foo
           - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol start="10"><li>foo</li></ol><ul><li>bar</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list may be the first block in a list item:
    // 
    // 
    //     
    // spec.txt lines 4969-4979
    func testExample298() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - - foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><ul><li>foo</li></ul></li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 4982-4996
    func testExample299() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1. - 2. foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ol><li><ul><li><ol start="2"><li>foo</li></ol></li></ul></li></ol>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A list item can contain a heading:
    // 
    // 
    //     
    // spec.txt lines 5001-5015
    func testExample300() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - # Foo
        - Bar
          ---
          baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <ul><li><h1>Foo</h1></li><li><h2>Bar</h2>
        baz</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension ListItemsTests {
    static var allTests: Linux.TestList<ListItemsTests> {
        return [
        ("testExample253", testExample253),
        ("testExample254", testExample254),
        ("testExample255", testExample255),
        ("testExample256", testExample256),
        ("testExample257", testExample257),
        ("testExample258", testExample258),
        ("testExample259", testExample259),
        ("testExample260", testExample260),
        ("testExample261", testExample261),
        ("testExample262", testExample262),
        ("testExample263", testExample263),
        ("testExample264", testExample264),
        ("testExample265", testExample265),
        ("testExample266", testExample266),
        ("testExample267", testExample267),
        ("testExample268", testExample268),
        ("testExample269", testExample269),
        ("testExample270", testExample270),
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
        ("testExample296", testExample296),
        ("testExample297", testExample297),
        ("testExample298", testExample298),
        ("testExample299", testExample299),
        ("testExample300", testExample300)
        ]
    }
}