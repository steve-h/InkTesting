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

final class BackslashEscapesTests: XCTestCase {

    // `hi` is parsed as code, leaving the backtick at the end as a literal
    // backtick.
    // 
    // ## Backslash escapes
    // 
    // Any ASCII punctuation character may be backslash-escaped:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5794-5798
    func testExample308() {
        let markdownTest =
        #####"""
        \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>
        let normalizedCM = #####"""
        <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslashes before other characters are treated as literal
    // backslashes:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5804-5808
    func testExample309() {
        let markdownTest =
        #####"""
        \	\A\a\ \3\φ\«
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>\	\A\a\ \3\φ\«</p>
        let normalizedCM = #####"""
        <p>\\#####t\A\a\ \3\φ\«</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Escaped characters are treated as regular characters and do
    // not have their usual Markdown meanings:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5814-5834
    func testExample310() {
        let markdownTest =
        #####"""
        \*not emphasized*
        \<br/> not a tag
        \[not a link](/foo)
        \`not code`
        1\. not a list
        \* not a list
        \# not a heading
        \[foo]: /url "not a reference"
        \&ouml; not a character entity\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // If a backslash is itself escaped, the following character is not:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5839-5843
    func testExample311() {
        let markdownTest =
        #####"""
        \\*emphasis*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>\<em>emphasis</em></p>
        let normalizedCM = #####"""
        <p>\<em>emphasis</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A backslash at the end of the line is a [hard line break]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5848-5854
    func testExample312() {
        let markdownTest =
        #####"""
        foo\
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo<br>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash escapes do not work in code blocks, code spans, autolinks, or
    // raw HTML:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5860-5864
    func testExample313() {
        let markdownTest =
        #####"""
        `` \[\` ``
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><code>\[\`</code></p>
        let normalizedCM = #####"""
        <p><code>\[\`</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5867-5872
    func testExample314() {
        let markdownTest =
        #####"""
            \[\]
        """#####
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5875-5882
    func testExample315() {
        let markdownTest =
        #####"""
        ~~~
        \[\]
        ~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>\[\]
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>\[\]
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5885-5889
    func testExample316() {
        let markdownTest =
        #####"""
        <http://example.com?find=\*>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>
        let normalizedCM = #####"""
        <p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5892-5896
    func testExample317() {
        let markdownTest =
        #####"""
        <a href="/bar\/)">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<a href="/bar\/)">
        let normalizedCM = #####"""
        <a href="/bar\/)">
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // But they work in all other contexts, including URLs and link titles,
    // link references, and [info strings] in [fenced code blocks]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5902-5906
    func testExample318() {
        let markdownTest =
        #####"""
        [foo](/bar\* "ti\*tle")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="/bar*" title="ti*tle">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/bar*" title="ti*tle">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5909-5915
    func testExample319() {
        let markdownTest =
        #####"""
        [foo]
        
        [foo]: /bar\* "ti\*tle"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="/bar*" title="ti*tle">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/bar*" title="ti*tle">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5918-5925
    func testExample320() {
        let markdownTest =
        #####"""
        ``` foo\+bar
        foo
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
        ("testExample308", testExample308),
        ("testExample309", testExample309),
        ("testExample310", testExample310),
        ("testExample311", testExample311),
        ("testExample312", testExample312),
        ("testExample313", testExample313),
        ("testExample314", testExample314),
        ("testExample315", testExample315),
        ("testExample316", testExample316),
        ("testExample317", testExample317),
        ("testExample318", testExample318),
        ("testExample319", testExample319),
        ("testExample320", testExample320)
        ]
    }
}