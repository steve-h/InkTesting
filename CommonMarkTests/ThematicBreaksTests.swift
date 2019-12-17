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

final class ThematicBreaksTests: XCTestCase {

    // 
    // 
    // This means that parsing can proceed in two steps:  first, the block
    // structure of the document can be discerned; second, text lines inside
    // paragraphs, headings, and other block constructs can be parsed for inline
    // structure.  The second step requires information about link reference
    // definitions that will be available only at the end of the first
    // step.  Note that the first step requires processing lines in sequence,
    // but the second can be parallelized, since the inline parsing of
    // one block element does not affect the inline parsing of any other.
    // 
    // ## Container blocks and leaf blocks
    // 
    // We can divide blocks into two types:
    // [container blocks](@),
    // which can contain other blocks, and [leaf blocks](@),
    // which cannot.
    // 
    // # Leaf blocks
    // 
    // This section describes the different kinds of leaf block that make up a
    // Markdown document.
    // 
    // ## Thematic breaks
    // 
    // A line consisting of 0-3 spaces of indentation, followed by a sequence
    // of three or more matching `-`, `_`, or `*` characters, each followed
    // optionally by any number of spaces or tabs, forms a
    // [thematic break](@).
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 535-543
    func testExample13() {
        var markdownTest =
        #####"""
        ***
        ---
        ___
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
      //<hr />
      //<hr />
        let normalizedCM = #####"""
        <hr><hr><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Wrong characters:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 548-552
    func testExample14() {
        var markdownTest =
        #####"""
        +++
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>+++</p>
        let normalizedCM = #####"""
        <p>+++</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 555-559
    func testExample15() {
        var markdownTest =
        #####"""
        ===
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>===</p>
        let normalizedCM = #####"""
        <p>===</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Not enough characters:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 564-572
    func testExample16() {
        var markdownTest =
        #####"""
        --
        **
        __
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>--
      //**
      //__</p>
        let normalizedCM = #####"""
        <p>-- ** __</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // One to three spaces indent are allowed:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 577-585
    func testExample17() {
        var markdownTest =
        #####"""
         ***
          ***
           ***
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
      //<hr />
      //<hr />
        let normalizedCM = #####"""
        <hr><hr><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Four spaces is too many:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 590-595
    func testExample18() {
        var markdownTest =
        #####"""
            ***
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>***
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>***
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 598-604
    func testExample19() {
        var markdownTest =
        #####"""
        Foo
            ***
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo
      //***</p>
        let normalizedCM = #####"""
        <p>Foo ***</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // More than three characters may be used:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 609-613
    func testExample20() {
        var markdownTest =
        #####"""
        _____________________________________
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Spaces are allowed between the characters:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 618-622
    func testExample21() {
        var markdownTest =
        #####"""
         - - -
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 625-629
    func testExample22() {
        var markdownTest =
        #####"""
         **  * ** * ** * **
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 632-636
    func testExample23() {
        var markdownTest =
        #####"""
        -     -      -      -
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Spaces are allowed at the end:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 641-645
    func testExample24() {
        var markdownTest =
        #####"""
        - - - -    
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // However, no other characters may occur in the line:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 650-660
    func testExample25() {
        var markdownTest =
        #####"""
        _ _ _ _ a
        
        a------
        
        ---a---
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_ _ _ _ a</p>
      //<p>a------</p>
      //<p>---a---</p>
        let normalizedCM = #####"""
        <p>_ _ _ _ a</p><p>a------</p><p>---a---</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // It is required that all of the [non-whitespace characters] be the same.
    // So, this is not a thematic break:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 666-670
    func testExample26() {
        var markdownTest =
        #####"""
         *-*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>-</em></p>
        let normalizedCM = #####"""
        <p><em>-</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Thematic breaks do not need blank lines before or after:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 675-687
    func testExample27() {
        var markdownTest =
        #####"""
        - foo
        ***
        - bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ul>
      //<li>foo</li>
      //</ul>
      //<hr />
      //<ul>
      //<li>bar</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>foo</li></ul><hr><ul><li>bar</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Thematic breaks can interrupt a paragraph:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 692-700
    func testExample28() {
        var markdownTest =
        #####"""
        Foo
        ***
        bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo</p>
      //<hr />
      //<p>bar</p>
        let normalizedCM = #####"""
        <p>Foo</p><hr><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // If a line of dashes that meets the above conditions for being a
    // thematic break could also be interpreted as the underline of a [setext
    // heading], the interpretation as a
    // [setext heading] takes precedence. Thus, for example,
    // this is a setext heading, not a paragraph followed by a thematic break:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 709-716
    func testExample29() {
        var markdownTest =
        #####"""
        Foo
        ---
        bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h2>Foo</h2>
      //<p>bar</p>
        let normalizedCM = #####"""
        <h2>Foo</h2><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // When both a thematic break and a list item are possible
    // interpretations of a line, the thematic break takes precedence:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 722-734
    func testExample30() {
        var markdownTest =
        #####"""
        * Foo
        * * *
        * Bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ul>
      //<li>Foo</li>
      //</ul>
      //<hr />
      //<ul>
      //<li>Bar</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>Foo</li></ul><hr><ul><li>Bar</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // If you want a thematic break in a list item, use a different bullet:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 739-749
    func testExample31() {
        var markdownTest =
        #####"""
        - Foo
        - * * *
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ul>
      //<li>Foo</li>
      //<li>
      //<hr />
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>Foo</li><li><hr></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
}

extension ThematicBreaksTests {
    static var allTests: Linux.TestList<ThematicBreaksTests> {
        return [
        ("testExample13", testExample13),
        ("testExample14", testExample14),
        ("testExample15", testExample15),
        ("testExample16", testExample16),
        ("testExample17", testExample17),
        ("testExample18", testExample18),
        ("testExample19", testExample19),
        ("testExample20", testExample20),
        ("testExample21", testExample21),
        ("testExample22", testExample22),
        ("testExample23", testExample23),
        ("testExample24", testExample24),
        ("testExample25", testExample25),
        ("testExample26", testExample26),
        ("testExample27", testExample27),
        ("testExample28", testExample28),
        ("testExample29", testExample29),
        ("testExample30", testExample30),
        ("testExample31", testExample31)
        ]
    }
}