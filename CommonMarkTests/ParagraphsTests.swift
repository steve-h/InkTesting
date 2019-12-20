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

final class ParagraphsTests: XCTestCase {

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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3187-3194
    func testExample189() {
        let markdownTest =
        #####"""
        aaa
        
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa</p>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <p>aaa</p><p>bbb</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Paragraphs can contain multiple lines, but no blank lines:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3199-3210
    func testExample190() {
        let markdownTest =
        #####"""
        aaa
        bbb
        
        ccc
        ddd\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa
      //bbb</p>
      //<p>ccc
      //ddd</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p><p>ccc ddd</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Multiple blank lines between paragraph have no effect:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3215-3223
    func testExample191() {
        let markdownTest =
        #####"""
        aaa
        
        
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa</p>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <p>aaa</p><p>bbb</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Leading spaces are skipped:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3228-3234
    func testExample192() {
        let markdownTest =
        #####"""
          aaa
         bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Lines after the first may be indented any amount, since indented
    // code blocks cannot interrupt paragraphs.
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3240-3248
    func testExample193() {
        let markdownTest =
        #####"""
        aaa
                     bbb
                                               ccc\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa
      //bbb
      //ccc</p>
        let normalizedCM = #####"""
        <p>aaa bbb ccc</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, the first line may be indented at most three spaces,
    // or an indented code block will be triggered:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3254-3260
    func testExample194() {
        let markdownTest =
        #####"""
           aaa
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3263-3270
    func testExample195() {
        let markdownTest =
        #####"""
            aaa
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>aaa
      //</code></pre>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre><p>bbb</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Final spaces are stripped before inline parsing, so a paragraph
    // that ends with two or more spaces will not end with a [hard line
    // break]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3277-3283
    func testExample196() {
        let markdownTest =
        #####"""
        aaa
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa<br />
      //bbb</p>
        let normalizedCM = #####"""
        <p>aaa bbb</p>
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