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

final class AutolinksTests: XCTestCase {

    // 
    // 
    // ## Autolinks
    // 
    // [Autolink](@)s are absolute URIs and email addresses inside
    // `<` and `>`. They are parsed as links, with the URL or email address
    // as the link label.
    // 
    // A [URI autolink](@) consists of `<`, followed by an
    // [absolute URI] followed by `>`.  It is parsed as
    // a link to the URI, with the URI as the link's label.
    // 
    // An [absolute URI](@),
    // for these purposes, consists of a [scheme] followed by a colon (`:`)
    // followed by zero or more characters other [ASCII control
    // characters][ASCII control character] or [whitespace][] , `<`, and `>`.
    // If the URI includes these characters, they must be percent-encoded
    // (e.g. `%20` for a space).
    // 
    // For purposes of this spec, a [scheme](@) is any sequence
    // of 2--32 characters beginning with an ASCII letter and followed
    // by any combination of ASCII letters, digits, or the symbols plus
    // ("+"), period ("."), or hyphen ("-").
    // 
    // Here are some valid autolinks:
    // 
    // 
    //     
    // spec.txt lines 8733-8737
    func testExample591() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://foo.bar.baz>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8740-8744
    func testExample592() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://foo.bar.baz/test?q=hello&id=22&boolean>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8747-8751
    func testExample593() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <irc://foo.bar:2233/baz>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Uppercase is also fine:
    // 
    // 
    //     
    // spec.txt lines 8756-8760
    func testExample594() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <MAILTO:FOO@BAR.BAZ>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Note that many strings that count as [absolute URIs] for
    // purposes of this spec are not valid URIs, because their
    // schemes are not registered or because of other problems
    // with their syntax:
    // 
    // 
    //     
    // spec.txt lines 8768-8772
    func testExample595() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a+b+c:d>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="a+b+c:d">a+b+c:d</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8775-8779
    func testExample596() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <made-up-scheme://foo,bar>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8782-8786
    func testExample597() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://../>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="http://../">http://../</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8789-8793
    func testExample598() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <localhost:5001/foo>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Spaces are not allowed in autolinks:
    // 
    // 
    //     
    // spec.txt lines 8798-8802
    func testExample599() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://foo.bar/baz bim>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt;http://foo.bar/baz bim&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Backslash-escapes do not work inside autolinks:
    // 
    // 
    //     
    // spec.txt lines 8807-8811
    func testExample600() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://example.com/\[\>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // An [email autolink](@)
    // consists of `<`, followed by an [email address],
    // followed by `>`.  The link's label is the email address,
    // and the URL is `mailto:` followed by the email address.
    // 
    // An [email address](@),
    // for these purposes, is anything that matches
    // the [non-normative regex from the HTML5
    // spec](https://html.spec.whatwg.org/multipage/forms.html#e-mail-state-(type=email)):
    // 
    //     /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
    //     (?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
    // 
    // Examples of email autolinks:
    // 
    // 
    //     
    // spec.txt lines 8829-8833
    func testExample601() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <foo@bar.example.com>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8836-8840
    func testExample602() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <foo+special@Bar.baz-bar0.com>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // Backslash-escapes do not work inside email autolinks:
    // 
    // 
    //     
    // spec.txt lines 8845-8849
    func testExample603() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <foo\+@bar.example.com>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt;foo+@bar.example.com&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // These are not autolinks:
    // 
    // 
    //     
    // spec.txt lines 8854-8858
    func testExample604() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt;&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8861-8865
    func testExample605() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        < http://foo.bar >
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt; http://foo.bar &gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8868-8872
    func testExample606() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <m:abc>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt;m:abc&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8875-8879
    func testExample607() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <foo.bar.baz>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>&lt;foo.bar.baz&gt;</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8882-8886
    func testExample608() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        http://example.com
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>http://example.com</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8889-8893
    func testExample609() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo@bar.example.com
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
<p>foo@bar.example.com</p>
"""#####
        XCTAssertEqual(normalize(html: html),normalizedCM)

    }
}

extension AutolinksTests {
    static var allTests: Linux.TestList<AutolinksTests> {
        return [
        ("testExample591", testExample591),
        ("testExample592", testExample592),
        ("testExample593", testExample593),
        ("testExample594", testExample594),
        ("testExample595", testExample595),
        ("testExample596", testExample596),
        ("testExample597", testExample597),
        ("testExample598", testExample598),
        ("testExample599", testExample599),
        ("testExample600", testExample600),
        ("testExample601", testExample601),
        ("testExample602", testExample602),
        ("testExample603", testExample603),
        ("testExample604", testExample604),
        ("testExample605", testExample605),
        ("testExample606", testExample606),
        ("testExample607", testExample607),
        ("testExample608", testExample608),
        ("testExample609", testExample609)
        ]
    }
}