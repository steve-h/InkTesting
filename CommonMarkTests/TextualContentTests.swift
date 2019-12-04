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

final class TextualContentTests: XCTestCase {

    // 
    // 
    // A conforming parser may render a soft line break in HTML either as a
    // line break or as a space.
    // 
    // A renderer may also provide an option to render soft line breaks
    // as hard line breaks.
    // 
    // ## Textual content
    // 
    // Any characters not given an interpretation by the above rules will
    // be parsed as plain textual content.
    // 
    // 
    //     
    // spec.txt lines 9358-9362
    func testExample648() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        hello $.;'there
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>hello $.;'there</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9365-9369
    func testExample649() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo χρῆν
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>Foo χρῆν</p>
        """#####
        )
    }
    // 
    // 
    // Internal spaces are preserved verbatim:
    // 
    // 
    //     
    // spec.txt lines 9374-9378
    func testExample650() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Multiple     spaces
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>Multiple     spaces</p>
        """#####
        )
    }
}

extension TextualContentTests {
    static var allTests: Linux.TestList<TextualContentTests> {
        return [
        ("testExample648", testExample648),
        ("testExample649", testExample649),
        ("testExample650", testExample650)
        ]
    }
}