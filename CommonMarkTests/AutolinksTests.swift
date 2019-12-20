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

final class AutolinksTests: XCTestCase {

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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9031-9035
    func testExample602() {
        let markdownTest =
        #####"""
        <http://foo.bar.baz>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
        let normalizedCM = #####"""
        <p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9038-9042
    func testExample603() {
        let markdownTest =
        #####"""
        <http://foo.bar.baz/test?q=hello&id=22&boolean>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
        let normalizedCM = #####"""
        <p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9045-9049
    func testExample604() {
        let markdownTest =
        #####"""
        <irc://foo.bar:2233/baz>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
        let normalizedCM = #####"""
        <p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Uppercase is also fine:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9054-9058
    func testExample605() {
        let markdownTest =
        #####"""
        <MAILTO:FOO@BAR.BAZ>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
        let normalizedCM = #####"""
        <p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that many strings that count as [absolute URIs] for
    // purposes of this spec are not valid URIs, because their
    // schemes are not registered or because of other problems
    // with their syntax:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9066-9070
    func testExample606() {
        let markdownTest =
        #####"""
        <a+b+c:d>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="a+b+c:d">a+b+c:d</a></p>
        let normalizedCM = #####"""
        <p><a href="a+b+c:d">a+b+c:d</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9073-9077
    func testExample607() {
        let markdownTest =
        #####"""
        <made-up-scheme://foo,bar>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
        let normalizedCM = #####"""
        <p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9080-9084
    func testExample608() {
        let markdownTest =
        #####"""
        <http://../>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="http://../">http://../</a></p>
        let normalizedCM = #####"""
        <p><a href="http://../">http://../</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9087-9091
    func testExample609() {
        let markdownTest =
        #####"""
        <localhost:5001/foo>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
        let normalizedCM = #####"""
        <p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Spaces are not allowed in autolinks:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9096-9100
    func testExample610() {
        let markdownTest =
        #####"""
        <http://foo.bar/baz bim>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;http://foo.bar/baz bim&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;http://foo.bar/baz bim&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash-escapes do not work inside autolinks:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9105-9109
    func testExample611() {
        let markdownTest =
        #####"""
        <http://example.com/\[\>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
        let normalizedCM = #####"""
        <p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9127-9131
    func testExample612() {
        let markdownTest =
        #####"""
        <foo@bar.example.com>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
        let normalizedCM = #####"""
        <p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9134-9138
    func testExample613() {
        let markdownTest =
        #####"""
        <foo+special@Bar.baz-bar0.com>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
        let normalizedCM = #####"""
        <p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash-escapes do not work inside email autolinks:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9143-9147
    func testExample614() {
        let markdownTest =
        #####"""
        <foo\+@bar.example.com>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;foo+@bar.example.com&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;foo+@bar.example.com&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // These are not autolinks:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9152-9156
    func testExample615() {
        let markdownTest =
        #####"""
        <>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9159-9163
    func testExample616() {
        let markdownTest =
        #####"""
        < http://foo.bar >
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt; http://foo.bar &gt;</p>
        let normalizedCM = #####"""
        <p>&lt; http://foo.bar &gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9166-9170
    func testExample617() {
        let markdownTest =
        #####"""
        <m:abc>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;m:abc&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;m:abc&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9173-9177
    func testExample618() {
        let markdownTest =
        #####"""
        <foo.bar.baz>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;foo.bar.baz&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;foo.bar.baz&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9180-9184
    func testExample619() {
        let markdownTest =
        #####"""
        http://example.com
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>http://example.com</p>
        let normalizedCM = #####"""
        <p>http://example.com</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9187-9191
    func testExample620() {
        let markdownTest =
        #####"""
        foo@bar.example.com
        """#####
    
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
        ("testExample602", testExample602),
        ("testExample603", testExample603),
        ("testExample604", testExample604),
        ("testExample605", testExample605),
        ("testExample606", testExample606),
        ("testExample607", testExample607),
        ("testExample608", testExample608),
        ("testExample609", testExample609),
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
        ("testExample620", testExample620)
        ]
    }
}