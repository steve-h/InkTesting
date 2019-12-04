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

final class SetextHeadingsTests: XCTestCase {

    // 
    // 
    // ## Setext headings
    // 
    // A [setext heading](@) consists of one or more
    // lines of text, each containing at least one [non-whitespace
    // character], with no more than 3 spaces indentation, followed by
    // a [setext heading underline].  The lines of text must be such
    // that, were they not followed by the setext heading underline,
    // they would be interpreted as a paragraph:  they cannot be
    // interpretable as a [code fence], [ATX heading][ATX headings],
    // [block quote][block quotes], [thematic break][thematic breaks],
    // [list item][list items], or [HTML block][HTML blocks].
    // 
    // A [setext heading underline](@) is a sequence of
    // `=` characters or a sequence of `-` characters, with no more than 3
    // spaces indentation and any number of trailing spaces.  If a line
    // containing a single `-` can be interpreted as an
    // empty [list items], it should be interpreted this way
    // and not as a [setext heading underline].
    // 
    // The heading is a level 1 heading if `=` characters are used in
    // the [setext heading underline], and a level 2 heading if `-`
    // characters are used.  The contents of the heading are the result
    // of parsing the preceding lines of text as CommonMark inline
    // content.
    // 
    // In general, a setext heading need not be preceded or followed by a
    // blank line.  However, it cannot interrupt a paragraph, so when a
    // setext heading comes after a paragraph, a blank line is needed between
    // them.
    // 
    // Simple examples:
    // 
    // 
    //     
    // spec.txt lines 1349-1358
    func testExample80() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo *bar*
        =========
        
        Foo *bar*
        ---------
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The content of the header may span more than one line:
    // 
    // 
    //     
    // spec.txt lines 1363-1370
    func testExample81() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo *bar
        baz*
        ====
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h1>Foo <em>bar
baz</em></h1>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // The contents are the result of parsing the headings's raw
    // content as inlines.  The heading's raw content is formed by
    // concatenating the lines and removing initial and final
    // [whitespace].
    // 
    // 
    //     
    // spec.txt lines 1377-1384
    func testExample82() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
          Foo *bar
        baz*	
        ====
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h1>Foo <em>bar
baz</em></h1>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The underlining can be any length:
    // 
    // 
    //     
    // spec.txt lines 1389-1398
    func testExample83() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        -------------------------
        
        Foo
        =
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo</h2>
<h1>Foo</h1>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The heading content can be indented up to three spaces, and need
    // not line up with the underlining:
    // 
    // 
    //     
    // spec.txt lines 1404-1417
    func testExample84() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           Foo
        ---
        
          Foo
        -----
        
          Foo
          ===
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo</h2>
<h2>Foo</h2>
<h1>Foo</h1>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Four spaces indent is too much:
    // 
    // 
    //     
    // spec.txt lines 1422-1435
    func testExample85() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            Foo
            ---
        
            Foo
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>Foo
---

Foo
</code></pre>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The setext heading underline can be indented up to three spaces, and
    // may have trailing spaces:
    // 
    // 
    //     
    // spec.txt lines 1441-1446
    func testExample86() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
           ----      
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo</h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Four spaces is too much:
    // 
    // 
    //     
    // spec.txt lines 1451-1457
    func testExample87() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
            ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
---</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The setext heading underline cannot contain internal spaces:
    // 
    // 
    //     
    // spec.txt lines 1462-1473
    func testExample88() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        = =
        
        Foo
        --- -
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
= =</p>
<p>Foo</p>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Trailing spaces in the content line do not cause a line break:
    // 
    // 
    //     
    // spec.txt lines 1478-1483
    func testExample89() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo  
        -----
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo</h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Nor does a backslash at the end:
    // 
    // 
    //     
    // spec.txt lines 1488-1493
    func testExample90() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo\
        ----
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo\</h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Since indicators of block structure take precedence over
    // indicators of inline structure, the following are setext headings:
    // 
    // 
    //     
    // spec.txt lines 1499-1512
    func testExample91() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `Foo
        ----
        `
        
        <a title="a lot
        ---
        of dashes"/>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>`Foo</h2>
<p>`</p>
<h2>&lt;a title="a lot</h2>
<p>of dashes"/&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // The setext heading underline cannot be a [lazy continuation
    // line] in a list item or block quote:
    // 
    // 
    //     
    // spec.txt lines 1518-1526
    func testExample92() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > Foo
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<blockquote>
<p>Foo</p>
</blockquote>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1529-1539
    func testExample93() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        bar
        ===
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<blockquote>
<p>foo
bar
===</p>
</blockquote>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1542-1550
    func testExample94() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - Foo
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<ul>
<li>Foo</li>
</ul>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // A blank line is needed between a paragraph and a following
    // setext heading, since otherwise the paragraph becomes part
    // of the heading's content:
    // 
    // 
    //     
    // spec.txt lines 1557-1564
    func testExample95() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        Bar
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>Foo
Bar</h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // But in general a blank line is not required before or after
    // setext headings:
    // 
    // 
    //     
    // spec.txt lines 1570-1582
    func testExample96() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ---
        Foo
        ---
        Bar
        ---
        Baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<hr>
<h2>Foo</h2>
<h2>Bar</h2>
<p>Baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Setext headings cannot be empty:
    // 
    // 
    //     
    // spec.txt lines 1587-1592
    func testExample97() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        
        ====
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>====</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Setext heading text lines must not be interpretable as block
    // constructs other than paragraphs.  So, the line of dashes
    // in these examples gets interpreted as a thematic break:
    // 
    // 
    //     
    // spec.txt lines 1599-1605
    func testExample98() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ---
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<hr>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1608-1616
    func testExample99() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        - foo
        -----
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<ul>
<li>foo</li>
</ul>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1619-1626
    func testExample100() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            foo
        ---
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<pre><code>foo
</code></pre>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1629-1637
    func testExample101() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        > foo
        -----
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<blockquote>
<p>foo</p>
</blockquote>
<hr>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // If you want a heading with `> foo` as its literal text, you can
    // use backslash escapes:
    // 
    // 
    //     
    // spec.txt lines 1643-1648
    func testExample102() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        \> foo
        ------
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<h2>&gt; foo</h2>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // **Compatibility note:**  Most existing Markdown implementations
    // do not allow the text of setext headings to span multiple lines.
    // But there is no consensus about how to interpret
    // 
    // ``` markdown
    // Foo
    // bar
    // ---
    // baz
    // ```
    // 
    // One can find four different interpretations:
    // 
    // 1. paragraph "Foo", heading "bar", paragraph "baz"
    // 2. paragraph "Foo bar", thematic break, paragraph "baz"
    // 3. paragraph "Foo bar --- baz"
    // 4. heading "Foo bar", paragraph "baz"
    // 
    // We find interpretation 4 most natural, and interpretation 4
    // increases the expressive power of CommonMark, by allowing
    // multiline headings.  Authors who want interpretation 1 can
    // put a blank line after the first paragraph:
    // 
    // 
    //     
    // spec.txt lines 1674-1684
    func testExample103() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        
        bar
        ---
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo</p>
<h2>bar</h2>
<p>baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Authors who want interpretation 2 can put blank lines around
    // the thematic break,
    // 
    // 
    //     
    // spec.txt lines 1690-1702
    func testExample104() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        bar
        
        ---
        
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
bar</p>
<hr>
<p>baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // or use a thematic break that cannot count as a [setext heading
    // underline], such as
    // 
    // 
    //     
    // spec.txt lines 1708-1718
    func testExample105() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        bar
        * * *
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
bar</p>
<hr>
<p>baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Authors who want interpretation 3 can use backslash escapes:
    // 
    // 
    //     
    // spec.txt lines 1723-1733
    func testExample106() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        bar
        \---
        baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>Foo
bar
---
baz</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension SetextHeadingsTests {
    static var allTests: Linux.TestList<SetextHeadingsTests> {
        return [
        ("testExample80", testExample80),
        ("testExample81", testExample81),
        ("testExample82", testExample82),
        ("testExample83", testExample83),
        ("testExample84", testExample84),
        ("testExample85", testExample85),
        ("testExample86", testExample86),
        ("testExample87", testExample87),
        ("testExample88", testExample88),
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
        ("testExample106", testExample106)
        ]
    }
}