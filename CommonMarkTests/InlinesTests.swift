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

final class InlinesTests: XCTestCase {

    // # Inlines
    // 
    // Inlines are parsed sequentially from the beginning of the character
    // stream to the end (left to right, in left-to-right languages).
    // Thus, for example, in
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 5780-5784
    func testExample307() {
        let markdownTest =
        #####"""
        `hi`lo`
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><code>hi</code>lo`</p>
        let normalizedCM = #####"""
        <p><code>hi</code>lo`</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension InlinesTests {
    static var allTests: Linux.TestList<InlinesTests> {
        return [
        ("testExample307", testExample307)
        ]
    }
}