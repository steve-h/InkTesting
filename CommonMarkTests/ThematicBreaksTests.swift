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
    // spec.txt lines 878-886
    func testExample43() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ***
        ---
        ___
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr><hr><hr>
        """#####
        )
    }
    // 
    // 
    // Wrong characters:
    // 
    // 
    //     
    // spec.txt lines 891-895
    func testExample44() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        +++
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>+++</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 898-902
    func testExample45() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ===
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>===</p>
        """#####
        )
    }
    // 
    // 
    // Not enough characters:
    // 
    // 
    //     
    // spec.txt lines 907-915
    func testExample46() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        --
        **
        __
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>--
        **
        __</p>
        """#####
        )
    }
    // 
    // 
    // One to three spaces indent are allowed:
    // 
    // 
    //     
    // spec.txt lines 920-928
    func testExample47() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         ***
          ***
           ***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr><hr><hr>
        """#####
        )
    }
    // 
    // 
    // Four spaces is too many:
    // 
    // 
    //     
    // spec.txt lines 933-938
    func testExample48() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            ***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <pre><code>***
        </code></pre>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 941-947
    func testExample49() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
            ***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>Foo
        ***</p>
        """#####
        )
    }
    // 
    // 
    // More than three characters may be used:
    // 
    // 
    //     
    // spec.txt lines 952-956
    func testExample50() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _____________________________________
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
    // 
    // 
    // Spaces are allowed between the characters:
    // 
    // 
    //     
    // spec.txt lines 961-965
    func testExample51() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         - - -
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 968-972
    func testExample52() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         **  * ** * ** * **
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 975-979
    func testExample53() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        -     -      -      -
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
    // 
    // 
    // Spaces are allowed at the end:
    // 
    // 
    //     
    // spec.txt lines 984-988
    func testExample54() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - - - -    
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <hr>
        """#####
        )
    }
    // 
    // 
    // However, no other characters may occur in the line:
    // 
    // 
    //     
    // spec.txt lines 993-1003
    func testExample55() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _ _ _ _ a
        
        a------
        
        ---a---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_ _ _ _ a</p><p>a------</p><p>---a---</p>
        """#####
        )
    }
    // 
    // 
    // It is required that all of the [non-whitespace characters] be the same.
    // So, this is not a thematic break:
    // 
    // 
    //     
    // spec.txt lines 1009-1013
    func testExample56() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         *-*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>-</em></p>
        """#####
        )
    }
    // 
    // 
    // Thematic breaks do not need blank lines before or after:
    // 
    // 
    //     
    // spec.txt lines 1018-1030
    func testExample57() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        ***
        - bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li>foo</li></ul><hr><ul><li>bar</li></ul>
        """#####
        )
    }
    // 
    // 
    // Thematic breaks can interrupt a paragraph:
    // 
    // 
    //     
    // spec.txt lines 1035-1043
    func testExample58() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        ***
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>Foo</p><hr><p>bar</p>
        """#####
        )
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
    // spec.txt lines 1052-1059
    func testExample59() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        ---
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <h2>Foo</h2><p>bar</p>
        """#####
        )
    }
    // 
    // 
    // When both a thematic break and a list item are possible
    // interpretations of a line, the thematic break takes precedence:
    // 
    // 
    //     
    // spec.txt lines 1065-1077
    func testExample60() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        * Foo
        * * *
        * Bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li>Foo</li></ul><hr><ul><li>Bar</li></ul>
        """#####
        )
    }
    // 
    // 
    // If you want a thematic break in a list item, use a different bullet:
    // 
    // 
    //     
    // spec.txt lines 1082-1092
    func testExample61() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - Foo
        - * * *
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <ul><li>Foo</li><li><hr></li></ul>
        """#####
        )
    }
}

extension ThematicBreaksTests {
    static var allTests: Linux.TestList<ThematicBreaksTests> {
        return [
        ("testExample43", testExample43),
        ("testExample44", testExample44),
        ("testExample45", testExample45),
        ("testExample46", testExample46),
        ("testExample47", testExample47),
        ("testExample48", testExample48),
        ("testExample49", testExample49),
        ("testExample50", testExample50),
        ("testExample51", testExample51),
        ("testExample52", testExample52),
        ("testExample53", testExample53),
        ("testExample54", testExample54),
        ("testExample55", testExample55),
        ("testExample56", testExample56),
        ("testExample57", testExample57),
        ("testExample58", testExample58),
        ("testExample59", testExample59),
        ("testExample60", testExample60),
        ("testExample61", testExample61)
        ]
    }
}