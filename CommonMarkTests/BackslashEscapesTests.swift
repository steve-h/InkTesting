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

final class BackslashEscapesTests: XCTestCase {

    // 
    // `hi` is parsed as code, leaving the backtick at the end as a literal
    // backtick.
    // 
    // 
    // ## Backslash escapes
    // 
    // Any ASCII punctuation character may be backslash-escaped:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5513-5517
    func testExample298() {
        var markdownTest =
        #####"""
        \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>
        let normalizedCM = #####"""
        <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Backslashes before other characters are treated as literal
    // backslashes:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5523-5527
    func testExample299() {
        var markdownTest =
        #####"""
        \	\A\a\ \3\φ\«
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>\	\A\a\ \3\φ\«</p>
        let normalizedCM = #####"""
        <p>\	\A\a\ \3\φ\«</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Escaped characters are treated as regular characters and do
    // not have their usual Markdown meanings:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5533-5553
    func testExample300() {
        var markdownTest =
        #####"""
        \*not emphasized*
        \<br/> not a tag
        \[not a link](/foo)
        \`not code`
        1\. not a list
        \* not a list
        \# not a heading
        \[foo]: /url "not a reference"
        \&ouml; not a character entity
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*not emphasized*
      //&lt;br/&gt; not a tag
      //[not a link](/foo)
      //`not code`
      //1. not a list
      //* not a list
      //# not a heading
      //[foo]: /url &quot;not a reference&quot;
      //&amp;ouml; not a character entity</p>
        let normalizedCM = #####"""
        <p>*not emphasized* &lt;br/&gt; not a tag [not a link](/foo) `not code` 1. not a list * not a list # not a heading [foo]: /url &quot;not a reference&quot; &amp;ouml; not a character entity</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // If a backslash is itself escaped, the following character is not:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5558-5562
    func testExample301() {
        var markdownTest =
        #####"""
        \\*emphasis*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>\<em>emphasis</em></p>
        let normalizedCM = #####"""
        <p>\<em>emphasis</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // A backslash at the end of the line is a [hard line break]:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5567-5573
    func testExample302() {
        var markdownTest =
        #####"""
        foo\
        bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo<br>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Backslash escapes do not work in code blocks, code spans, autolinks, or
    // raw HTML:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5579-5583
    func testExample303() {
        var markdownTest =
        #####"""
        `` \[\` ``
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>\[\`</code></p>
        let normalizedCM = #####"""
        <p><code>\[\`</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5586-5591
    func testExample304() {
        var markdownTest =
        #####"""
            \[\]
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>\[\]
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>\[\]
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5594-5601
    func testExample305() {
        var markdownTest =
        #####"""
        ~~~
        \[\]
        ~~~
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>\[\]
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>\[\]
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5604-5608
    func testExample306() {
        var markdownTest =
        #####"""
        <http://example.com?find=\*>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>
        let normalizedCM = #####"""
        <p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5611-5615
    func testExample307() {
        var markdownTest =
        #####"""
        <a href="/bar\/)">
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<a href="/bar\/)">
        let normalizedCM = #####"""
        <a href="/bar\/)">
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // But they work in all other contexts, including URLs and link titles,
    // link references, and [info strings] in [fenced code blocks]:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5621-5625
    func testExample308() {
        var markdownTest =
        #####"""
        [foo](/bar\* "ti\*tle")
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/bar*" title="ti*tle">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/bar*" title="ti*tle">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5628-5634
    func testExample309() {
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: /bar\* "ti\*tle"
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/bar*" title="ti*tle">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/bar*" title="ti*tle">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5637-5644
    func testExample310() {
        var markdownTest =
        #####"""
        ``` foo\+bar
        foo
        ```
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code class="language-foo+bar">foo
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code class="language-foo+bar">foo
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
}

extension BackslashEscapesTests {
    static var allTests: Linux.TestList<BackslashEscapesTests> {
        return [
        ("testExample298", testExample298),
        ("testExample299", testExample299),
        ("testExample300", testExample300),
        ("testExample301", testExample301),
        ("testExample302", testExample302),
        ("testExample303", testExample303),
        ("testExample304", testExample304),
        ("testExample305", testExample305),
        ("testExample306", testExample306),
        ("testExample307", testExample307),
        ("testExample308", testExample308),
        ("testExample309", testExample309),
        ("testExample310", testExample310)
        ]
    }
}