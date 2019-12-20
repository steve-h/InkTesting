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

final class DisallowedRawHtmlExtensionTests: XCTestCase {

    // <div class="extension">
    // 
    // ## Disallowed Raw HTML (extension)
    // 
    // GFM enables the `tagfilter` extension, where the following HTML tags will be
    // filtered when rendering HTML output:
    // 
    // * `<title>`
    // * `<textarea>`
    // * `<style>`
    // * `<xmp>`
    // * `<iframe>`
    // * `<noembed>`
    // * `<noframes>`
    // * `<script>`
    // * `<plaintext>`
    // 
    // Filtering is done by replacing the leading `<` with the entity `&lt;`.  These
    // tags are chosen in particular as they change how HTML is interpreted in a way
    // unique to them (i.e. nested HTML is interpreted differently), and this is
    // usually undesireable in the context of other rendered Markdown content.
    // 
    // All other HTML tags are left untouched.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9661-9672
    func testExample653() {
        let markdownTest =
        #####"""
        <strong> <title> <style> <em>
        
        <blockquote>
          <xmp> is disallowed.  <XMP> is also disallowed.
        </blockquote>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><strong> &lt;title> &lt;style> <em></p>
      //<blockquote>
      //  &lt;xmp> is disallowed.  &lt;XMP> is also disallowed.
      //</blockquote>
        let normalizedCM = #####"""
        <p><strong> <title> <style> <em></p><blockquote>
          <xmp> is disallowed.  <XMP> is also disallowed.
        </blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension DisallowedRawHtmlExtensionTests {
    static var allTests: Linux.TestList<DisallowedRawHtmlExtensionTests> {
        return [
        ("testExample653", testExample653)
        ]
    }
}