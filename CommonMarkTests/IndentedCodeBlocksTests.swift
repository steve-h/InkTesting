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

final class IndentedCodeBlocksTests: XCTestCase {

    // 
    // 
    // ## Indented code blocks
    // 
    // An [indented code block](@) is composed of one or more
    // [indented chunks] separated by blank lines.
    // An [indented chunk](@) is a sequence of non-blank lines,
    // each indented four or more spaces. The contents of the code block are
    // the literal contents of the lines, including trailing
    // [line endings], minus four spaces of indentation.
    // An indented code block has no [info string].
    // 
    // An indented code block cannot interrupt a paragraph, so there must be
    // a blank line between a paragraph and a following indented code block.
    // (A blank line is not needed, however, between a code block and a following
    // paragraph.)
    // 
    // 
    //     
    // spec.txt lines 1751-1758
    func testExample107() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            a simple
              indented code block
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>a simple
  indented code block
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // If there is any ambiguity between an interpretation of indentation
    // as a code block and as indicating that material belongs to a [list
    // item][list items], the list item interpretation takes precedence:
    // 
    // 
    //     
    // spec.txt lines 1765-1776
    func testExample108() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          - foo
        
            bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1779-1792
    func testExample109() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        1.  foo
        
            - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<ol>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
</li>
</ol>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    // The contents of a code block are literal text, and do not get parsed
    // as Markdown:
    // 
    // 
    //     
    // spec.txt lines 1799-1810
    func testExample110() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            <a/>
            *hi*
        
            - one
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>&lt;a/&gt;
*hi*

- one
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Here we have three chunks separated by blank lines:
    // 
    // 
    //     
    // spec.txt lines 1815-1832
    func testExample111() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            chunk1
        
            chunk2
          
         
         
            chunk3
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>chunk1

chunk2



chunk3
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Any initial spaces beyond four will be included in the content, even
    // in interior blank lines:
    // 
    // 
    //     
    // spec.txt lines 1838-1847
    func testExample112() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            chunk1
              
              chunk2
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>chunk1
  
  chunk2
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // An indented code block cannot interrupt a paragraph.  (This
    // allows hanging indents and the like.)
    // 
    // 
    //     
    // spec.txt lines 1853-1860
    func testExample113() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
            bar
        
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
bar</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // However, any non-blank line with fewer than four leading spaces ends
    // the code block immediately.  So a paragraph may occur immediately
    // after indented code:
    // 
    // 
    //     
    // spec.txt lines 1867-1874
    func testExample114() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            foo
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>foo
</code></pre>
<p>bar</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // And indented code can occur immediately before and after other kinds of
    // blocks:
    // 
    // 
    //     
    // spec.txt lines 1880-1895
    func testExample115() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # Heading
            foo
        Heading
        ------
            foo
        ----
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h1>Heading</h1>
<pre><code>foo
</code></pre>
<h2>Heading</h2>
<pre><code>foo
</code></pre>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The first line can be indented more than four spaces:
    // 
    // 
    //     
    // spec.txt lines 1900-1907
    func testExample116() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
                foo
            bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>    foo
bar
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Blank lines preceding or following an indented code block
    // are not included in it:
    // 
    // 
    //     
    // spec.txt lines 1913-1922
    func testExample117() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        
            
            foo
            
        
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>foo
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Trailing spaces are included in the code block's content:
    // 
    // 
    //     
    // spec.txt lines 1927-1932
    func testExample118() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            foo  
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>foo  
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension IndentedCodeBlocksTests {
    static var allTests: Linux.TestList<IndentedCodeBlocksTests> {
        return [
        ("testExample107", testExample107),
        ("testExample108", testExample108),
        ("testExample109", testExample109),
        ("testExample110", testExample110),
        ("testExample111", testExample111),
        ("testExample112", testExample112),
        ("testExample113", testExample113),
        ("testExample114", testExample114),
        ("testExample115", testExample115),
        ("testExample116", testExample116),
        ("testExample117", testExample117),
        ("testExample118", testExample118)
        ]
    }
}