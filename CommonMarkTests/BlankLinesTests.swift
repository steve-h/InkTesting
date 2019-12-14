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

final class BlankLinesTests: XCTestCase {

    // 
    // 
    // ## Blank lines
    // 
    // [Blank lines] between block-level elements are ignored,
    // except for the role they play in determining whether a [list]
    // is [tight] or [loose].
    // 
    // Blank lines at the beginning and end of the document are also ignored.
    // 
    // 
    //     
    // spec.txt lines 3621-3633
    func testExample227() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          
        
        aaa
          
        
        # aaa
        
          
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>aaa</p><h1>aaa</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension BlankLinesTests {
    static var allTests: Linux.TestList<BlankLinesTests> {
        return [
        ("testExample227", testExample227)
        ]
    }
}