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

final class TextualContentTests: XCTestCase {

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9866-9870
    func testExample671() {
        let markdownTest =
        #####"""
        hello $.;'there
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>hello $.;'there</p>
        let normalizedCM = #####"""
        <p>hello $.;'there</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9873-9877
    func testExample672() {
        let markdownTest =
        #####"""
        Foo χρῆν
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>Foo χρῆν</p>
        let normalizedCM = #####"""
        <p>Foo χρῆν</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Internal spaces are preserved verbatim:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9882-9886
    func testExample673() {
        let markdownTest =
        #####"""
        Multiple     spaces
        """#####
    
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
        ("testExample671", testExample671),
        ("testExample672", testExample672),
        ("testExample673", testExample673)
        ]
    }
}