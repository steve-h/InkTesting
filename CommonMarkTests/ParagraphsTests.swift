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
    // spec.txt lines 3171-3178
    func testExample189() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
        
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa</p>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <p>aaa</p><p>bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Paragraphs can contain multiple lines, but no blank lines:
    // 
    // 
    //     
    // spec.txt lines 3183-3194
    func testExample190() {
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
        
      //<p>aaa
      //bbb</p>
      //<p>ccc
      //ddd</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p><p>ccc ddd</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Multiple blank lines between paragraph have no effect:
    // 
    // 
    //     
    // spec.txt lines 3199-3207
    func testExample191() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
        
        
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa</p>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <p>aaa</p><p>bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Leading spaces are skipped:
    // 
    // 
    //     
    // spec.txt lines 3212-3218
    func testExample192() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          aaa
         bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Lines after the first may be indented any amount, since indented
    // code blocks cannot interrupt paragraphs.
    // 
    // 
    //     
    // spec.txt lines 3224-3232
    func testExample193() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa
                     bbb
                                               ccc
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa
      //bbb
      //ccc</p>
        let normalizedCM = #####"""
        <p>aaa bbb ccc</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, the first line may be indented at most three spaces,
    // or an indented code block will be triggered:
    // 
    // 
    //     
    // spec.txt lines 3238-3244
    func testExample194() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           aaa
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3247-3254
    func testExample195() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            aaa
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //</code></pre>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre><p>bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Final spaces are stripped before inline parsing, so a paragraph
    // that ends with two or more spaces will not end with a [hard line
    // break]:
    // 
    // 
    //     
    // spec.txt lines 3261-3267
    func testExample196() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aaa     
        bbb     
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aaa<br />
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa<br>bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension ParagraphsTests {
    static var allTests: Linux.TestList<ParagraphsTests> {
        return [
        ("testExample189", testExample189),
        ("testExample190", testExample190),
        ("testExample191", testExample191),
        ("testExample192", testExample192),
        ("testExample193", testExample193),
        ("testExample194", testExample194),
        ("testExample195", testExample195),
        ("testExample196", testExample196)
        ]
    }
}