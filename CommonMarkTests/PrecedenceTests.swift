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

final class PrecedenceTests: XCTestCase {

    // ## Insecure characters
    // 
    // For security reasons, the Unicode character `U+0000` must be replaced
    // with the REPLACEMENT CHARACTER (`U+FFFD`).
    // 
    // # Blocks and inlines
    // 
    // We can think of a document as a sequence of
    // [blocks](@)---structural elements like paragraphs, block
    // quotations, lists, headings, rules, and code blocks.  Some blocks (like
    // block quotes and list items) contain other blocks; others (like
    // headings and paragraphs) contain [inline](@) content---text,
    // links, emphasized text, images, code spans, and so on.
    // 
    // ## Precedence
    // 
    // Indicators of block structure always take precedence over indicators
    // of inline structure.  So, for example, the following is a list with
    // two items, not a list with one item containing a code span:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 496-504
    func testExample12() {
        let markdownTest =
        #####"""
        - `one
        - two`\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ul>
      //<li>`one</li>
      //<li>two`</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li>`one</li><li>two`</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension PrecedenceTests {
    static var allTests: Linux.TestList<PrecedenceTests> {
        return [
        ("testExample12", testExample12)
        ]
    }
}