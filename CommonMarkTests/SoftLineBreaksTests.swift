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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9834-9840
    func testExample669() {
        let markdownTest =
        #####"""
        foo
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9846-9852
    func testExample670() {
        let markdownTest =
        #####"""
        foo
         baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
        ("testExample669", testExample669),
        ("testExample670", testExample670)
        ]
    }
}