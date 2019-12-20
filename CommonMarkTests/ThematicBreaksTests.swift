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

final class ThematicBreaksTests: XCTestCase {

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 551-559
    func testExample13() {
        let markdownTest =
        #####"""
        ***
        ---
        ___\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<hr />
      //<hr />
      //<hr />
        let normalizedCM = #####"""
        <hr><hr><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Wrong characters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 564-568
    func testExample14() {
        let markdownTest =
        #####"""
        +++
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>+++</p>
        let normalizedCM = #####"""
        <p>+++</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 571-575
    func testExample15() {
        let markdownTest =
        #####"""
        ===
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>===</p>
        let normalizedCM = #####"""
        <p>===</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Not enough characters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 580-588
    func testExample16() {
        let markdownTest =
        #####"""
        --
        **
        __\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>--
      //**
      //__</p>
        let normalizedCM = #####"""
        <p>-- ** __</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // One to three spaces indent are allowed:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 593-601
    func testExample17() {
        let markdownTest =
        #####"""
         ***
          ***
           ***\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<hr />
      //<hr />
      //<hr />
        let normalizedCM = #####"""
        <hr><hr><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Four spaces is too many:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 606-611
    func testExample18() {
        let markdownTest =
        #####"""
            ***
        """#####
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 614-620
    func testExample19() {
        let markdownTest =
        #####"""
        Foo
            ***\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //***</p>
        let normalizedCM = #####"""
        <p>Foo ***</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // More than three characters may be used:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 625-629
    func testExample20() {
        let markdownTest =
        #####"""
        _____________________________________
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Spaces are allowed between the characters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 634-638
    func testExample21() {
        let markdownTest =
        #####"""
         - - -
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 641-645
    func testExample22() {
        let markdownTest =
        #####"""
         **  * ** * ** * **
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 648-652
    func testExample23() {
        let markdownTest =
        #####"""
        -     -      -      -
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Spaces are allowed at the end:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 657-661
    func testExample24() {
        let markdownTest =
        #####"""
        - - - -
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<hr />
        let normalizedCM = #####"""
        <hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, no other characters may occur in the line:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 666-676
    func testExample25() {
        let markdownTest =
        #####"""
        _ _ _ _ a
        
        a------
        
        ---a---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>_ _ _ _ a</p>
      //<p>a------</p>
      //<p>---a---</p>
        let normalizedCM = #####"""
        <p>_ _ _ _ a</p><p>a------</p><p>---a---</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // It is required that all of the [non-whitespace characters] be the same.
    // So, this is not a thematic break:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 682-686
    func testExample26() {
        let markdownTest =
        #####"""
         *-*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><em>-</em></p>
        let normalizedCM = #####"""
        <p><em>-</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Thematic breaks do not need blank lines before or after:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 691-703
    func testExample27() {
        let markdownTest =
        #####"""
        - foo
        ***
        - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Thematic breaks can interrupt a paragraph:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 708-716
    func testExample28() {
        let markdownTest =
        #####"""
        Foo
        ***
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo</p>
      //<hr />
      //<p>bar</p>
        let normalizedCM = #####"""
        <p>Foo</p><hr><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If a line of dashes that meets the above conditions for being a
    // thematic break could also be interpreted as the underline of a [setext
    // heading], the interpretation as a
    // [setext heading] takes precedence. Thus, for example,
    // this is a setext heading, not a paragraph followed by a thematic break:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 725-732
    func testExample29() {
        let markdownTest =
        #####"""
        Foo
        ---
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo</h2>
      //<p>bar</p>
        let normalizedCM = #####"""
        <h2>Foo</h2><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // When both a thematic break and a list item are possible
    // interpretations of a line, the thematic break takes precedence:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 738-750
    func testExample30() {
        let markdownTest =
        #####"""
        * Foo
        * * *
        * Bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // If you want a thematic break in a list item, use a different bullet:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 755-765
    func testExample31() {
        let markdownTest =
        #####"""
        - Foo
        - * * *\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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