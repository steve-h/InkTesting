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

final class HtmlBlocksTests: XCTestCase {

    // ## HTML blocks
    // 
    // An [HTML block](@) is a group of lines that is treated
    // as raw HTML (and will not be escaped in HTML output).
    // 
    // There are seven kinds of [HTML block], which can be defined by their
    // start and end conditions.  The block begins with a line that meets a
    // [start condition](@) (after up to three spaces optional indentation).
    // It ends with the first subsequent line that meets a matching [end
    // condition](@), or the last line of the document, or the last line of
    // the [container block](#container-blocks) containing the current HTML
    // block, if no line is encountered that meets the [end condition].  If
    // the first line meets both the [start condition] and the [end
    // condition], the block will contain just that line.
    // 
    // 1.  **Start condition:**  line begins with the string `<script`,
    // `<pre`, or `<style` (case-insensitive), followed by whitespace,
    // the string `>`, or the end of the line.\
    // **End condition:**  line contains an end tag
    // `</script>`, `</pre>`, or `</style>` (case-insensitive; it
    // need not match the start tag).
    // 
    // 2.  **Start condition:** line begins with the string `<!--`.\
    // **End condition:**  line contains the string `-->`.
    // 
    // 3.  **Start condition:** line begins with the string `<?`.\
    // **End condition:** line contains the string `?>`.
    // 
    // 4.  **Start condition:** line begins with the string `<!`
    // followed by an uppercase ASCII letter.\
    // **End condition:** line contains the character `>`.
    // 
    // 5.  **Start condition:**  line begins with the string
    // `<![CDATA[`.\
    // **End condition:** line contains the string `]]>`.
    // 
    // 6.  **Start condition:** line begins the string `<` or `</`
    // followed by one of the strings (case-insensitive) `address`,
    // `article`, `aside`, `base`, `basefont`, `blockquote`, `body`,
    // `caption`, `center`, `col`, `colgroup`, `dd`, `details`, `dialog`,
    // `dir`, `div`, `dl`, `dt`, `fieldset`, `figcaption`, `figure`,
    // `footer`, `form`, `frame`, `frameset`,
    // `h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `head`, `header`, `hr`,
    // `html`, `iframe`, `legend`, `li`, `link`, `main`, `menu`, `menuitem`,
    // `nav`, `noframes`, `ol`, `optgroup`, `option`, `p`, `param`,
    // `section`, `source`, `summary`, `table`, `tbody`, `td`,
    // `tfoot`, `th`, `thead`, `title`, `tr`, `track`, `ul`, followed
    // by [whitespace], the end of the line, the string `>`, or
    // the string `/>`.\
    // **End condition:** line is followed by a [blank line].
    // 
    // 7.  **Start condition:**  line begins with a complete [open tag]
    // (with any [tag name] other than `script`,
    // `style`, or `pre`) or a complete [closing tag],
    // followed only by [whitespace] or the end of the line.\
    // **End condition:** line is followed by a [blank line].
    // 
    // HTML blocks continue until they are closed by their appropriate
    // [end condition], or the last line of the document or other [container
    // block](#container-blocks).  This means any HTML **within an HTML
    // block** that might otherwise be recognised as a start condition will
    // be ignored by the parser and passed through as-is, without changing
    // the parser's state.
    // 
    // For instance, `<pre>` within a HTML block started by `<table>` will not affect
    // the parser state; as the HTML block was started in by start condition 6, it
    // will end at any blank line. This can be surprising:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2103-2118
    func testExample118() {
        let markdownTest =
        #####"""
        <table><tr><td>
        <pre>
        **Hello**,
        
        _world_.
        </pre>
        </td></tr></table>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table><tr><td>
      //<pre>
      //**Hello**,
      //<p><em>world</em>.
      //</pre></p>
      //</td></tr></table>
        let normalizedCM = #####"""
        <table><tr><td><pre>
        **Hello**,
        <p><em>world</em>. </pre></p></td></tr></table>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In this case, the HTML block is terminated by the newline — the `**Hello**`
    // text remains verbatim — and regular parsing resumes, with a paragraph,
    // emphasised `world` and inline and block HTML following.
    // 
    // All types of [HTML blocks] except type 7 may interrupt
    // a paragraph.  Blocks of type 7 may not interrupt a paragraph.
    // (This restriction is intended to prevent unwanted interpretation
    // of long tags inside a wrapped paragraph as starting HTML blocks.)
    // 
    // Some simple examples follow.  Here are some basic HTML blocks
    // of type 6:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2132-2151
    func testExample119() {
        let markdownTest =
        #####"""
        <table>
          <tr>
            <td>
                   hi
            </td>
          </tr>
        </table>
        
        okay.\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table>
      //  <tr>
      //    <td>
      //           hi
      //    </td>
      //  </tr>
      //</table>
      //<p>okay.</p>
        let normalizedCM = #####"""
        <table>
          <tr>
            <td>
                   hi
            </td>
          </tr></table><p>okay.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2154-2162
    func testExample120() {
        let markdownTest =
        #####"""
         <div>
          *hello*
                 <foo><a>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      // <div>
      //  *hello*
      //         <foo><a>
        let normalizedCM = #####"""
         <div>
          *hello*
                 <foo><a>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A block can also start with a closing tag:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2167-2173
    func testExample121() {
        let markdownTest =
        #####"""
        </div>
        *foo*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //</div>
      //*foo*
        let normalizedCM = #####"""
        </div>
        *foo*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here we have two HTML blocks with a Markdown paragraph between them:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2178-2188
    func testExample122() {
        let markdownTest =
        #####"""
        <DIV CLASS="foo">
        
        *Markdown*
        
        </DIV>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<DIV CLASS="foo">
      //<p><em>Markdown</em></p>
      //</DIV>
        let normalizedCM = #####"""
        <DIV CLASS="foo"><p><em>Markdown</em></p></DIV>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The tag on the first line can be partial, as long
    // as it is split where there would be whitespace:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2194-2202
    func testExample123() {
        let markdownTest =
        #####"""
        <div id="foo"
          class="bar">
        </div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div id="foo"
      //  class="bar">
      //</div>
        let normalizedCM = #####"""
        <div id="foo"
          class="bar"></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2205-2213
    func testExample124() {
        let markdownTest =
        #####"""
        <div id="foo" class="bar
          baz">
        </div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div id="foo" class="bar
      //  baz">
      //</div>
        let normalizedCM = #####"""
        <div id="foo" class="bar
          baz"></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // An open tag need not be closed:
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2217-2226
    func testExample125() {
        let markdownTest =
        #####"""
        <div>
        *foo*
        
        *bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div>
      //*foo*
      //<p><em>bar</em></p>
        let normalizedCM = #####"""
        <div>
        *foo*
        <p><em>bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A partial tag need not even be completed (garbage
    // in, garbage out):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2233-2239
    func testExample126() {
        let markdownTest =
        #####"""
        <div id="foo"
        *hi*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div id="foo"
      //*hi*
        let normalizedCM = #####"""
        <div id="foo"
        *hi*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2242-2248
    func testExample127() {
        let markdownTest =
        #####"""
        <div class
        foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div class
      //foo
        let normalizedCM = #####"""
        <div class
        foo
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The initial tag doesn't even need to be a valid
    // tag, as long as it starts like one:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2254-2260
    func testExample128() {
        let markdownTest =
        #####"""
        <div *???-&&&-<---
        *foo*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div *???-&&&-<---
      //*foo*
        let normalizedCM = #####"""
        <div *???-&&&-<---
        *foo*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In type 6 blocks, the initial tag need not be on a line by
    // itself:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2266-2270
    func testExample129() {
        let markdownTest =
        #####"""
        <div><a href="bar">*foo*</a></div>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<div><a href="bar">*foo*</a></div>
        let normalizedCM = #####"""
        <div><a href="bar">*foo*</a></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2273-2281
    func testExample130() {
        let markdownTest =
        #####"""
        <table><tr><td>
        foo
        </td></tr></table>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table><tr><td>
      //foo
      //</td></tr></table>
        let normalizedCM = #####"""
        <table><tr><td>
        foo
        </td></tr></table>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Everything until the next blank line or end of document
    // gets included in the HTML block.  So, in the following
    // example, what looks like a Markdown code block
    // is actually part of the HTML block, which continues until a blank
    // line or the end of the document is reached:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2290-2300
    func testExample131() {
        let markdownTest =
        #####"""
        <div></div>
        ``` c
        int x = 33;
        ```\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div></div>
      //``` c
      //int x = 33;
      //```
        let normalizedCM = #####"""
        <div></div>
        ``` c
        int x = 33;
        ```
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // To start an [HTML block] with a tag that is *not* in the
    // list of block-level tags in (6), you must put the tag by
    // itself on the first line (and it must be complete):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2307-2315
    func testExample132() {
        let markdownTest =
        #####"""
        <a href="foo">
        *bar*
        </a>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<a href="foo">
      //*bar*
      //</a>
        let normalizedCM = #####"""
        <a href="foo">
        *bar*
        </a>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In type 7 blocks, the [tag name] can be anything:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2320-2328
    func testExample133() {
        let markdownTest =
        #####"""
        <Warning>
        *bar*
        </Warning>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<Warning>
      //*bar*
      //</Warning>
        let normalizedCM = #####"""
        <Warning>
        *bar*
        </Warning>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2331-2339
    func testExample134() {
        let markdownTest =
        #####"""
        <i class="foo">
        *bar*
        </i>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<i class="foo">
      //*bar*
      //</i>
        let normalizedCM = #####"""
        <i class="foo">
        *bar*
        </i>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2342-2348
    func testExample135() {
        let markdownTest =
        #####"""
        </ins>
        *bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //</ins>
      //*bar*
        let normalizedCM = #####"""
        </ins>
        *bar*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These rules are designed to allow us to work with tags that
    // can function as either block-level or inline-level tags.
    // The `<del>` tag is a nice example.  We can surround content with
    // `<del>` tags in three different ways.  In this case, we get a raw
    // HTML block, because the `<del>` tag is on a line by itself:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2357-2365
    func testExample136() {
        let markdownTest =
        #####"""
        <del>
        *foo*
        </del>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<del>
      //*foo*
      //</del>
        let normalizedCM = #####"""
        <del>
        *foo*
        </del>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In this case, we get a raw HTML block that just includes
    // the `<del>` tag (because it ends with the following blank
    // line).  So the contents get interpreted as CommonMark:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2372-2382
    func testExample137() {
        let markdownTest =
        #####"""
        <del>
        
        *foo*
        
        </del>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<del>
      //<p><em>foo</em></p>
      //</del>
        let normalizedCM = #####"""
        <del><p><em>foo</em></p></del>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Finally, in this case, the `<del>` tags are interpreted
    // as [raw HTML] *inside* the CommonMark paragraph.  (Because
    // the tag is not on a line by itself, we get inline HTML
    // rather than an [HTML block].)
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2390-2394
    func testExample138() {
        let markdownTest =
        #####"""
        <del>*foo*</del>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><del><em>foo</em></del></p>
        let normalizedCM = #####"""
        <p><del><em>foo</em></del></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // HTML tags designed to contain literal content
    // (`script`, `style`, `pre`), comments, processing instructions,
    // and declarations are treated somewhat differently.
    // Instead of ending at the first blank line, these blocks
    // end at the first line containing a corresponding end tag.
    // As a result, these blocks can contain blank lines:
    // 
    // A pre tag (type 1):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2406-2422
    func testExample139() {
        let markdownTest =
        #####"""
        <pre language="haskell"><code>
        import Text.HTML.TagSoup
        
        main :: IO ()
        main = print $ parseTags tags
        </code></pre>
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre language="haskell"><code>
      //import Text.HTML.TagSoup
      //
      //main :: IO ()
      //main = print $ parseTags tags
      //</code></pre>
      //<p>okay</p>
        let normalizedCM = #####"""
        <pre language="haskell"><code>
        import Text.HTML.TagSoup
        
        main :: IO ()
        main = print $ parseTags tags
        </code></pre><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A script tag (type 1):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2427-2441
    func testExample140() {
        let markdownTest =
        #####"""
        <script type="text/javascript">
        // JavaScript example
        
        document.getElementById("demo").innerHTML = "Hello JavaScript!";
        </script>
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<script type="text/javascript">
      //// JavaScript example
      //
      //document.getElementById("demo").innerHTML = "Hello JavaScript!";
      //</script>
      //<p>okay</p>
        let normalizedCM = #####"""
        <script type="text/javascript">
        // JavaScript example
        
        document.getElementById("demo").innerHTML = "Hello JavaScript!";
        </script><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A style tag (type 1):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2446-2462
    func testExample141() {
        let markdownTest =
        #####"""
        <style
          type="text/css">
        h1 {color:red;}
        
        p {color:blue;}
        </style>
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<style
      //  type="text/css">
      //h1 {color:red;}
      //
      //p {color:blue;}
      //</style>
      //<p>okay</p>
        let normalizedCM = #####"""
        <style
          type="text/css">
        h1 {color:red;}
        
        p {color:blue;}
        </style><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If there is no matching end tag, the block will end at the
    // end of the document (or the enclosing [block quote][block quotes]
    // or [list item][list items]):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2469-2479
    func testExample142() {
        let markdownTest =
        #####"""
        <style
          type="text/css">
        
        foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<style
      //  type="text/css">
      //
      //foo
        let normalizedCM = #####"""
        <style
          type="text/css">
        
        foo
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2482-2493
    func testExample143() {
        let markdownTest =
        #####"""
        > <div>
        > foo
        
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<div>
      //foo
      //</blockquote>
      //<p>bar</p>
        let normalizedCM = #####"""
        <blockquote><div>
        foo
        </blockquote><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2496-2506
    func testExample144() {
        let markdownTest =
        #####"""
        - <div>
        - foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>
      //<div>
      //</li>
      //<li>foo</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><div></li><li>foo</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The end tag can occur on the same line as the start tag:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2511-2517
    func testExample145() {
        let markdownTest =
        #####"""
        <style>p{color:red;}</style>
        *foo*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<style>p{color:red;}</style>
      //<p><em>foo</em></p>
        let normalizedCM = #####"""
        <style>p{color:red;}</style><p><em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2520-2526
    func testExample146() {
        let markdownTest =
        #####"""
        <!-- foo -->*bar*
        *baz*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<!-- foo -->*bar*
      //<p><em>baz</em></p>
        let normalizedCM = #####"""
        <!-- foo -->*bar*
        <p><em>baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that anything on the last line after the
    // end tag will be included in the [HTML block]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2532-2540
    func testExample147() {
        let markdownTest =
        #####"""
        <script>
        foo
        </script>1. *bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<script>
      //foo
      //</script>1. *bar*
        let normalizedCM = #####"""
        <script>
        foo
        </script>1. *bar*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A comment (type 2):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2545-2557
    func testExample148() {
        let markdownTest =
        #####"""
        <!-- Foo
        
        bar
           baz -->
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<!-- Foo
      //
      //bar
      //   baz -->
      //<p>okay</p>
        let normalizedCM = #####"""
        <!-- Foo
        
        bar
           baz --><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A processing instruction (type 3):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2563-2577
    func testExample149() {
        let markdownTest =
        #####"""
        <?php
        
          echo '>';
        
        ?>
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<?php
      //
      //  echo '>';
      //
      //?>
      //<p>okay</p>
        let normalizedCM = #####"""
        <?php
        
          echo '>';
        
        ?><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A declaration (type 4):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2582-2586
    func testExample150() {
        let markdownTest =
        #####"""
        <!DOCTYPE html>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<!DOCTYPE html>
        let normalizedCM = #####"""
        <!DOCTYPE html>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // CDATA (type 5):
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2591-2619
    func testExample151() {
        let markdownTest =
        #####"""
        <![CDATA[
        function matchwo(a,b)
        {
          if (a < b && a < 0) then {
            return 1;
        
          } else {
        
            return 0;
          }
        }
        ]]>
        okay\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<![CDATA[
      //function matchwo(a,b)
      //{
      //  if (a < b && a < 0) then {
      //    return 1;
      //
      //  } else {
      //
      //    return 0;
      //  }
      //}
      //]]>
      //<p>okay</p>
        let normalizedCM = #####"""
        <![CDATA[
        function matchwo(a,b)
        {
          if (a < b && a < 0) then {
            return 1;
        
          } else {
        
            return 0;
          }
        }
        ]]><p>okay</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The opening tag can be indented 1-3 spaces, but not 4:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2624-2632
    func testExample152() {
        let markdownTest =
        #####"""
          <!-- foo -->
        
            <!-- foo -->\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //  <!-- foo -->
      //<pre><code>&lt;!-- foo --&gt;
      //</code></pre>
        let normalizedCM = #####"""
          <!-- foo --><pre><code>&lt;!-- foo --&gt;
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2635-2643
    func testExample153() {
        let markdownTest =
        #####"""
          <div>
        
            <div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //  <div>
      //<pre><code>&lt;div&gt;
      //</code></pre>
        let normalizedCM = #####"""
          <div><pre><code>&lt;div&gt;
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // An HTML block of types 1--6 can interrupt a paragraph, and need not be
    // preceded by a blank line.
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2649-2659
    func testExample154() {
        let markdownTest =
        #####"""
        Foo
        <div>
        bar
        </div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo</p>
      //<div>
      //bar
      //</div>
        let normalizedCM = #####"""
        <p>Foo</p><div>
        bar
        </div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, a following blank line is needed, except at the end of
    // a document, and except for blocks of types 1--5, [above][HTML
    // block]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2666-2676
    func testExample155() {
        let markdownTest =
        #####"""
        <div>
        bar
        </div>
        *foo*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div>
      //bar
      //</div>
      //*foo*
        let normalizedCM = #####"""
        <div>
        bar
        </div>
        *foo*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // HTML blocks of type 7 cannot interrupt a paragraph:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2681-2689
    func testExample156() {
        let markdownTest =
        #####"""
        Foo
        <a href="bar">
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //<a href="bar">
      //baz</p>
        let normalizedCM = #####"""
        <p>Foo <a href="bar"> baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This rule differs from John Gruber's original Markdown syntax
    // specification, which says:
    // 
    // > The only restrictions are that block-level HTML elements —
    // > e.g. `<div>`, `<table>`, `<pre>`, `<p>`, etc. — must be separated from
    // > surrounding content by blank lines, and the start and end tags of the
    // > block should not be indented with tabs or spaces.
    // 
    // In some ways Gruber's rule is more restrictive than the one given
    // here:
    // 
    // - It requires that an HTML block be preceded by a blank line.
    // - It does not allow the start tag to be indented.
    // - It requires a matching end tag, which it also does not allow to
    //   be indented.
    // 
    // Most Markdown implementations (including some of Gruber's own) do not
    // respect all of these restrictions.
    // 
    // There is one respect, however, in which Gruber's rule is more liberal
    // than the one given here, since it allows blank lines to occur inside
    // an HTML block.  There are two reasons for disallowing them here.
    // First, it removes the need to parse balanced tags, which is
    // expensive and can require backtracking from the end of the document
    // if no matching end tag is found. Second, it provides a very simple
    // and flexible way of including Markdown content inside HTML tags:
    // simply separate the Markdown from the HTML using blank lines:
    // 
    // Compare:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2722-2732
    func testExample157() {
        let markdownTest =
        #####"""
        <div>
        
        *Emphasized* text.
        
        </div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div>
      //<p><em>Emphasized</em> text.</p>
      //</div>
        let normalizedCM = #####"""
        <div><p><em>Emphasized</em> text.</p></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2735-2743
    func testExample158() {
        let markdownTest =
        #####"""
        <div>
        *Emphasized* text.
        </div>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<div>
      //*Emphasized* text.
      //</div>
        let normalizedCM = #####"""
        <div>
        *Emphasized* text.
        </div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Some Markdown implementations have adopted a convention of
    // interpreting content inside tags as text if the open tag has
    // the attribute `markdown=1`.  The rule given above seems a simpler and
    // more elegant way of achieving the same expressive power, which is also
    // much simpler to parse.
    // 
    // The main potential drawback is that one can no longer paste HTML
    // blocks into Markdown documents with 100% reliability.  However,
    // *in most cases* this will work fine, because the blank lines in
    // HTML are usually followed by HTML block tags.  For example:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2757-2777
    func testExample159() {
        let markdownTest =
        #####"""
        <table>
        
        <tr>
        
        <td>
        Hi
        </td>
        
        </tr>
        
        </table>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table>
      //<tr>
      //<td>
      //Hi
      //</td>
      //</tr>
      //</table>
        let normalizedCM = #####"""
        <table><tr><td>
        Hi
        </td></tr></table>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // There are problems, however, if the inner tags are indented
    // *and* separated by spaces, as then they will be interpreted as
    // an indented code block:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 2784-2805
    func testExample160() {
        let markdownTest =
        #####"""
        <table>
        
          <tr>
        
            <td>
              Hi
            </td>
        
          </tr>
        
        </table>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<table>
      //  <tr>
      //<pre><code>&lt;td&gt;
      //  Hi
      //&lt;/td&gt;
      //</code></pre>
      //  </tr>
      //</table>
        let normalizedCM = #####"""
        <table>
          <tr><pre><code>&lt;td&gt;
          Hi
        &lt;/td&gt;
        </code></pre>
          </tr></table>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension HtmlBlocksTests {
    static var allTests: Linux.TestList<HtmlBlocksTests> {
        return [
        ("testExample118", testExample118),
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
        ("testExample147", testExample147),
        ("testExample148", testExample148),
        ("testExample149", testExample149),
        ("testExample150", testExample150),
        ("testExample151", testExample151),
        ("testExample152", testExample152),
        ("testExample153", testExample153),
        ("testExample154", testExample154),
        ("testExample155", testExample155),
        ("testExample156", testExample156),
        ("testExample157", testExample157),
        ("testExample158", testExample158),
        ("testExample159", testExample159),
        ("testExample160", testExample160)
        ]
    }
}