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

final class SoftLineBreaksTests: XCTestCase {

    // ## Soft line breaks
    // 
    // A regular line break (not in a code span or HTML tag) that is not
    // preceded by two or more spaces or a backslash is parsed as a
    // [softbreak](@).  (A softbreak may be rendered in HTML either as a
    // [line ending] or as a space. The result will be the same in
    // browsers. In the examples here, a [line ending] will be used.)
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9317-9323
    func testExample645() {
        let markdownTest =
        #####"""
        foo
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo
      //baz</p>
        let normalizedCM = #####"""
        <p>foo baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Spaces at the end of the line and beginning of the next line are
    // removed:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9329-9335
    func testExample646() {
        let markdownTest =
        #####"""
        foo 
         baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo
      //baz</p>
        let normalizedCM = #####"""
        <p>foo baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension SoftLineBreaksTests {
    static var allTests: Linux.TestList<SoftLineBreaksTests> {
        return [
        ("testExample645", testExample645),
        ("testExample646", testExample646)
        ]
    }
}