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

final class FencedCodeBlocksTests: XCTestCase {

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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1655-1664
    func testExample89() {
        let markdownTest =
        #####"""
        ```
        <
         >
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // With tildes:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1669-1678
    func testExample90() {
        let markdownTest =
        #####"""
        ~~~
        <
         >
        ~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Fewer than three backticks is not enough:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1682-1688
    func testExample91() {
        let markdownTest =
        #####"""
        ``
        foo
        ``\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><code>foo</code></p>
        let normalizedCM = #####"""
        <p><code>foo</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The closing code fence must use the same character as the opening
    // fence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1693-1702
    func testExample92() {
        let markdownTest =
        #####"""
        ```
        aaa
        ~~~
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1705-1714
    func testExample93() {
        let markdownTest =
        #####"""
        ~~~
        aaa
        ```
        ~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // The closing code fence must be at least as long as the opening fence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1719-1728
    func testExample94() {
        let markdownTest =
        #####"""
        ````
        aaa
        ```
        ``````\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1731-1740
    func testExample95() {
        let markdownTest =
        #####"""
        ~~~~
        aaa
        ~~~
        ~~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Unclosed code blocks are closed by the end of the document
    // (or the enclosing [block quote][block quotes] or [list item][list items]):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1746-1750
    func testExample96() {
        let markdownTest =
        #####"""
        ```
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<pre><code></code></pre>
        let normalizedCM = #####"""
        <pre><code></code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1753-1763
    func testExample97() {
        let markdownTest =
        #####"""
        `````
        
        ```
        aaa\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1766-1777
    func testExample98() {
        let markdownTest =
        #####"""
        > ```
        > aaa
        
        bbb\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // A code block can have all empty lines as its content:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1782-1791
    func testExample99() {
        let markdownTest =
        #####"""
        ```
        
          
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>
      //  
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>
          
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A code block can be empty:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1796-1801
    func testExample100() {
        let markdownTest =
        #####"""
        ```
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code></code></pre>
        let normalizedCM = #####"""
        <pre><code></code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Fences can be indented.  If the opening fence is indented,
    // content lines will have equivalent opening indentation removed,
    // if present:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1808-1817
    func testExample101() {
        let markdownTest =
        #####"""
         ```
         aaa
        aaa
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1820-1831
    func testExample102() {
        let markdownTest =
        #####"""
          ```
        aaa
          aaa
        aaa
          ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1834-1845
    func testExample103() {
        let markdownTest =
        #####"""
           ```
           aaa
            aaa
          aaa
           ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Four spaces indentation produces an indented code block:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1850-1859
    func testExample104() {
        let markdownTest =
        #####"""
            ```
            aaa
            ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Closing fences may be indented by 0-3 spaces, and their indentation
    // need not match that of the opening fence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1865-1872
    func testExample105() {
        let markdownTest =
        #####"""
        ```
        aaa
          ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1875-1882
    func testExample106() {
        let markdownTest =
        #####"""
           ```
        aaa
          ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>aaa
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>aaa
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not a closing fence, because it is indented 4 spaces:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1887-1895
    func testExample107() {
        let markdownTest =
        #####"""
        ```
        aaa
            ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Code fences (opening and closing) cannot contain internal spaces:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1901-1907
    func testExample108() {
        let markdownTest =
        #####"""
        ``` ```
        aaa\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><code> </code>
      //aaa</p>
        let normalizedCM = #####"""
        <p><code></code> aaa</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1910-1918
    func testExample109() {
        let markdownTest =
        #####"""
        ~~~~~~
        aaa
        ~~~ ~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Fenced code blocks can interrupt paragraphs, and can be followed
    // directly by paragraphs, without a blank line between:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1924-1935
    func testExample110() {
        let markdownTest =
        #####"""
        foo
        ```
        bar
        ```
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // Other blocks can also occur before and after fenced code blocks
    // without an intervening blank line:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1941-1953
    func testExample111() {
        let markdownTest =
        #####"""
        foo
        ---
        ~~~
        bar
        ~~~
        # baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // An [info string] can be provided after the opening code fence.
    // Although this spec doesn't mandate any particular treatment of
    // the info string, the first word is typically used to specify
    // the language of the code block. In HTML output, the language is
    // normally indicated by adding a class to the `code` element consisting
    // of `language-` followed by the language name.
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1963-1974
    func testExample112() {
        let markdownTest =
        #####"""
        ```ruby
        def foo(x)
          return 3
        end
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1977-1988
    func testExample113() {
        let markdownTest =
        #####"""
        ~~~~    ruby startline=3 $%@#$
        def foo(x)
          return 3
        end
        ~~~~~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 1991-1996
    func testExample114() {
        let markdownTest =
        #####"""
        ````;
        ````\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code class="language-;"></code></pre>
        let normalizedCM = #####"""
        <pre><code class="language-;"></code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // [Info strings] for backtick code blocks cannot contain backticks:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2001-2007
    func testExample115() {
        let markdownTest =
        #####"""
        ``` aa ```
        foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><code>aa</code>
      //foo</p>
        let normalizedCM = #####"""
        <p><code>aa</code> foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // [Info strings] for tilde code blocks can contain backticks and tildes:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2012-2019
    func testExample116() {
        let markdownTest =
        #####"""
        ~~~ aa ``` ~~~
        foo
        ~~~\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code class="language-aa">foo
      //</code></pre>
        let normalizedCM = #####"""
        <p>~~~ aa ``` ~~~ foo</p><pre><code></code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Closing code fences cannot have [info strings]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2024-2031
    func testExample117() {
        let markdownTest =
        #####"""
        ```
        ``` aaa
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
        ("testExample89", testExample89),
        ("testExample90", testExample90),
        ("testExample91", testExample91),
        ("testExample92", testExample92),
        ("testExample93", testExample93),
        ("testExample94", testExample94),
        ("testExample95", testExample95),
        ("testExample96", testExample96),
        ("testExample97", testExample97),
        ("testExample98", testExample98),
        ("testExample99", testExample99),
        ("testExample100", testExample100),
        ("testExample101", testExample101),
        ("testExample102", testExample102),
        ("testExample103", testExample103),
        ("testExample104", testExample104),
        ("testExample105", testExample105),
        ("testExample106", testExample106),
        ("testExample107", testExample107),
        ("testExample108", testExample108),
        ("testExample109", testExample109),
        ("testExample110", testExample110),
        ("testExample111", testExample111),
        ("testExample112", testExample112),
        ("testExample113", testExample113),
        ("testExample114", testExample114),
        ("testExample115", testExample115),
        ("testExample116", testExample116),
        ("testExample117", testExample117)
        ]
    }
}