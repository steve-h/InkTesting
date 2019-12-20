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

final class AutolinksExtensionTests: XCTestCase {

    // `.`, `-`, and `_` can occur on both sides of the `@`, but only `.` may occur at
    // the end of the email address, in which case it will not be considered part of
    // the address:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9346-9359
    func testExample631() {
        let markdownTest =
        #####"""
        a.b-c_d@a.b
        
        a.b-c_d@a.b.
        
        a.b-c_d@a.b-
        
        a.b-c_d@a.b_\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="mailto:a.b-c_d@a.b">a.b-c_d@a.b</a></p>
      //<p><a href="mailto:a.b-c_d@a.b">a.b-c_d@a.b</a>.</p>
      //<p>a.b-c_d@a.b-</p>
      //<p>a.b-c_d@a.b_</p>
        let normalizedCM = #####"""
        <p>a.b-c_d@a.b</p><p>a.b-c_d@a.b.</p><p>a.b-c_d@a.b-</p><p>a.b-c_d@a.b_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension AutolinksExtensionTests {
    static var allTests: Linux.TestList<AutolinksExtensionTests> {
        return [
        ("testExample631", testExample631)
        ]
    }
}