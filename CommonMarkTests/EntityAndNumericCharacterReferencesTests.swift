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

final class EntityAndNumericCharacterReferencesTests: XCTestCase {

    // 
    // 
    // ## Entity and numeric character references
    // 
    // Valid HTML entity references and numeric character references
    // can be used in place of the corresponding Unicode character,
    // with the following exceptions:
    // 
    // - Entity and character references are not recognized in code
    //   blocks and code spans.
    // 
    // - Entity and character references cannot stand in place of
    //   special characters that define structural elements in
    //   CommonMark.  For example, although `&#42;` can be used
    //   in place of a literal `*` character, `&#42;` cannot replace
    //   `*` in emphasis delimiters, bullet list markers, or thematic
    //   breaks.
    // 
    // Conforming CommonMark parsers need not store information about
    // whether a particular character was represented in the source
    // using a Unicode character or an entity reference.
    // 
    // [Entity references](@) consist of `&` + any of the valid
    // HTML5 entity names + `;`. The
    // document <https://html.spec.whatwg.org/entities.json>
    // is used as an authoritative source for the valid entity
    // references and their corresponding code points.
    // 
    // 
    //     
    // spec.txt lines 648-656
    func testExample25() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &nbsp; &amp; &copy; &AElig; &Dcaron;
        &frac34; &HilbertSpace; &DifferentialD;
        &ClockwiseContourIntegral; &ngE;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>  &amp; © Æ Ď
        ¾ ℋ ⅆ
        ∲ ≧̸</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Decimal numeric character
    // references](@)
    // consist of `&#` + a string of 1--7 arabic digits + `;`. A
    // numeric character reference is parsed as the corresponding
    // Unicode character. Invalid Unicode code points will be replaced by
    // the REPLACEMENT CHARACTER (`U+FFFD`).  For security reasons,
    // the code point `U+0000` will also be replaced by `U+FFFD`.
    // 
    // 
    //     
    // spec.txt lines 667-671
    func testExample26() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &#35; &#1234; &#992; &#0;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p># Ӓ Ϡ �</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Hexadecimal numeric character
    // references](@) consist of `&#` +
    // either `X` or `x` + a string of 1-6 hexadecimal digits + `;`.
    // They too are parsed as the corresponding Unicode character (this
    // time specified with a hexadecimal numeral instead of decimal).
    // 
    // 
    //     
    // spec.txt lines 680-684
    func testExample27() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &#X22; &#XD06; &#xcab;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&quot; ആ ಫ</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here are some nonentities:
    // 
    // 
    //     
    // spec.txt lines 689-699
    func testExample28() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &nbsp &x; &#; &#x;
        &#87654321;
        &#abcdef0;
        &ThisIsNotDefined; &hi?;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;
        �
        &amp;#abcdef0;
        &amp;ThisIsNotDefined; &amp;hi?;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Although HTML5 does accept some entity references
    // without a trailing semicolon (such as `&copy`), these are not
    // recognized here, because it makes the grammar too ambiguous:
    // 
    // 
    //     
    // spec.txt lines 706-710
    func testExample29() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &copy
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&amp;copy</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Strings that are not on the list of HTML5 named entities are not
    // recognized as entity references either:
    // 
    // 
    //     
    // spec.txt lines 716-720
    func testExample30() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &MadeUpEntity;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>&amp;MadeUpEntity;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Entity and numeric character references are recognized in any
    // context besides code spans or code blocks, including
    // URLs, [link titles], and [fenced code block][] [info strings]:
    // 
    // 
    //     
    // spec.txt lines 727-731
    func testExample31() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="&ouml;&ouml;.html">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <!-- raw HTML omitted -->
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 734-738
    func testExample32() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo](/f&ouml;&ouml; "f&ouml;&ouml;")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 741-747
    func testExample33() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: /f&ouml;&ouml; "f&ouml;&ouml;"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 750-757
    func testExample34() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``` f&ouml;&ouml;
        foo
        ```
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <pre><code class="language-föö">foo
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Entity and numeric character references are treated as literal
    // text in code spans and code blocks:
    // 
    // 
    //     
    // spec.txt lines 763-767
    func testExample35() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `f&ouml;&ouml;`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><code>f&amp;ouml;&amp;ouml;</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 770-775
    func testExample36() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            f&ouml;f&ouml;
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <pre><code>f&amp;ouml;f&amp;ouml;
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Entity and numeric character references cannot be used
    // in place of symbols indicating structure in CommonMark
    // documents.
    // 
    // 
    //     
    // spec.txt lines 782-788
    func testExample37() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &#42;foo&#42;
        *foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>*foo*
        <em>foo</em></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 790-799
    func testExample38() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &#42; foo
        
        * foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>* foo</p><ul><li>foo</li></ul>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 801-807
    func testExample39() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo&#10;&#10;bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>foo
        
        bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 809-813
    func testExample40() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        &#9;foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>	foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 816-820
    func testExample41() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [a](url &quot;tit&quot;)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>[a](url &quot;tit&quot;)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension EntityAndNumericCharacterReferencesTests {
    static var allTests: Linux.TestList<EntityAndNumericCharacterReferencesTests> {
        return [
        ("testExample25", testExample25),
        ("testExample26", testExample26),
        ("testExample27", testExample27),
        ("testExample28", testExample28),
        ("testExample29", testExample29),
        ("testExample30", testExample30),
        ("testExample31", testExample31),
        ("testExample32", testExample32),
        ("testExample33", testExample33),
        ("testExample34", testExample34),
        ("testExample35", testExample35),
        ("testExample36", testExample36),
        ("testExample37", testExample37),
        ("testExample38", testExample38),
        ("testExample39", testExample39),
        ("testExample40", testExample40),
        ("testExample41", testExample41)
        ]
    }
}