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

final class BlankLinesTests: XCTestCase {

    // ## Blank lines
    // 
    // [Blank lines] between block-level elements are ignored,
    // except for the role they play in determining whether a [list]
    // is [tight] or [loose].
    // 
    // Blank lines at the beginning and end of the document are also ignored.
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 3294-3306
    func testExample197() {
        let markdownTest =
        #####"""
          
        
        aaa
          
        
        # aaa
        
          \#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>aaa</p>
      //<h1>aaa</h1>
        let normalizedCM = #####"""
        <p>aaa</p><h1>aaa</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension BlankLinesTests {
    static var allTests: Linux.TestList<BlankLinesTests> {
        return [
        ("testExample197", testExample197)
        ]
    }
}