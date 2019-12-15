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

final class FencedCodeBlocksTests: XCTestCase {

    // 
    // 
    // 
    // ## Fenced code blocks
    // 
    // A [code fence](@) is a sequence
    // of at least three consecutive backtick characters (`` ` ``) or
    // tildes (`~`).  (Tildes and backticks cannot be mixed.)
    // A [fenced code block](@)
    // begins with a code fence, indented no more than three spaces.
    // 
    // The line with the opening code fence may optionally contain some text
    // following the code fence; this is trimmed of leading and trailing
    // whitespace and called the [info string](@). If the [info string] comes
    // after a backtick fence, it may not contain any backtick
    // characters.  (The reason for this restriction is that otherwise
    // some inline code would be incorrectly interpreted as the
    // beginning of a fenced code block.)
    // 
    // The content of the code block consists of all subsequent lines, until
    // a closing [code fence] of the same type as the code block
    // began with (backticks or tildes), and with at least as many backticks
    // or tildes as the opening code fence.  If the leading code fence is
    // indented N spaces, then up to N spaces of indentation are removed from
    // each line of the content (if present).  (If a content line is not
    // indented, it is preserved unchanged.  If it is indented less than N
    // spaces, all of the indentation is removed.)
    // 
    // The closing code fence may be indented up to three spaces, and may be
    // followed only by spaces, which are ignored.  If the end of the
    // containing block (or document) is reached and no closing code fence
    // has been found, the code block contains all of the lines after the
    // opening code fence until the end of the containing block (or
    // document).  (An alternative spec would require backtracking in the
    // event that a closing code fence is not found.  But this makes parsing
    // much less efficient, and there seems to be no real down side to the
    // behavior described here.)
    // 
    // A fenced code block may interrupt a paragraph, and does not require
    // a blank line either before or after.
    // 
    // The content of a code fence is treated as literal text, not parsed
    // as inlines.  The first word of the [info string] is typically used to
    // specify the language of the code sample, and rendered in the `class`
    // attribute of the `code` tag.  However, this spec does not mandate any
    // particular treatment of the [info string].
    // 
    // Here is a simple example with backticks:
    // 
    // 
    //     
    // spec.txt lines 1982-1991
    func testExample119() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        <
         >
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>&lt;
      // &gt;
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>&lt;
         &gt;
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // With tildes:
    // 
    // 
    //     
    // spec.txt lines 1996-2005
    func testExample120() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~
        <
         >
        ~~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>&lt;
      // &gt;
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>&lt;
         &gt;
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Fewer than three backticks is not enough:
    // 
    // 
    //     
    // spec.txt lines 2009-2015
    func testExample121() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``
        foo
        ``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo</code></p>
        let normalizedCM = #####"""
        <p><code>foo</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The closing code fence must use the same character as the opening
    // fence:
    // 
    // 
    //     
    // spec.txt lines 2020-2029
    func testExample122() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        aaa
        ~~~
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //~~~
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        ~~~
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2032-2041
    func testExample123() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~
        aaa
        ```
        ~~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //```
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        ```
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The closing code fence must be at least as long as the opening fence:
    // 
    // 
    //     
    // spec.txt lines 2046-2055
    func testExample124() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ````
        aaa
        ```
        ``````
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //```
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        ```
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2058-2067
    func testExample125() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~~
        aaa
        ~~~
        ~~~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //~~~
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        ~~~
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Unclosed code blocks are closed by the end of the document
    // (or the enclosing [block quote][block quotes] or [list item][list items]):
    // 
    // 
    //     
    // spec.txt lines 2073-2077
    func testExample126() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code></code></pre>
        let normalizedCM = #####"""
        <pre><code></code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2080-2090
    func testExample127() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `````
        
        ```
        aaa
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>
      //```
      //aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>
        ```
        aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2093-2104
    func testExample128() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > ```
        > aaa
        
        bbb
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<blockquote>
      //<pre><code>aaa
      //</code></pre>
      //</blockquote>
      //<p>bbb</p>
        let normalizedCM = #####"""
        <blockquote><pre><code>aaa
        </code></pre></blockquote><p>bbb</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A code block can have all empty lines as its content:
    // 
    // 
    //     
    // spec.txt lines 2109-2118
    func testExample129() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        
          
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>
      //  
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>
          
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A code block can be empty:
    // 
    // 
    //     
    // spec.txt lines 2123-2128
    func testExample130() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code></code></pre>
        let normalizedCM = #####"""
        <pre><code></code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Fences can be indented.  If the opening fence is indented,
    // content lines will have equivalent opening indentation removed,
    // if present:
    // 
    // 
    //     
    // spec.txt lines 2135-2144
    func testExample131() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         ```
         aaa
        aaa
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2147-2158
    func testExample132() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          ```
        aaa
          aaa
        aaa
          ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //aaa
      //aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        aaa
        aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2161-2172
    func testExample133() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           ```
           aaa
            aaa
          aaa
           ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      // aaa
      //aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
         aaa
        aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Four spaces indentation produces an indented code block:
    // 
    // 
    //     
    // spec.txt lines 2177-2186
    func testExample134() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            ```
            aaa
            ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>```
      //aaa
      //```
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>```
        aaa
        ```
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Closing fences may be indented by 0-3 spaces, and their indentation
    // need not match that of the opening fence:
    // 
    // 
    //     
    // spec.txt lines 2192-2199
    func testExample135() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        aaa
          ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2202-2209
    func testExample136() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           ```
        aaa
          ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a closing fence, because it is indented 4 spaces:
    // 
    // 
    //     
    // spec.txt lines 2214-2222
    func testExample137() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        aaa
            ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //    ```
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
            ```
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    // Code fences (opening and closing) cannot contain internal spaces:
    // 
    // 
    //     
    // spec.txt lines 2228-2234
    func testExample138() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``` ```
        aaa
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> </code>
      //aaa</p>
        let normalizedCM = #####"""
        <p><code></code> aaa</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2237-2245
    func testExample139() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~~~~
        aaa
        ~~~ ~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>aaa
      //~~~ ~~
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        ~~~ ~~
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Fenced code blocks can interrupt paragraphs, and can be followed
    // directly by paragraphs, without a blank line between:
    // 
    // 
    //     
    // spec.txt lines 2251-2262
    func testExample140() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
        ```
        bar
        ```
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo</p>
      //<pre><code>bar
      //</code></pre>
      //<p>baz</p>
        let normalizedCM = #####"""
        <p>foo</p><pre><code>bar
        </code></pre><p>baz</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Other blocks can also occur before and after fenced code blocks
    // without an intervening blank line:
    // 
    // 
    //     
    // spec.txt lines 2268-2280
    func testExample141() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
        ---
        ~~~
        bar
        ~~~
        # baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h2>foo</h2>
      //<pre><code>bar
      //</code></pre>
      //<h1>baz</h1>
        let normalizedCM = #####"""
        <h2>foo</h2><pre><code>bar
        </code></pre><h1>baz</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // An [info string] can be provided after the opening code fence.
    // Although this spec doesn't mandate any particular treatment of
    // the info string, the first word is typically used to specify
    // the language of the code block. In HTML output, the language is
    // normally indicated by adding a class to the `code` element consisting
    // of `language-` followed by the language name.
    // 
    // 
    //     
    // spec.txt lines 2290-2301
    func testExample142() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```ruby
        def foo(x)
          return 3
        end
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code class="language-ruby">def foo(x)
      //  return 3
      //end
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code class="language-ruby">def foo(x)
          return 3
        end
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2304-2315
    func testExample143() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~~    ruby startline=3 $%@#$
        def foo(x)
          return 3
        end
        ~~~~~~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code class="language-ruby">def foo(x)
      //  return 3
      //end
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code class="language-ruby">def foo(x)
          return 3
        end
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2318-2323
    func testExample144() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ````;
        ````
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code class="language-;"></code></pre>
        let normalizedCM = #####"""
        <pre><code class="language-;"></code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Info strings] for backtick code blocks cannot contain backticks:
    // 
    // 
    //     
    // spec.txt lines 2328-2334
    func testExample145() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``` aa ```
        foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>aa</code>
      //foo</p>
        let normalizedCM = #####"""
        <p><code>aa</code> foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Info strings] for tilde code blocks can contain backticks and tildes:
    // 
    // 
    //     
    // spec.txt lines 2339-2346
    func testExample146() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ~~~ aa ``` ~~~
        foo
        ~~~
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code class="language-aa">foo
      //</code></pre>
        let normalizedCM = #####"""
        <p>~~~ aa ``` ~~~ foo</p><pre><code></code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Closing code fences cannot have [info strings]:
    // 
    // 
    //     
    // spec.txt lines 2351-2358
    func testExample147() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        ``` aaa
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>``` aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>``` aaa
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension FencedCodeBlocksTests {
    static var allTests: Linux.TestList<FencedCodeBlocksTests> {
        return [
        ("testExample119", testExample119),
        ("testExample120", testExample120),
        ("testExample121", testExample121),
        ("testExample122", testExample122),
        ("testExample123", testExample123),
        ("testExample124", testExample124),
        ("testExample125", testExample125),
        ("testExample126", testExample126),
        ("testExample127", testExample127),
        ("testExample128", testExample128),
        ("testExample129", testExample129),
        ("testExample130", testExample130),
        ("testExample131", testExample131),
        ("testExample132", testExample132),
        ("testExample133", testExample133),
        ("testExample134", testExample134),
        ("testExample135", testExample135),
        ("testExample136", testExample136),
        ("testExample137", testExample137),
        ("testExample138", testExample138),
        ("testExample139", testExample139),
        ("testExample140", testExample140),
        ("testExample141", testExample141),
        ("testExample142", testExample142),
        ("testExample143", testExample143),
        ("testExample144", testExample144),
        ("testExample145", testExample145),
        ("testExample146", testExample146),
        ("testExample147", testExample147)
        ]
    }
}