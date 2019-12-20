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

final class TablesExtensionTests: XCTestCase {

    // If there are no rows in the body, no `<tbody>` is generated in HTML output:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 3502-3514
    func testExample205() {
        let markdownTest =
        #####"""
        | abc | def |
        | --- | --- |\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table>
      //<thead>
      //<tr>
      //<th>abc</th>
      //<th>def</th>
      //</tr>
      //</thead>
      //</table>
        let normalizedCM = #####"""
        <p>| abc | def | | --- | --- |</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension TablesExtensionTests {
    static var allTests: Linux.TestList<TablesExtensionTests> {
        return [
        ("testExample205", testExample205)
        ]
    }
}