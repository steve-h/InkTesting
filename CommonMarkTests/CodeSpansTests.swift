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

final class CodeSpansTests: XCTestCase {

    // 
    // `hi` is parsed as code, leaving the backtick at the end as a literal
    // backtick.
    // 
    // 
    // 
    // ## Code spans
    // 
    // A [backtick string](@)
    // is a string of one or more backtick characters (`` ` ``) that is neither
    // preceded nor followed by a backtick.
    // 
    // A [code span](@) begins with a backtick string and ends with
    // a backtick string of equal length.  The contents of the code span are
    // the characters between these two backtick strings, normalized in the
    // following ways:
    // 
    // - First, [line endings] are converted to [spaces].
    // - If the resulting string both begins *and* ends with a [space]
    //   character, but does not consist entirely of [space]
    //   characters, a single [space] character is removed from the
    //   front and back.  This allows you to include code that begins
    //   or ends with backtick characters, which must be separated by
    //   whitespace from the opening or closing backtick strings.
    // 
    // This is a simple code span:
    // 
    // 
    //     
    // spec.txt lines 5874-5878
    func testExample328() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `foo`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo</code></p>
        let normalizedCM = #####"""
        <p><code>foo</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here two backticks are used, because the code contains a backtick.
    // This example also illustrates stripping of a single leading and
    // trailing space:
    // 
    // 
    //     
    // spec.txt lines 5885-5889
    func testExample329() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `` foo ` bar ``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo ` bar</code></p>
        let normalizedCM = #####"""
        <p><code>foo ` bar</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This example shows the motivation for stripping leading and trailing
    // spaces:
    // 
    // 
    //     
    // spec.txt lines 5895-5899
    func testExample330() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ` `` `
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>``</code></p>
        let normalizedCM = #####"""
        <p><code>``</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Note that only *one* space is stripped:
    // 
    // 
    //     
    // spec.txt lines 5903-5907
    func testExample331() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `  ``  `
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> `` </code></p>
        let normalizedCM = #####"""
        <p><code>``</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The stripping only happens if the space is on both
    // sides of the string:
    // 
    // 
    //     
    // spec.txt lines 5912-5916
    func testExample332() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ` a`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> a</code></p>
        let normalizedCM = #####"""
        <p><code>a</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Only [spaces], and not [unicode whitespace] in general, are
    // stripped in this way:
    // 
    // 
    //     
    // spec.txt lines 5921-5925
    func testExample333() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ` b `
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> b </code></p>
        let normalizedCM = #####"""
        <p><code> b </code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // No stripping occurs if the code span contains only spaces:
    // 
    // 
    //     
    // spec.txt lines 5929-5935
    func testExample334() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ` `
        `  `
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> </code>
      //<code>  </code></p>
        let normalizedCM = #####"""
        <p><code> </code> <code></code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Line endings] are treated like spaces:
    // 
    // 
    //     
    // spec.txt lines 5940-5948
    func testExample335() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``
        foo
        bar  
        baz
        ``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo bar   baz</code></p>
        let normalizedCM = #####"""
        <p><code>foo bar baz</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 5950-5956
    func testExample336() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``
        foo 
        ``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo </code></p>
        let normalizedCM = #####"""
        <p><code>foo</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Interior spaces are not collapsed:
    // 
    // 
    //     
    // spec.txt lines 5961-5966
    func testExample337() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `foo   bar 
        baz`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo   bar  baz</code></p>
        let normalizedCM = #####"""
        <p><code>foo bar baz</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // Note that browsers will typically collapse consecutive spaces
    // when rendering `<code>` elements, so it is recommended that
    // the following CSS be used:
    // 
    //     code{white-space: pre-wrap;}
    // 
    // 
    // Note that backslash escapes do not work in code spans. All backslashes
    // are treated literally:
    // 
    // 
    //     
    // spec.txt lines 5978-5982
    func testExample338() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `foo\`bar`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo\</code>bar`</p>
        let normalizedCM = #####"""
        <p><code>foo\</code>bar`</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Backslash escapes are never needed, because one can always choose a
    // string of *n* backtick characters as delimiters, where the code does
    // not contain any strings of exactly *n* backtick characters.
    // 
    // 
    //     
    // spec.txt lines 5989-5993
    func testExample339() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ``foo`bar``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo`bar</code></p>
        let normalizedCM = #####"""
        <p><code>foo`bar</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 5995-5999
    func testExample340() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ` foo `` bar `
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>foo `` bar</code></p>
        let normalizedCM = #####"""
        <p><code>foo `` bar</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Code span backticks have higher precedence than any other inline
    // constructs except HTML tags and autolinks.  Thus, for example, this is
    // not parsed as emphasized text, since the second `*` is part of a code
    // span:
    // 
    // 
    //     
    // spec.txt lines 6007-6011
    func testExample341() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo`*`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*foo<code>*</code></p>
        let normalizedCM = #####"""
        <p>*foo<code>*</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // And this is not parsed as a link:
    // 
    // 
    //     
    // spec.txt lines 6016-6020
    func testExample342() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [not a `link](/foo`)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[not a <code>link](/foo</code>)</p>
        let normalizedCM = #####"""
        <p>[not a <code>link](/foo</code>)</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Code spans, HTML tags, and autolinks have the same precedence.
    // Thus, this is code:
    // 
    // 
    //     
    // spec.txt lines 6026-6030
    func testExample343() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `<a href="`">`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>
        let normalizedCM = #####"""
        <p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // But this is an HTML tag:
    // 
    // 
    //     
    // spec.txt lines 6035-6039
    func testExample344() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <a href="`">`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="`">`</p>
        let normalizedCM = #####"""
        <p><a href="`">`</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // And this is code:
    // 
    // 
    //     
    // spec.txt lines 6044-6048
    func testExample345() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `<http://foo.bar.`baz>`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>
        let normalizedCM = #####"""
        <p><code>&lt;http://foo.bar.</code>baz&gt;`</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // But this is an autolink:
    // 
    // 
    //     
    // spec.txt lines 6053-6057
    func testExample346() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        <http://foo.bar.`baz>`
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>
        let normalizedCM = #####"""
        <p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // When a backtick string is not closed by a matching backtick string,
    // we just have literal backticks:
    // 
    // 
    //     
    // spec.txt lines 6063-6067
    func testExample347() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```foo``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>```foo``</p>
        let normalizedCM = #####"""
        <p>```foo``</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6070-6074
    func testExample348() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>`foo</p>
        let normalizedCM = #####"""
        <p>`foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The following case also illustrates the need for opening and
    // closing backtick strings to be equal in length:
    // 
    // 
    //     
    // spec.txt lines 6079-6083
    func testExample349() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        `foo``bar``
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>`foo<code>bar</code></p>
        let normalizedCM = #####"""
        <p>`foo<code>bar</code></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension CodeSpansTests {
    static var allTests: Linux.TestList<CodeSpansTests> {
        return [
        ("testExample328", testExample328),
        ("testExample329", testExample329),
        ("testExample330", testExample330),
        ("testExample331", testExample331),
        ("testExample332", testExample332),
        ("testExample333", testExample333),
        ("testExample334", testExample334),
        ("testExample335", testExample335),
        ("testExample336", testExample336),
        ("testExample337", testExample337),
        ("testExample338", testExample338),
        ("testExample339", testExample339),
        ("testExample340", testExample340),
        ("testExample341", testExample341),
        ("testExample342", testExample342),
        ("testExample343", testExample343),
        ("testExample344", testExample344),
        ("testExample345", testExample345),
        ("testExample346", testExample346),
        ("testExample347", testExample347),
        ("testExample348", testExample348),
        ("testExample349", testExample349)
        ]
    }
}