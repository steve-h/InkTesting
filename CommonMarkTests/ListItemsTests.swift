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

final class ListItemsTests: XCTestCase {

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
    //     a paragraph---that is, when it starts on a line that would
    //     otherwise count as [paragraph continuation text]---then (a)
    //     the lines *Ls* must not begin with a blank line, and (b) if
    //     the list item is ordered, the start number must be 1.
    //     2. If any line is a [thematic break][thematic breaks] then
    //        that line is not a list item.
    // 
    // For example, let *Ls* be the lines
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4003-4018
    func testExample231() {
        let markdownTest =
        #####"""
        A paragraph
        with two lines.
        
            indented code
        
        > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
        let normalizedCM = #####"""
        <p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // And let *M* be the marker `1.`, and *N* = 2.  Then rule #1 says
    // that the following is an ordered list item with start number 1,
    // and the same contents as *Ls*:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4025-4044
    func testExample232() {
        let markdownTest =
        #####"""
        1.  A paragraph
            with two lines.
        
                indented code
        
            > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4058-4067
    func testExample233() {
        let markdownTest =
        #####"""
        - one
        
         two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>one</li>
      //</ul>
      //<p>two</p>
        let normalizedCM = #####"""
        <ul><li>one</li></ul><p>two</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4070-4081
    func testExample234() {
        let markdownTest =
        #####"""
        - one
        
          two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>one</p>
      //<p>two</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>one</p><p>two</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4084-4094
    func testExample235() {
        let markdownTest =
        #####"""
         -    one
        
             two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>one</li>
      //</ul>
      //<pre><code> two
      //</code></pre>
        let normalizedCM = #####"""
        <ul><li>one</li></ul><pre><code> two
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4097-4108
    func testExample236() {
        let markdownTest =
        #####"""
         -    one
        
              two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>one</p>
      //<p>two</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>one</p><p>two</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // It is tempting to think of this in terms of columns:  the continuation
    // blocks must be indented at least to the column of the first
    // [non-whitespace character] after the list marker. However, that is not quite right.
    // The spaces after the list marker determine how much relative indentation
    // is needed.  Which column this indentation reaches will depend on
    // how the list item is embedded in other constructions, as shown by
    // this example:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4119-4134
    func testExample237() {
        let markdownTest =
        #####"""
           > > 1.  one
        >>
        >>     two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<blockquote>
      //<ol>
      //<li>
      //<p>one</p>
      //<p>two</p>
      //</li>
      //</ol>
      //</blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><blockquote><ol><li><p>one</p><p>two</p></li></ol></blockquote></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4146-4159
    func testExample238() {
        let markdownTest =
        #####"""
        >>- one
        >>
          >  > two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<blockquote>
      //<ul>
      //<li>one</li>
      //</ul>
      //<p>two</p>
      //</blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><blockquote><ul><li>one</li></ul><p>two</p></blockquote></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that at least one space is needed between the list marker and
    // any following content, so these are not list items:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4165-4172
    func testExample239() {
        let markdownTest =
        #####"""
        -one
        
        2.two\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>-one</p>
      //<p>2.two</p>
        let normalizedCM = #####"""
        <p>-one</p><p>2.two</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list item may contain blocks that are separated by more than
    // one blank line.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4178-4190
    func testExample240() {
        let markdownTest =
        #####"""
        - foo
        
        
          bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<p>bar</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list item may contain any kind of block:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4195-4217
    func testExample241() {
        let markdownTest =
        #####"""
        1.  foo
        
            ```
            bar
            ```
        
            baz
        
            > bam\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>foo</p>
      //<pre><code>bar
      //</code></pre>
      //<p>baz</p>
      //<blockquote>
      //<p>bam</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>foo</p><pre><code>bar
        </code></pre><p>baz</p><blockquote><p>bam</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list item that contains an indented code block will preserve
    // empty lines within the code block verbatim.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4223-4241
    func testExample242() {
        let markdownTest =
        #####"""
        - Foo
        
              bar
        
        
              baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>Foo</p>
      //<pre><code>bar
      //
      //
      //baz
      //</code></pre>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>Foo</p><pre><code>bar
        
        
        baz
        </code></pre></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that ordered list start numbers must be nine digits or less:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4245-4251
    func testExample243() {
        let markdownTest =
        #####"""
        123456789. ok
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ol start="123456789">
      //<li>ok</li>
      //</ol>
        let normalizedCM = #####"""
        <ol start="123456789"><li>ok</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4254-4258
    func testExample244() {
        let markdownTest =
        #####"""
        1234567890. not ok
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>1234567890. not ok</p>
        let normalizedCM = #####"""
        <p>1234567890. not ok</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A start number may begin with 0s:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4263-4269
    func testExample245() {
        let markdownTest =
        #####"""
        0. ok
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ol start="0">
      //<li>ok</li>
      //</ol>
        let normalizedCM = #####"""
        <ol start="0"><li>ok</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4272-4278
    func testExample246() {
        let markdownTest =
        #####"""
        003. ok
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ol start="3">
      //<li>ok</li>
      //</ol>
        let normalizedCM = #####"""
        <ol start="3"><li>ok</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A start number may not be negative:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4283-4287
    func testExample247() {
        let markdownTest =
        #####"""
        -1. not ok
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>-1. not ok</p>
        let normalizedCM = #####"""
        <p>-1. not ok</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4306-4318
    func testExample248() {
        let markdownTest =
        #####"""
        - foo
        
              bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<pre><code>bar
      //</code></pre>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><pre><code>bar
        </code></pre></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // And in this case it is 11 spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4323-4335
    func testExample249() {
        let markdownTest =
        #####"""
          10.  foo
        
                   bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol start="10">
      //<li>
      //<p>foo</p>
      //<pre><code>bar
      //</code></pre>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol start="10"><li><p>foo</p><pre><code>bar
        </code></pre></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If the *first* block in the list item is an indented code block,
    // then by rule #2, the contents must be indented *one* space after the
    // list marker:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4342-4354
    func testExample250() {
        let markdownTest =
        #####"""
            indented code
        
        paragraph
        
            more code\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>indented code
      //</code></pre>
      //<p>paragraph</p>
      //<pre><code>more code
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4357-4373
    func testExample251() {
        let markdownTest =
        #####"""
        1.     indented code
        
           paragraph
        
               more code\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<pre><code>indented code
      //</code></pre>
      //<p>paragraph</p>
      //<pre><code>more code
      //</code></pre>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><pre><code>indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that an additional space indent is interpreted as space
    // inside the code block:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4379-4395
    func testExample252() {
        let markdownTest =
        #####"""
        1.      indented code
        
           paragraph
        
               more code\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<pre><code> indented code
      //</code></pre>
      //<p>paragraph</p>
      //<pre><code>more code
      //</code></pre>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><pre><code> indented code
        </code></pre><p>paragraph</p><pre><code>more code
        </code></pre></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that rules #1 and #2 only apply to two cases:  (a) cases
    // in which the lines to be included in a list item begin with a
    // [non-whitespace character], and (b) cases in which
    // they begin with an indented code
    // block.  In a case like the following, where the first block begins with
    // a three-space indent, the rules do not allow us to form a list item by
    // indenting the whole thing and prepending a list marker:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4406-4413
    func testExample253() {
        let markdownTest =
        #####"""
           foo
        
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo</p>
      //<p>bar</p>
        let normalizedCM = #####"""
        <p>foo</p><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4416-4425
    func testExample254() {
        let markdownTest =
        #####"""
        -    foo
        
          bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //</ul>
      //<p>bar</p>
        let normalizedCM = #####"""
        <ul><li>foo</li></ul><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not a significant restriction, because when a block begins
    // with 1-3 spaces indent, the indentation can always be removed without
    // a change in interpretation, allowing rule #1 to be applied.  So, in
    // the above case:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4433-4444
    func testExample255() {
        let markdownTest =
        #####"""
        -  foo
        
           bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<p>bar</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4461-4482
    func testExample256() {
        let markdownTest =
        #####"""
        -
          foo
        -
          ```
          bar
          ```
        -
              baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li>
      //<pre><code>bar
      //</code></pre>
      //</li>
      //<li>
      //<pre><code>baz
      //</code></pre>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li><pre><code>bar
        </code></pre></li><li><pre><code>baz
        </code></pre></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // When the list item starts with a blank line, the number of spaces
    // following the list marker doesn't change the required indentation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4487-4494
    func testExample257() {
        let markdownTest =
        #####"""
        -
          foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list item can begin with at most one blank line.
    // In the following example, `foo` is not part of the list
    // item:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4501-4510
    func testExample258() {
        let markdownTest =
        #####"""
        -
        
          foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li></li>
      //</ul>
      //<p>foo</p>
        let normalizedCM = #####"""
        <ul><li></li></ul><p>foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here is an empty bullet list item:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4515-4525
    func testExample259() {
        let markdownTest =
        #####"""
        - foo
        -
        - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li></li>
      //<li>bar</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li></li><li>bar</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // It does not matter whether there are spaces following the [list marker]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4530-4540
    func testExample260() {
        let markdownTest =
        #####"""
        - foo
        -
        - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li></li>
      //<li>bar</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li></li><li>bar</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here is an empty ordered list item:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4545-4555
    func testExample261() {
        let markdownTest =
        #####"""
        1. foo
        2.
        3. bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>foo</li>
      //<li></li>
      //<li>bar</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li>foo</li><li></li><li>bar</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list may start or end with an empty list item:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4560-4566
    func testExample262() {
        let markdownTest =
        #####"""
        *
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ul>
      //<li></li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, an empty list item cannot interrupt a paragraph:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4570-4581
    func testExample263() {
        let markdownTest =
        #####"""
        foo
        *
        
        foo
        1.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo
      //*</p>
      //<p>foo
      //1.</p>
        let normalizedCM = #####"""
        <p>foo *</p><p>foo 1.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // 4.  **Indentation.**  If a sequence of lines *Ls* constitutes a list item
    //     according to rule #1, #2, or #3, then the result of indenting each line
    //     of *Ls* by 1-3 spaces (the same for each line) also constitutes a
    //     list item with the same contents and attributes.  If a line is
    //     empty, then it need not be indented.
    // 
    // Indented one space:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4592-4611
    func testExample264() {
        let markdownTest =
        #####"""
         1.  A paragraph
             with two lines.
        
                 indented code
        
             > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Indented two spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4616-4635
    func testExample265() {
        let markdownTest =
        #####"""
          1.  A paragraph
              with two lines.
        
                  indented code
        
              > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Indented three spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4640-4659
    func testExample266() {
        let markdownTest =
        #####"""
           1.  A paragraph
               with two lines.
        
                   indented code
        
               > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Four spaces indent gives a code block:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4664-4679
    func testExample267() {
        let markdownTest =
        #####"""
            1.  A paragraph
                with two lines.
        
                    indented code
        
                > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>1.  A paragraph
      //    with two lines.
      //
      //        indented code
      //
      //    &gt; A block quote.
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>1.  A paragraph
            with two lines.
        
                indented code
        
            &gt; A block quote.
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4694-4713
    func testExample268() {
        let markdownTest =
        #####"""
          1.  A paragraph
        with two lines.
        
                  indented code
        
              > A block quote.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>
      //<p>A paragraph
      //with two lines.</p>
      //<pre><code>indented code
      //</code></pre>
      //<blockquote>
      //<p>A block quote.</p>
      //</blockquote>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>A paragraph with two lines.</p><pre><code>indented code
        </code></pre><blockquote><p>A block quote.</p></blockquote></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Indentation can be partially deleted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4718-4726
    func testExample269() {
        let markdownTest =
        #####"""
          1.  A paragraph
            with two lines.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol>
      //<li>A paragraph
      //with two lines.</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li>A paragraph with two lines.</li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These examples show how laziness can work in nested structures:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4731-4745
    func testExample270() {
        let markdownTest =
        #####"""
        > 1. > Blockquote
        continued here.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<ol>
      //<li>
      //<blockquote>
      //<p>Blockquote
      //continued here.</p>
      //</blockquote>
      //</li>
      //</ol>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><ol><li><blockquote><p>Blockquote continued here.</p></blockquote></li></ol></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4748-4762
    func testExample271() {
        let markdownTest =
        #####"""
        > 1. > Blockquote
        > continued here.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<ol>
      //<li>
      //<blockquote>
      //<p>Blockquote
      //continued here.</p>
      //</blockquote>
      //</li>
      //</ol>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><ol><li><blockquote><p>Blockquote continued here.</p></blockquote></li></ol></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4776-4797
    func testExample272() {
        let markdownTest =
        #####"""
        - foo
          - bar
            - baz
              - boo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo
      //<ul>
      //<li>bar
      //<ul>
      //<li>baz
      //<ul>
      //<li>boo</li>
      //</ul>
      //</li>
      //</ul>
      //</li>
      //</ul>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo
        <ul><li>bar
        <ul><li>baz
        <ul><li>boo</li></ul></li></ul></li></ul></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // One is not enough:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4802-4814
    func testExample273() {
        let markdownTest =
        #####"""
        - foo
         - bar
          - baz
           - boo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //<li>bar</li>
      //<li>baz</li>
      //<li>boo</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li><li>bar</li><li>baz</li><li>boo</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here we need four, because the list marker is wider:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4819-4830
    func testExample274() {
        let markdownTest =
        #####"""
        10) foo
            - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol start="10">
      //<li>foo
      //<ul>
      //<li>bar</li>
      //</ul>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol start="10"><li>foo
        <ul><li>bar</li></ul></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Three is not enough:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4835-4845
    func testExample275() {
        let markdownTest =
        #####"""
        10) foo
           - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ol start="10">
      //<li>foo</li>
      //</ol>
      //<ul>
      //<li>bar</li>
      //</ul>
        let normalizedCM = #####"""
        <ol start="10"><li>foo</li></ol><ul><li>bar</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list may be the first block in a list item:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4850-4860
    func testExample276() {
        let markdownTest =
        #####"""
        - - foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ul>
      //<li>
      //<ul>
      //<li>foo</li>
      //</ul>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><ul><li>foo</li></ul></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4863-4877
    func testExample277() {
        let markdownTest =
        #####"""
        1. - 2. foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<ol>
      //<li>
      //<ul>
      //<li>
      //<ol start="2">
      //<li>foo</li>
      //</ol>
      //</li>
      //</ul>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><ul><li><ol start="2"><li>foo</li></ol></li></ul></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A list item can contain a heading:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 4882-4896
    func testExample278() {
        let markdownTest =
        #####"""
        - # Foo
        - Bar
          ---
          baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<h1>Foo</h1>
      //</li>
      //<li>
      //<h2>Bar</h2>
      //baz</li>
      //</ul>
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
        ("testExample252", testExample252),
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
        ("testExample278", testExample278)
        ]
    }
}