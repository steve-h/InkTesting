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
    // 
    // ## Code spans
    // 
    // A [backtick string](@)
    // is a string of one or more backtick characters (`` ` ``) that is neither
    // preceded nor followed by a backtick.
    // 
    // A [code span](@) begins with a backtick string and ends with
    // a backtick string of equal length.  The contents of the code span are
    // the characters between the two backtick strings, normalized in the
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5870-5874
    func testExample328() {
        var markdownTest =
        #####"""
        `foo`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5881-5885
    func testExample329() {
        var markdownTest =
        #####"""
        `` foo ` bar ``
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5891-5895
    func testExample330() {
        var markdownTest =
        #####"""
        ` `` `
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5899-5903
    func testExample331() {
        var markdownTest =
        #####"""
        `  ``  `
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5908-5912
    func testExample332() {
        var markdownTest =
        #####"""
        ` a`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5917-5921
    func testExample333() {
        var markdownTest =
        #####"""
        ` b `
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> b </code></p>
        let normalizedCM = #####"""
        <p><code>b</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // No stripping occurs if the code span contains only spaces:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5925-5931
    func testExample334() {
        var markdownTest =
        #####"""
        ` `
        `  `
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code> </code>
      //<code>  </code></p>
        let normalizedCM = #####"""
        <p><code></code> <code></code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // [Line endings] are treated like spaces:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5936-5944
    func testExample335() {
        var markdownTest =
        #####"""
        ``
        foo
        bar  
        baz
        ``
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5946-5952
    func testExample336() {
        var markdownTest =
        #####"""
        ``
        foo 
        ``
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5957-5962
    func testExample337() {
        var markdownTest =
        #####"""
        `foo   bar 
        baz`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5974-5978
    func testExample338() {
        var markdownTest =
        #####"""
        `foo\`bar`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5985-5989
    func testExample339() {
        var markdownTest =
        #####"""
        ``foo`bar``
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 5991-5995
    func testExample340() {
        var markdownTest =
        #####"""
        ` foo `` bar `
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6003-6007
    func testExample341() {
        var markdownTest =
        #####"""
        *foo`*`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6012-6016
    func testExample342() {
        var markdownTest =
        #####"""
        [not a `link](/foo`)
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6022-6026
    func testExample343() {
        var markdownTest =
        #####"""
        `<a href="`">`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6031-6035
    func testExample344() {
        var markdownTest =
        #####"""
        <a href="`">`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6040-6044
    func testExample345() {
        var markdownTest =
        #####"""
        `<http://foo.bar.`baz>`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6049-6053
    func testExample346() {
        var markdownTest =
        #####"""
        <http://foo.bar.`baz>`
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6059-6063
    func testExample347() {
        var markdownTest =
        #####"""
        ```foo``
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6066-6070
    func testExample348() {
        var markdownTest =
        #####"""
        `foo
        """#####
        markdownTest = markdownTest + "\n"
    
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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6075-6079
    func testExample349() {
        var markdownTest =
        #####"""
        `foo``bar``
        """#####
        markdownTest = markdownTest + "\n"
    
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