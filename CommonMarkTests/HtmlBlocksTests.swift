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
    // followed by an ASCII letter.\
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
    // spec.txt lines 2430-2445
    func testExample148() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <table><tr><td>
        <pre>
        **Hello**,
        
        _world_.
        </pre>
        </td></tr></table>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<table><tbody><tr><td>
<pre>
**Hello**,
<p><em>world</em>.
</p></pre><p></p>
</td></tr></tbody></table>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 2459-2478
    func testExample149() {
        let newlineChar = "\n"
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
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<table>
  <tbody><tr>
    <td>
           hi
    </td>
  </tr>
</tbody></table>
<p>okay.</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2481-2489
    func testExample150() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         <div>
          *hello*
                 <foo><a>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
 <div>
  *hello*
         <foo><a>
</a></foo></div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A block can also start with a closing tag:
    // 
    // 
    //     
    // spec.txt lines 2494-2500
    func testExample151() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        </div>
        *foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

*foo*
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Here we have two HTML blocks with a Markdown paragraph between them:
    // 
    // 
    //     
    // spec.txt lines 2505-2515
    func testExample152() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <DIV CLASS="foo">
        
        *Markdown*
        
        </DIV>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div class="foo">
<p><em>Markdown</em></p>
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The tag on the first line can be partial, as long
    // as it is split where there would be whitespace:
    // 
    // 
    //     
    // spec.txt lines 2521-2529
    func testExample153() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div id="foo"
          class="bar">
        </div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div id="foo" class="bar">
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2532-2540
    func testExample154() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div id="foo" class="bar
          baz">
        </div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div id="foo" class="bar
  baz">
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // An open tag need not be closed:
    // 
    //     
    // spec.txt lines 2544-2553
    func testExample155() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div>
        *foo*
        
        *bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div>
*foo*
<p><em>bar</em></p>
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    // A partial tag need not even be completed (garbage
    // in, garbage out):
    // 
    // 
    //     
    // spec.txt lines 2560-2566
    func testExample156() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div id="foo"
        *hi*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2569-2575
    func testExample157() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div class
        foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The initial tag doesn't even need to be a valid
    // tag, as long as it starts like one:
    // 
    // 
    //     
    // spec.txt lines 2581-2587
    func testExample158() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div *???-&&&-<---
        *foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // In type 6 blocks, the initial tag need not be on a line by
    // itself:
    // 
    // 
    //     
    // spec.txt lines 2593-2597
    func testExample159() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div><a href="bar">*foo*</a></div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div><a href="bar">*foo*</a></div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2600-2608
    func testExample160() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <table><tr><td>
        foo
        </td></tr></table>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<table><tbody><tr><td>
foo
</td></tr></tbody></table>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 2617-2627
    func testExample161() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div></div>
        ``` c
        int x = 33;
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div></div>
``` c
int x = 33;
```
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // To start an [HTML block] with a tag that is *not* in the
    // list of block-level tags in (6), you must put the tag by
    // itself on the first line (and it must be complete):
    // 
    // 
    //     
    // spec.txt lines 2634-2642
    func testExample162() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="foo">
        *bar*
        </a>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<a href="foo">
*bar*
</a>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // In type 7 blocks, the [tag name] can be anything:
    // 
    // 
    //     
    // spec.txt lines 2647-2655
    func testExample163() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <Warning>
        *bar*
        </Warning>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<warning>
*bar*
</warning>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2658-2666
    func testExample164() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <i class="foo">
        *bar*
        </i>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<i class="foo">
*bar*
</i>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2669-2675
    func testExample165() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        </ins>
        *bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

*bar*
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 2684-2692
    func testExample166() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <del>
        *foo*
        </del>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<del>
*foo*
</del>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // In this case, we get a raw HTML block that just includes
    // the `<del>` tag (because it ends with the following blank
    // line).  So the contents get interpreted as CommonMark:
    // 
    // 
    //     
    // spec.txt lines 2699-2709
    func testExample167() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <del>
        
        *foo*
        
        </del>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<del>
<p><em>foo</em></p>
</del>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 2717-2721
    func testExample168() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <del>*foo*</del>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><del><em>foo</em></del></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 2733-2749
    func testExample169() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <pre language="haskell"><code>
        import Text.HTML.TagSoup
        
        main :: IO ()
        main = print $ parseTags tags
        </code></pre>
        okay
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print $ parseTags tags
</code></pre>
<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A script tag (type 1):
    // 
    // 
    //     
    // spec.txt lines 2754-2768
    func testExample170() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <script type="text/javascript">
        // JavaScript example
        
        document.getElementById("demo").innerHTML = "Hello JavaScript!";
        </script>
        okay
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A style tag (type 1):
    // 
    // 
    //     
    // spec.txt lines 2773-2789
    func testExample171() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <style
          type="text/css">
        h1 {color:red;}
        
        p {color:blue;}
        </style>
        okay
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<style type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // If there is no matching end tag, the block will end at the
    // end of the document (or the enclosing [block quote][block quotes]
    // or [list item][list items]):
    // 
    // 
    //     
    // spec.txt lines 2796-2806
    func testExample172() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <style
          type="text/css">
        
        foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<style type="text/css">

foo
</style>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2809-2820
    func testExample173() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > <div>
        > foo
        
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<blockquote>
<div>
foo
</div></blockquote>
<p>bar</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2823-2833
    func testExample174() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - <div>
        - foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<ul>
<li>
<div>
</div></li>
<li>foo</li>
</ul>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The end tag can occur on the same line as the start tag:
    // 
    // 
    //     
    // spec.txt lines 2838-2844
    func testExample175() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <style>p{color:red;}</style>
        *foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<style>p{color:red;}</style>
<p><em>foo</em></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2847-2853
    func testExample176() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <!-- foo -->*bar*
        *baz*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<!-- foo -->*bar*
<p><em>baz</em></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Note that anything on the last line after the
    // end tag will be included in the [HTML block]:
    // 
    // 
    //     
    // spec.txt lines 2859-2867
    func testExample177() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <script>
        foo
        </script>1. *bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<script>
foo
</script>1. *bar*
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A comment (type 2):
    // 
    // 
    //     
    // spec.txt lines 2872-2884
    func testExample178() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <!-- Foo
        
        bar
           baz -->
        okay
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<!-- Foo

bar
   baz -->
<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    // A processing instruction (type 3):
    // 
    // 
    //     
    // spec.txt lines 2890-2904
    func testExample179() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <?php
        
          echo '>';
        
        ?>
        okay
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<!--?php

  echo '-->';

?&gt;
<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A declaration (type 4):
    // 
    // 
    //     
    // spec.txt lines 2909-2913
    func testExample180() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <!DOCTYPE html>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // CDATA (type 5):
    // 
    // 
    //     
    // spec.txt lines 2918-2946
    func testExample181() {
        let newlineChar = "\n"
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
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""

function matchwo(a,b)
{
  if (a &lt; b &amp;&amp; a &lt; 0) then {
    return 1;

  } else {

    return 0;
  }
}

<p>okay</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The opening tag can be indented 1-3 spaces, but not 4:
    // 
    // 
    //     
    // spec.txt lines 2951-2959
    func testExample182() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          <!-- foo -->
        
            <!-- foo -->
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2962-2970
    func testExample183() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          <div>
        
            <div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
  <div>
<pre><code>&lt;div&gt;
</code></pre>
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // An HTML block of types 1--6 can interrupt a paragraph, and need not be
    // preceded by a blank line.
    // 
    // 
    //     
    // spec.txt lines 2976-2986
    func testExample184() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        <div>
        bar
        </div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo</p>
<div>
bar
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // However, a following blank line is needed, except at the end of
    // a document, and except for blocks of types 1--5, [above][HTML
    // block]:
    // 
    // 
    //     
    // spec.txt lines 2993-3003
    func testExample185() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div>
        bar
        </div>
        *foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div>
bar
</div>
*foo*
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // HTML blocks of type 7 cannot interrupt a paragraph:
    // 
    // 
    //     
    // spec.txt lines 3008-3016
    func testExample186() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        <a href="bar">
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
<a href="bar">
baz</a></p><a href="bar">
</a>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 3049-3059
    func testExample187() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div>
        
        *Emphasized* text.
        
        </div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div>
<p><em>Emphasized</em> text.</p>
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3062-3070
    func testExample188() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <div>
        *Emphasized* text.
        </div>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<div>
*Emphasized* text.
</div>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

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
    // spec.txt lines 3084-3104
    func testExample189() {
        let newlineChar = "\n"
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
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<table>
<tbody><tr>
<td>
Hi
</td>
</tr>
</tbody></table>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // There are problems, however, if the inner tags are indented
    // *and* separated by spaces, as then they will be interpreted as
    // an indented code block:
    // 
    // 
    //     
    // spec.txt lines 3111-3132
    func testExample190() {
        let newlineChar = "\n"
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
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>&lt;td&gt;
  Hi
&lt;/td&gt;
</code></pre><table>
  <tbody><tr>

  </tr>
</tbody></table>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension HtmlBlocksTests {
    static var allTests: Linux.TestList<HtmlBlocksTests> {
        return [
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
        ("testExample160", testExample160),
        ("testExample161", testExample161),
        ("testExample162", testExample162),
        ("testExample163", testExample163),
        ("testExample164", testExample164),
        ("testExample165", testExample165),
        ("testExample166", testExample166),
        ("testExample167", testExample167),
        ("testExample168", testExample168),
        ("testExample169", testExample169),
        ("testExample170", testExample170),
        ("testExample171", testExample171),
        ("testExample172", testExample172),
        ("testExample173", testExample173),
        ("testExample174", testExample174),
        ("testExample175", testExample175),
        ("testExample176", testExample176),
        ("testExample177", testExample177),
        ("testExample178", testExample178),
        ("testExample179", testExample179),
        ("testExample180", testExample180),
        ("testExample181", testExample181),
        ("testExample182", testExample182),
        ("testExample183", testExample183),
        ("testExample184", testExample184),
        ("testExample185", testExample185),
        ("testExample186", testExample186),
        ("testExample187", testExample187),
        ("testExample188", testExample188),
        ("testExample189", testExample189),
        ("testExample190", testExample190)
        ]
    }
}