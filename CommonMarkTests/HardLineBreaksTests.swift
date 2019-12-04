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

final class HardLineBreaksTests: XCTestCase {

    // 
    // 
    // ## Hard line breaks
    // 
    // A line break (not in a code span or HTML tag) that is preceded
    // by two or more spaces and does not occur at the end of a block
    // is parsed as a [hard line break](@) (rendered
    // in HTML as a `<br />` tag):
    // 
    // 
    //     
    // spec.txt lines 9175-9181
    func testExample631() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo  
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<br />
        baz</p>
        """#####
        )
    }
    // 
    // 
    // For a more visible alternative, a backslash before the
    // [line ending] may be used instead of two spaces:
    // 
    // 
    //     
    // spec.txt lines 9187-9193
    func testExample632() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo\
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<br />
        baz</p>
        """#####
        )
    }
    // 
    // 
    // More than two spaces can be used:
    // 
    // 
    //     
    // spec.txt lines 9198-9204
    func testExample633() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo       
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<br />
        baz</p>
        """#####
        )
    }
    // 
    // 
    // Leading spaces at the beginning of the next line are ignored:
    // 
    // 
    //     
    // spec.txt lines 9209-9215
    func testExample634() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo  
             bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<br />
        bar</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9218-9224
    func testExample635() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo\
             bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<br />
        bar</p>
        """#####
        )
    }
    // 
    // 
    // Line breaks can occur inside emphasis, links, and other constructs
    // that allow inline content:
    // 
    // 
    //     
    // spec.txt lines 9230-9236
    func testExample636() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo  
        bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo<br />
        bar</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9239-9245
    func testExample637() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo\
        bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo<br />
        bar</em></p>
        """#####
        )
    }
    // 
    // 
    // Line breaks do not occur inside code spans
    // 
    // 
    //     
    // spec.txt lines 9250-9255
    func testExample638() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `code 
        span`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><code>code  span</code></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9258-9263
    func testExample639() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `code\
        span`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><code>code\ span</code></p>
        """#####
        )
    }
    // 
    // 
    // or HTML tags:
    // 
    // 
    //     
    // spec.txt lines 9268-9274
    func testExample640() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="foo  
        bar">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><a href="foo  
        bar"></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9277-9283
    func testExample641() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="foo\
        bar">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><a href="foo\
        bar"></p>
        """#####
        )
    }
    // 
    // 
    // Hard line breaks are for separating inline content within a block.
    // Neither syntax for hard line breaks works at the end of a paragraph or
    // other block element:
    // 
    // 
    //     
    // spec.txt lines 9290-9294
    func testExample642() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo\
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo\</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9297-9301
    func testExample643() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo  
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9304-9308
    func testExample644() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ### foo\
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <h3>foo\</h3>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9311-9315
    func testExample645() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ### foo  
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <h3>foo</h3>
        """#####
        )
    }
}

extension HardLineBreaksTests {
    static var allTests: Linux.TestList<HardLineBreaksTests> {
        return [
        ("testExample631", testExample631),
        ("testExample632", testExample632),
        ("testExample633", testExample633),
        ("testExample634", testExample634),
        ("testExample635", testExample635),
        ("testExample636", testExample636),
        ("testExample637", testExample637),
        ("testExample638", testExample638),
        ("testExample639", testExample639),
        ("testExample640", testExample640),
        ("testExample641", testExample641),
        ("testExample642", testExample642),
        ("testExample643", testExample643),
        ("testExample644", testExample644),
        ("testExample645", testExample645)
        ]
    }
}