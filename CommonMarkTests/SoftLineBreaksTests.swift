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

final class SoftLineBreaksTests: XCTestCase {

    // 
    // 
    // ## Soft line breaks
    // 
    // A regular line break (not in a code span or HTML tag) that is not
    // preceded by two or more spaces or a backslash is parsed as a
    // [softbreak](@).  (A softbreak may be rendered in HTML either as a
    // [line ending] or as a space. The result will be the same in
    // browsers. In the examples here, a [line ending] will be used.)
    // 
    // 
    //     
    // spec.txt lines 9326-9332
    func testExample646() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>foo
baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Spaces at the end of the line and beginning of the next line are
    // removed:
    // 
    // 
    //     
    // spec.txt lines 9338-9344
    func testExample647() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo 
         baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>foo
baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension SoftLineBreaksTests {
    static var allTests: Linux.TestList<SoftLineBreaksTests> {
        return [
        ("testExample646", testExample646),
        ("testExample647", testExample647)
        ]
    }
}