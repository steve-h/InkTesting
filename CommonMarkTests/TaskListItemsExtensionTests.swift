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

final class TaskListItemsExtensionTests: XCTestCase {

    // Task lists can be arbitrarily nested:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5123-5138
    func testExample280() {
        let markdownTest =
        #####"""
        - [x] foo
          - [ ] bar
          - [x] baz
        - [ ] bim\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li><input checked="" disabled="" type="checkbox"> foo
      //<ul>
      //<li><input disabled="" type="checkbox"> bar</li>
      //<li><input checked="" disabled="" type="checkbox"> baz</li>
      //</ul>
      //</li>
      //<li><input disabled="" type="checkbox"> bim</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>[x] foo
        <ul><li>[ ] bar</li><li>[x] baz</li></ul></li><li>[ ] bim</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension TaskListItemsExtensionTests {
    static var allTests: Linux.TestList<TaskListItemsExtensionTests> {
        return [
        ("testExample280", testExample280)
        ]
    }
}