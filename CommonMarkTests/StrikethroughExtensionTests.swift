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

final class StrikethroughExtensionTests: XCTestCase {

    // As with regular emphasis delimiters, a new paragraph will cause strikethrough
    // parsing to cease:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7726-7733
    func testExample492() {
        let markdownTest =
        #####"""
        This ~~has a
        
        new paragraph~~.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>This ~~has a</p>
      //<p>new paragraph~~.</p>
        let normalizedCM = #####"""
        <p>This ~~has a</p><p>new paragraph~~.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension StrikethroughExtensionTests {
    static var allTests: Linux.TestList<StrikethroughExtensionTests> {
        return [
        ("testExample492", testExample492)
        ]
    }
}