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
    // spec.txt lines 9349-9353
    func testExample647() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        hello $.;'there
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>hello $.;'there</p>
        let normalizedCM = #####"""
        <p>hello $.;'there</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9356-9360
    func testExample648() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo χρῆν
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo χρῆν</p>
        let normalizedCM = #####"""
        <p>Foo χρῆν</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Internal spaces are preserved verbatim:
    // 
    // 
    //     
    // spec.txt lines 9365-9369
    func testExample649() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Multiple     spaces
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Multiple     spaces</p>
        let normalizedCM = #####"""
        <p>Multiple     spaces</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension TextualContentTests {
    static var allTests: Linux.TestList<TextualContentTests> {
        return [
        ("testExample647", testExample647),
        ("testExample648", testExample648),
        ("testExample649", testExample649)
        ]
    }
}