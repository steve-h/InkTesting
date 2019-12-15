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

final class RawHtmlTests: XCTestCase {

    // 
    // 
    // ## Raw HTML
    // 
    // Text between `<` and `>` that looks like an HTML tag is parsed as a
    // raw HTML tag and will be rendered in HTML without escaping.
    // Tag and attribute names are not limited to current HTML tags,
    // so custom tags (and even, say, DocBook tags) may be used.
    // 
    // Here is the grammar for tags:
    // 
    // A [tag name](@) consists of an ASCII letter
    // followed by zero or more ASCII letters, digits, or
    // hyphens (`-`).
    // 
    // An [attribute](@) consists of [whitespace],
    // an [attribute name], and an optional
    // [attribute value specification].
    // 
    // An [attribute name](@)
    // consists of an ASCII letter, `_`, or `:`, followed by zero or more ASCII
    // letters, digits, `_`, `.`, `:`, or `-`.  (Note:  This is the XML
    // specification restricted to ASCII.  HTML5 is laxer.)
    // 
    // An [attribute value specification](@)
    // consists of optional [whitespace],
    // a `=` character, optional [whitespace], and an [attribute
    // value].
    // 
    // An [attribute value](@)
    // consists of an [unquoted attribute value],
    // a [single-quoted attribute value], or a [double-quoted attribute value].
    // 
    // An [unquoted attribute value](@)
    // is a nonempty string of characters not
    // including [whitespace], `"`, `'`, `=`, `<`, `>`, or `` ` ``.
    // 
    // A [single-quoted attribute value](@)
    // consists of `'`, zero or more
    // characters not including `'`, and a final `'`.
    // 
    // A [double-quoted attribute value](@)
    // consists of `"`, zero or more
    // characters not including `"`, and a final `"`.
    // 
    // An [open tag](@) consists of a `<` character, a [tag name],
    // zero or more [attributes], optional [whitespace], an optional `/`
    // character, and a `>` character.
    // 
    // A [closing tag](@) consists of the string `</`, a
    // [tag name], optional [whitespace], and the character `>`.
    // 
    // An [HTML comment](@) consists of `<!--` + *text* + `-->`,
    // where *text* does not start with `>` or `->`, does not end with `-`,
    // and does not contain `--`.  (See the
    // [HTML5 spec](http://www.w3.org/TR/html5/syntax.html#comments).)
    // 
    // A [processing instruction](@)
    // consists of the string `<?`, a string
    // of characters not including the string `?>`, and the string
    // `?>`.
    // 
    // A [declaration](@) consists of the string `<!`, an ASCII letter, zero or more
    // characters not including the character `>`, and the character `>`.
    // 
    // A [CDATA section](@) consists of
    // the string `<![CDATA[`, a string of characters not including the string
    // `]]>`, and the string `]]>`.
    // 
    // An [HTML tag](@) consists of an [open tag], a [closing tag],
    // an [HTML comment], a [processing instruction], a [declaration],
    // or a [CDATA section].
    // 
    // Here are some simple open tags:
    // 
    // 
    //     
    // spec.txt lines 8969-8973
    func testExample610() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a><bab><c2c>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a><bab><c2c></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Empty elements:
    // 
    // 
    //     
    // spec.txt lines 8978-8982
    func testExample611() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a/><b2/>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a/><b2/></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Whitespace] is allowed:
    // 
    // 
    //     
    // spec.txt lines 8987-8993
    func testExample612() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a  /><b2
        data="foo" >
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a  /><b2
        data="foo" ></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // With attributes:
    // 
    // 
    //     
    // spec.txt lines 8998-9004
    func testExample613() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a foo="bar" bam = 'baz <em>"</em>'
        _boolean zoop:33=zoop:33 />
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a foo="bar" bam = 'baz <em>"</em>'
        _boolean zoop:33=zoop:33 /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Custom tag names can be used:
    // 
    // 
    //     
    // spec.txt lines 9009-9013
    func testExample614() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo <responsive-image src="foo.jpg" />
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>Foo <responsive-image src="foo.jpg" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Illegal tag names, not parsed as HTML:
    // 
    // 
    //     
    // spec.txt lines 9018-9022
    func testExample615() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <33> <__>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;33&gt; &lt;__&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Illegal attribute names:
    // 
    // 
    //     
    // spec.txt lines 9027-9031
    func testExample616() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a h*#ref="hi">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Illegal attribute values:
    // 
    // 
    //     
    // spec.txt lines 9036-9040
    func testExample617() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="hi'> <a href=hi'>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Illegal [whitespace]:
    // 
    // 
    //     
    // spec.txt lines 9045-9055
    func testExample618() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        < a><
        foo><bar/ >
        <foo bar=baz
        bim!bop />
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt; a&gt;&lt; foo&gt;&lt;bar/ &gt; <foo bar=baz
        bim!bop /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Missing [whitespace]:
    // 
    // 
    //     
    // spec.txt lines 9060-9064
    func testExample619() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href='bar'title=title>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;a href='bar'title=title&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Closing tags:
    // 
    // 
    //     
    // spec.txt lines 9069-9073
    func testExample620() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        </a></foo >
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p></a></foo ></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Illegal attributes in closing tag:
    // 
    // 
    //     
    // spec.txt lines 9078-9082
    func testExample621() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        </a href="foo">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;/a href=&quot;foo&quot;&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Comments:
    // 
    // 
    //     
    // spec.txt lines 9087-9093
    func testExample622() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <!-- this is a
        comment - with hyphen -->
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <!-- this is a
        comment - with hyphen --></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9096-9100
    func testExample623() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <!-- not a comment -- two hyphens -->
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Not comments:
    // 
    // 
    //     
    // spec.txt lines 9105-9112
    func testExample624() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <!--> foo -->
        
        foo <!-- foo--->
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo &lt;!--&gt; foo --&gt;</p><p>foo &lt;!-- foo---&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Processing instructions:
    // 
    // 
    //     
    // spec.txt lines 9117-9121
    func testExample625() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <?php echo $a; ?>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <?php echo $a; ?></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Declarations:
    // 
    // 
    //     
    // spec.txt lines 9126-9130
    func testExample626() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <!ELEMENT br EMPTY>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <!ELEMENT br EMPTY></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // CDATA sections:
    // 
    // 
    //     
    // spec.txt lines 9135-9139
    func testExample627() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <![CDATA[>&<]]>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <![CDATA[>&<]]></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Entity and numeric character references are preserved in HTML
    // attributes:
    // 
    // 
    //     
    // spec.txt lines 9145-9149
    func testExample628() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <a href="&ouml;">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <a href="&ouml;"></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Backslash escapes do not work in HTML attributes:
    // 
    // 
    //     
    // spec.txt lines 9154-9158
    func testExample629() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo <a href="\*">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo <a href="\*"></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 9161-9165
    func testExample630() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="\"">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&lt;a href=&quot;&quot;&quot;&gt;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension RawHtmlTests {
    static var allTests: Linux.TestList<RawHtmlTests> {
        return [
        ("testExample610", testExample610),
        ("testExample611", testExample611),
        ("testExample612", testExample612),
        ("testExample613", testExample613),
        ("testExample614", testExample614),
        ("testExample615", testExample615),
        ("testExample616", testExample616),
        ("testExample617", testExample617),
        ("testExample618", testExample618),
        ("testExample619", testExample619),
        ("testExample620", testExample620),
        ("testExample621", testExample621),
        ("testExample622", testExample622),
        ("testExample623", testExample623),
        ("testExample624", testExample624),
        ("testExample625", testExample625),
        ("testExample626", testExample626),
        ("testExample627", testExample627),
        ("testExample628", testExample628),
        ("testExample629", testExample629),
        ("testExample630", testExample630)
        ]
    }
}