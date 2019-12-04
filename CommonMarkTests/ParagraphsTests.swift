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

final class ParagraphsTests: XCTestCase {

    // 
    // 
    // ## Paragraphs
    // 
    // A sequence of non-blank lines that cannot be interpreted as other
    // kinds of blocks forms a [paragraph](@).
    // The contents of the paragraph are the result of parsing the
    // paragraph's raw content as inlines.  The paragraph's raw content
    // is formed by concatenating the lines and removing initial and final
    // [whitespace].
    // 
    // A simple example with two paragraphs:
    // 
    // 
    //     
    // spec.txt lines 3514-3521
    func testExample219() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
        
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa</p>
<p>bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Paragraphs can contain multiple lines, but no blank lines:
    // 
    // 
    //     
    // spec.txt lines 3526-3537
    func testExample220() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
        bbb
        
        ccc
        ddd
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa
bbb</p>
<p>ccc
ddd</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Multiple blank lines between paragraph have no effect:
    // 
    // 
    //     
    // spec.txt lines 3542-3550
    func testExample221() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
        
        
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa</p>
<p>bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Leading spaces are skipped:
    // 
    // 
    //     
    // spec.txt lines 3555-3561
    func testExample222() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          aaa
         bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa
bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Lines after the first may be indented any amount, since indented
    // code blocks cannot interrupt paragraphs.
    // 
    // 
    //     
    // spec.txt lines 3567-3575
    func testExample223() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
                     bbb
                                               ccc
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa
bbb
ccc</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // However, the first line may be indented at most three spaces,
    // or an indented code block will be triggered:
    // 
    // 
    //     
    // spec.txt lines 3581-3587
    func testExample224() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           aaa
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa
bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3590-3597
    func testExample225() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            aaa
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>aaa
</code></pre>
<p>bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Final spaces are stripped before inline parsing, so a paragraph
    // that ends with two or more spaces will not end with a [hard line
    // break]:
    // 
    // 
    //     
    // spec.txt lines 3604-3610
    func testExample226() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa     
        bbb     
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>aaa<br>
bbb</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension ParagraphsTests {
    static var allTests: Linux.TestList<ParagraphsTests> {
        return [
        ("testExample219", testExample219),
        ("testExample220", testExample220),
        ("testExample221", testExample221),
        ("testExample222", testExample222),
        ("testExample223", testExample223),
        ("testExample224", testExample224),
        ("testExample225", testExample225),
        ("testExample226", testExample226)
        ]
    }
}