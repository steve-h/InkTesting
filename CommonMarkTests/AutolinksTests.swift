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
    // followed by zero or more characters other than ASCII
    // [whitespace] and control characters, `<`, and `>`.  If
    // the URI includes these characters, they must be percent-encoded
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8722-8726
    func testExample590() {
        var markdownTest =
        #####"""
        <http://foo.bar.baz>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
        let normalizedCM = #####"""
        <p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8729-8733
    func testExample591() {
        var markdownTest =
        #####"""
        <http://foo.bar.baz/test?q=hello&id=22&boolean>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
        let normalizedCM = #####"""
        <p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8736-8740
    func testExample592() {
        var markdownTest =
        #####"""
        <irc://foo.bar:2233/baz>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
        let normalizedCM = #####"""
        <p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Uppercase is also fine:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8745-8749
    func testExample593() {
        var markdownTest =
        #####"""
        <MAILTO:FOO@BAR.BAZ>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
        let normalizedCM = #####"""
        <p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8757-8761
    func testExample594() {
        var markdownTest =
        #####"""
        <a+b+c:d>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="a+b+c:d">a+b+c:d</a></p>
        let normalizedCM = #####"""
        <p><a href="a+b+c:d">a+b+c:d</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8764-8768
    func testExample595() {
        var markdownTest =
        #####"""
        <made-up-scheme://foo,bar>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
        let normalizedCM = #####"""
        <p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8771-8775
    func testExample596() {
        var markdownTest =
        #####"""
        <http://../>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://../">http://../</a></p>
        let normalizedCM = #####"""
        <p><a href="http://../">http://../</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8778-8782
    func testExample597() {
        var markdownTest =
        #####"""
        <localhost:5001/foo>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
        let normalizedCM = #####"""
        <p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Spaces are not allowed in autolinks:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8787-8791
    func testExample598() {
        var markdownTest =
        #####"""
        <http://foo.bar/baz bim>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt;http://foo.bar/baz bim&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;http://foo.bar/baz bim&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Backslash-escapes do not work inside autolinks:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8796-8800
    func testExample599() {
        var markdownTest =
        #####"""
        <http://example.com/\[\>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
        let normalizedCM = #####"""
        <p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8818-8822
    func testExample600() {
        var markdownTest =
        #####"""
        <foo@bar.example.com>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
        let normalizedCM = #####"""
        <p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8825-8829
    func testExample601() {
        var markdownTest =
        #####"""
        <foo+special@Bar.baz-bar0.com>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
        let normalizedCM = #####"""
        <p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Backslash-escapes do not work inside email autolinks:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8834-8838
    func testExample602() {
        var markdownTest =
        #####"""
        <foo\+@bar.example.com>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt;foo+@bar.example.com&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;foo+@bar.example.com&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // These are not autolinks:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8843-8847
    func testExample603() {
        var markdownTest =
        #####"""
        <>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt;&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8850-8854
    func testExample604() {
        var markdownTest =
        #####"""
        < http://foo.bar >
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt; http://foo.bar &gt;</p>
        let normalizedCM = #####"""
        <p>&lt; http://foo.bar &gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8857-8861
    func testExample605() {
        var markdownTest =
        #####"""
        <m:abc>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt;m:abc&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;m:abc&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8864-8868
    func testExample606() {
        var markdownTest =
        #####"""
        <foo.bar.baz>
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&lt;foo.bar.baz&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;foo.bar.baz&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8871-8875
    func testExample607() {
        var markdownTest =
        #####"""
        http://example.com
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>http://example.com</p>
        let normalizedCM = #####"""
        <p>http://example.com</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8878-8882
    func testExample608() {
        var markdownTest =
        #####"""
        foo@bar.example.com
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo@bar.example.com</p>
        let normalizedCM = #####"""
        <p>foo@bar.example.com</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
}

extension AutolinksTests {
    static var allTests: Linux.TestList<AutolinksTests> {
        return [
        ("testExample590", testExample590),
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
        ("testExample608", testExample608)
        ]
    }
}