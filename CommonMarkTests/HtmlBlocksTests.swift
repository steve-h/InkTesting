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

final class HtmlBlocksTests: XCTestCase {

    // 
    // 
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2087-2102
    func testExample118() {
        var markdownTest =
        #####"""
        <table><tr><td>
        <pre>
        **Hello**,
        
        _world_.
        </pre>
        </td></tr></table>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2116-2135
    func testExample119() {
        var markdownTest =
        #####"""
        <table>
          <tr>
            <td>
                   hi
            </td>
          </tr>
        </table>
        
        okay.
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2138-2146
    func testExample120() {
        var markdownTest =
        #####"""
         <div>
          *hello*
                 <foo><a>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A block can also start with a closing tag:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2151-2157
    func testExample121() {
        var markdownTest =
        #####"""
        </div>
        *foo*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //</div>
      //*foo*
        let normalizedCM = #####"""
        </div>
        *foo*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Here we have two HTML blocks with a Markdown paragraph between them:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2162-2172
    func testExample122() {
        var markdownTest =
        #####"""
        <DIV CLASS="foo">
        
        *Markdown*
        
        </DIV>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<DIV CLASS="foo">
      //<p><em>Markdown</em></p>
      //</DIV>
        let normalizedCM = #####"""
        <DIV CLASS="foo"><p><em>Markdown</em></p></DIV>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // The tag on the first line can be partial, as long
    // as it is split where there would be whitespace:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2178-2186
    func testExample123() {
        var markdownTest =
        #####"""
        <div id="foo"
          class="bar">
        </div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2189-2197
    func testExample124() {
        var markdownTest =
        #####"""
        <div id="foo" class="bar
          baz">
        </div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div id="foo" class="bar
      //  baz">
      //</div>
        let normalizedCM = #####"""
        <div id="foo" class="bar
          baz"></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // An open tag need not be closed:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2201-2210
    func testExample125() {
        var markdownTest =
        #####"""
        <div>
        *foo*
        
        *bar*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // 
    // A partial tag need not even be completed (garbage
    // in, garbage out):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2217-2223
    func testExample126() {
        var markdownTest =
        #####"""
        <div id="foo"
        *hi*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div id="foo"
      //*hi*
        let normalizedCM = #####"""
        <div id="foo"
        *hi*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2226-2232
    func testExample127() {
        var markdownTest =
        #####"""
        <div class
        foo
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div class
      //foo
        let normalizedCM = #####"""
        <div class
        foo
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // The initial tag doesn't even need to be a valid
    // tag, as long as it starts like one:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2238-2244
    func testExample128() {
        var markdownTest =
        #####"""
        <div *???-&&&-<---
        *foo*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div *???-&&&-<---
      //*foo*
        let normalizedCM = #####"""
        <div *???-&&&-<---
        *foo*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // In type 6 blocks, the initial tag need not be on a line by
    // itself:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2250-2254
    func testExample129() {
        var markdownTest =
        #####"""
        <div><a href="bar">*foo*</a></div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div><a href="bar">*foo*</a></div>
        let normalizedCM = #####"""
        <div><a href="bar">*foo*</a></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2257-2265
    func testExample130() {
        var markdownTest =
        #####"""
        <table><tr><td>
        foo
        </td></tr></table>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // Everything until the next blank line or end of document
    // gets included in the HTML block.  So, in the following
    // example, what looks like a Markdown code block
    // is actually part of the HTML block, which continues until a blank
    // line or the end of the document is reached:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2274-2284
    func testExample131() {
        var markdownTest =
        #####"""
        <div></div>
        ``` c
        int x = 33;
        ```
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // To start an [HTML block] with a tag that is *not* in the
    // list of block-level tags in (6), you must put the tag by
    // itself on the first line (and it must be complete):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2291-2299
    func testExample132() {
        var markdownTest =
        #####"""
        <a href="foo">
        *bar*
        </a>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // In type 7 blocks, the [tag name] can be anything:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2304-2312
    func testExample133() {
        var markdownTest =
        #####"""
        <Warning>
        *bar*
        </Warning>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2315-2323
    func testExample134() {
        var markdownTest =
        #####"""
        <i class="foo">
        *bar*
        </i>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2326-2332
    func testExample135() {
        var markdownTest =
        #####"""
        </ins>
        *bar*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //</ins>
      //*bar*
        let normalizedCM = #####"""
        </ins>
        *bar*
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // These rules are designed to allow us to work with tags that
    // can function as either block-level or inline-level tags.
    // The `<del>` tag is a nice example.  We can surround content with
    // `<del>` tags in three different ways.  In this case, we get a raw
    // HTML block, because the `<del>` tag is on a line by itself:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2341-2349
    func testExample136() {
        var markdownTest =
        #####"""
        <del>
        *foo*
        </del>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // In this case, we get a raw HTML block that just includes
    // the `<del>` tag (because it ends with the following blank
    // line).  So the contents get interpreted as CommonMark:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2356-2366
    func testExample137() {
        var markdownTest =
        #####"""
        <del>
        
        *foo*
        
        </del>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<del>
      //<p><em>foo</em></p>
      //</del>
        let normalizedCM = #####"""
        <del><p><em>foo</em></p></del>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Finally, in this case, the `<del>` tags are interpreted
    // as [raw HTML] *inside* the CommonMark paragraph.  (Because
    // the tag is not on a line by itself, we get inline HTML
    // rather than an [HTML block].)
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2374-2378
    func testExample138() {
        var markdownTest =
        #####"""
        <del>*foo*</del>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><del><em>foo</em></del></p>
        let normalizedCM = #####"""
        <p><del><em>foo</em></del></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2390-2406
    func testExample139() {
        var markdownTest =
        #####"""
        <pre language="haskell"><code>
        import Text.HTML.TagSoup
        
        main :: IO ()
        main = print $ parseTags tags
        </code></pre>
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A script tag (type 1):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2411-2425
    func testExample140() {
        var markdownTest =
        #####"""
        <script type="text/javascript">
        // JavaScript example
        
        document.getElementById("demo").innerHTML = "Hello JavaScript!";
        </script>
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A style tag (type 1):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2430-2446
    func testExample141() {
        var markdownTest =
        #####"""
        <style
          type="text/css">
        h1 {color:red;}
        
        p {color:blue;}
        </style>
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // If there is no matching end tag, the block will end at the
    // end of the document (or the enclosing [block quote][block quotes]
    // or [list item][list items]):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2453-2463
    func testExample142() {
        var markdownTest =
        #####"""
        <style
          type="text/css">
        
        foo
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2466-2477
    func testExample143() {
        var markdownTest =
        #####"""
        > <div>
        > foo
        
        bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2480-2490
    func testExample144() {
        var markdownTest =
        #####"""
        - <div>
        - foo
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // The end tag can occur on the same line as the start tag:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2495-2501
    func testExample145() {
        var markdownTest =
        #####"""
        <style>p{color:red;}</style>
        *foo*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<style>p{color:red;}</style>
      //<p><em>foo</em></p>
        let normalizedCM = #####"""
        <style>p{color:red;}</style><p><em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2504-2510
    func testExample146() {
        var markdownTest =
        #####"""
        <!-- foo -->*bar*
        *baz*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<!-- foo -->*bar*
      //<p><em>baz</em></p>
        let normalizedCM = #####"""
        <!-- foo -->*bar*
        <p><em>baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Note that anything on the last line after the
    // end tag will be included in the [HTML block]:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2516-2524
    func testExample147() {
        var markdownTest =
        #####"""
        <script>
        foo
        </script>1. *bar*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A comment (type 2):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2529-2541
    func testExample148() {
        var markdownTest =
        #####"""
        <!-- Foo
        
        bar
           baz -->
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // 
    // A processing instruction (type 3):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2547-2561
    func testExample149() {
        var markdownTest =
        #####"""
        <?php
        
          echo '>';
        
        ?>
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // A declaration (type 4):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2566-2570
    func testExample150() {
        var markdownTest =
        #####"""
        <!DOCTYPE html>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<!DOCTYPE html>
        let normalizedCM = #####"""
        <!DOCTYPE html>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // CDATA (type 5):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2575-2603
    func testExample151() {
        var markdownTest =
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
        okay
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // The opening tag can be indented 1-3 spaces, but not 4:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2608-2616
    func testExample152() {
        var markdownTest =
        #####"""
          <!-- foo -->
        
            <!-- foo -->
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2619-2627
    func testExample153() {
        var markdownTest =
        #####"""
          <div>
        
            <div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //  <div>
      //<pre><code>&lt;div&gt;
      //</code></pre>
        let normalizedCM = #####"""
          <div><pre><code>&lt;div&gt;
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // An HTML block of types 1--6 can interrupt a paragraph, and need not be
    // preceded by a blank line.
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2633-2643
    func testExample154() {
        var markdownTest =
        #####"""
        Foo
        <div>
        bar
        </div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // However, a following blank line is needed, except at the end of
    // a document, and except for blocks of types 1--5, [above][HTML
    // block]:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2650-2660
    func testExample155() {
        var markdownTest =
        #####"""
        <div>
        bar
        </div>
        *foo*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // HTML blocks of type 7 cannot interrupt a paragraph:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2665-2673
    func testExample156() {
        var markdownTest =
        #####"""
        Foo
        <a href="bar">
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo
      //<a href="bar">
      //baz</p>
        let normalizedCM = #####"""
        <p>Foo <a href="bar"> baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2706-2716
    func testExample157() {
        var markdownTest =
        #####"""
        <div>
        
        *Emphasized* text.
        
        </div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<div>
      //<p><em>Emphasized</em> text.</p>
      //</div>
        let normalizedCM = #####"""
        <div><p><em>Emphasized</em> text.</p></div>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2719-2727
    func testExample158() {
        var markdownTest =
        #####"""
        <div>
        *Emphasized* text.
        </div>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
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
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2741-2761
    func testExample159() {
        var markdownTest =
        #####"""
        <table>
        
        <tr>
        
        <td>
        Hi
        </td>
        
        </tr>
        
        </table>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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
    // 
    // 
    // There are problems, however, if the inner tags are indented
    // *and* separated by spaces, as then they will be interpreted as
    // an indented code block:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 2768-2789
    func testExample160() {
        var markdownTest =
        #####"""
        <table>
        
          <tr>
        
            <td>
              Hi
            </td>
        
          </tr>
        
        </table>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
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