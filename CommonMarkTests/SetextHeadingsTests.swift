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

final class SetextHeadingsTests: XCTestCase {

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1022-1031
    func testExample50() {
        let markdownTest =
        #####"""
        Foo *bar*
        =========
        
        Foo *bar*
        ---------\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h1>Foo <em>bar</em></h1>
      //<h2>Foo <em>bar</em></h2>
        let normalizedCM = #####"""
        <h1>Foo <em>bar</em></h1><h2>Foo <em>bar</em></h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The content of the header may span more than one line:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1036-1043
    func testExample51() {
        let markdownTest =
        #####"""
        Foo *bar
        baz*
        ====\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h1>Foo <em>bar
      //baz</em></h1>
        let normalizedCM = #####"""
        <h1>Foo <em>bar baz</em></h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The contents are the result of parsing the headings's raw
    // content as inlines.  The heading's raw content is formed by
    // concatenating the lines and removing initial and final
    // [whitespace].
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1050-1057
    func testExample52() {
        let markdownTest =
        #####"""
          Foo *bar
        baz*	
        ====\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h1>Foo <em>bar
      //baz</em></h1>
        let normalizedCM = #####"""
        <h1>Foo <em>bar baz</em></h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The underlining can be any length:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1062-1071
    func testExample53() {
        let markdownTest =
        #####"""
        Foo
        -------------------------
        
        Foo
        =\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo</h2>
      //<h1>Foo</h1>
        let normalizedCM = #####"""
        <h2>Foo</h2><h1>Foo</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The heading content can be indented up to three spaces, and need
    // not line up with the underlining:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1077-1090
    func testExample54() {
        let markdownTest =
        #####"""
           Foo
        ---
        
          Foo
        -----
        
          Foo
          ===\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo</h2>
      //<h2>Foo</h2>
      //<h1>Foo</h1>
        let normalizedCM = #####"""
        <h2>Foo</h2><h2>Foo</h2><h1>Foo</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Four spaces indent is too much:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1095-1108
    func testExample55() {
        let markdownTest =
        #####"""
            Foo
            ---
        
            Foo
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>Foo
      //---
      //
      //Foo
      //</code></pre>
      //<hr />
        let normalizedCM = #####"""
        <pre><code>Foo
        ---
        
        Foo
        </code></pre><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The setext heading underline can be indented up to three spaces, and
    // may have trailing spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1114-1119
    func testExample56() {
        let markdownTest =
        #####"""
        Foo
           ----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo</h2>
        let normalizedCM = #####"""
        <h2>Foo</h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Four spaces is too much:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1124-1130
    func testExample57() {
        let markdownTest =
        #####"""
        Foo
            ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //---</p>
        let normalizedCM = #####"""
        <p>Foo ---</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The setext heading underline cannot contain internal spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1135-1146
    func testExample58() {
        let markdownTest =
        #####"""
        Foo
        = =
        
        Foo
        --- -\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //= =</p>
      //<p>Foo</p>
      //<hr />
        let normalizedCM = #####"""
        <p>Foo = =</p><p>Foo</p><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Trailing spaces in the content line do not cause a line break:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1151-1156
    func testExample59() {
        let markdownTest =
        #####"""
        Foo
        -----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo</h2>
        let normalizedCM = #####"""
        <h2>Foo</h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Nor does a backslash at the end:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1161-1166
    func testExample60() {
        let markdownTest =
        #####"""
        Foo\
        ----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo\</h2>
        let normalizedCM = #####"""
        <h2>Foo\</h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Since indicators of block structure take precedence over
    // indicators of inline structure, the following are setext headings:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1172-1185
    func testExample61() {
        let markdownTest =
        #####"""
        `Foo
        ----
        `
        
        <a title="a lot
        ---
        of dashes"/>\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>`Foo</h2>
      //<p>`</p>
      //<h2>&lt;a title=&quot;a lot</h2>
      //<p>of dashes&quot;/&gt;</p>
        let normalizedCM = #####"""
        <h2>`Foo</h2><p>`</p><h2>&lt;a title=&quot;a lot</h2><p>of dashes&quot;/&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The setext heading underline cannot be a [lazy continuation
    // line] in a list item or block quote:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1191-1199
    func testExample62() {
        let markdownTest =
        #####"""
        > Foo
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<p>Foo</p>
      //</blockquote>
      //<hr />
        let normalizedCM = #####"""
        <blockquote><p>Foo</p></blockquote><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1202-1212
    func testExample63() {
        let markdownTest =
        #####"""
        > foo
        bar
        ===\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<p>foo
      //bar
      //===</p>
      //</blockquote>
        let normalizedCM = #####"""
        <blockquote><p>foo bar ===</p></blockquote>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1215-1223
    func testExample64() {
        let markdownTest =
        #####"""
        - Foo
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>Foo</li>
      //</ul>
      //<hr />
        let normalizedCM = #####"""
        <ul><li>Foo</li></ul><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A blank line is needed between a paragraph and a following
    // setext heading, since otherwise the paragraph becomes part
    // of the heading's content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1230-1237
    func testExample65() {
        let markdownTest =
        #####"""
        Foo
        Bar
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>Foo
      //Bar</h2>
        let normalizedCM = #####"""
        <h2>Foo Bar</h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // But in general a blank line is not required before or after
    // setext headings:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1243-1255
    func testExample66() {
        let markdownTest =
        #####"""
        ---
        Foo
        ---
        Bar
        ---
        Baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<hr />
      //<h2>Foo</h2>
      //<h2>Bar</h2>
      //<p>Baz</p>
        let normalizedCM = #####"""
        <hr><h2>Foo</h2><h2>Bar</h2><p>Baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Setext headings cannot be empty:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1260-1265
    func testExample67() {
        let markdownTest =
        #####"""
        
        ====\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>====</p>
        let normalizedCM = #####"""
        <p>====</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Setext heading text lines must not be interpretable as block
    // constructs other than paragraphs.  So, the line of dashes
    // in these examples gets interpreted as a thematic break:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1272-1278
    func testExample68() {
        let markdownTest =
        #####"""
        ---
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<hr />
      //<hr />
        let normalizedCM = #####"""
        <hr><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1281-1289
    func testExample69() {
        let markdownTest =
        #####"""
        - foo
        -----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<ul>
      //<li>foo</li>
      //</ul>
      //<hr />
        let normalizedCM = #####"""
        <ul><li>foo</li></ul><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1292-1299
    func testExample70() {
        let markdownTest =
        #####"""
            foo
        ---\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<pre><code>foo
      //</code></pre>
      //<hr />
        let normalizedCM = #####"""
        <pre><code>foo
        </code></pre><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1302-1310
    func testExample71() {
        let markdownTest =
        #####"""
        > foo
        -----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<blockquote>
      //<p>foo</p>
      //</blockquote>
      //<hr />
        let normalizedCM = #####"""
        <blockquote><p>foo</p></blockquote><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If you want a heading with `> foo` as its literal text, you can
    // use backslash escapes:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1316-1321
    func testExample72() {
        let markdownTest =
        #####"""
        \> foo
        ------\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>&gt; foo</h2>
        let normalizedCM = #####"""
        <h2>&gt; foo</h2>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1347-1357
    func testExample73() {
        let markdownTest =
        #####"""
        Foo
        
        bar
        ---
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo</p>
      //<h2>bar</h2>
      //<p>baz</p>
        let normalizedCM = #####"""
        <p>Foo</p><h2>bar</h2><p>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Authors who want interpretation 2 can put blank lines around
    // the thematic break,
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1363-1375
    func testExample74() {
        let markdownTest =
        #####"""
        Foo
        bar
        
        ---
        
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //bar</p>
      //<hr />
      //<p>baz</p>
        let normalizedCM = #####"""
        <p>Foo bar</p><hr><p>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // or use a thematic break that cannot count as a [setext heading
    // underline], such as
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1381-1391
    func testExample75() {
        let markdownTest =
        #####"""
        Foo
        bar
        * * *
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //bar</p>
      //<hr />
      //<p>baz</p>
        let normalizedCM = #####"""
        <p>Foo bar</p><hr><p>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Authors who want interpretation 3 can use backslash escapes:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1396-1406
    func testExample76() {
        let markdownTest =
        #####"""
        Foo
        bar
        \---
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo
      //bar
      //---
      //baz</p>
        let normalizedCM = #####"""
        <p>Foo bar --- baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension SetextHeadingsTests {
    static var allTests: Linux.TestList<SetextHeadingsTests> {
        return [
        ("testExample50", testExample50),
        ("testExample51", testExample51),
        ("testExample52", testExample52),
        ("testExample53", testExample53),
        ("testExample54", testExample54),
        ("testExample55", testExample55),
        ("testExample56", testExample56),
        ("testExample57", testExample57),
        ("testExample58", testExample58),
        ("testExample59", testExample59),
        ("testExample60", testExample60),
        ("testExample61", testExample61),
        ("testExample62", testExample62),
        ("testExample63", testExample63),
        ("testExample64", testExample64),
        ("testExample65", testExample65),
        ("testExample66", testExample66),
        ("testExample67", testExample67),
        ("testExample68", testExample68),
        ("testExample69", testExample69),
        ("testExample70", testExample70),
        ("testExample71", testExample71),
        ("testExample72", testExample72),
        ("testExample73", testExample73),
        ("testExample74", testExample74),
        ("testExample75", testExample75),
        ("testExample76", testExample76)
        ]
    }
}