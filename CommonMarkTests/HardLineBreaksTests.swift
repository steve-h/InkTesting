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

final class HardLineBreaksTests: XCTestCase {

    // </div>
    // 
    // ## Hard line breaks
    // 
    // A line break (not in a code span or HTML tag) that is preceded
    // by two or more spaces and does not occur at the end of a block
    // is parsed as a [hard line break](@) (rendered
    // in HTML as a `<br />` tag):
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9683-9689
    func testExample654() {
        let markdownTest =
        #####"""
        foo
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // For a more visible alternative, a backslash before the
    // [line ending] may be used instead of two spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9695-9701
    func testExample655() {
        let markdownTest =
        #####"""
        foo\
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo<br>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // More than two spaces can be used:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9706-9712
    func testExample656() {
        let markdownTest =
        #####"""
        foo
        baz\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Leading spaces at the beginning of the next line are ignored:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9717-9723
    func testExample657() {
        let markdownTest =
        #####"""
        foo
             bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9726-9732
    func testExample658() {
        let markdownTest =
        #####"""
        foo\
             bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo<br>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Line breaks can occur inside emphasis, links, and other constructs
    // that allow inline content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9738-9744
    func testExample659() {
        let markdownTest =
        #####"""
        *foo
        bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><em>foo<br />
      //bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9747-9753
    func testExample660() {
        let markdownTest =
        #####"""
        *foo\
        bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><em>foo<br />
      //bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo<br>bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Line breaks do not occur inside code spans
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9758-9763
    func testExample661() {
        let markdownTest =
        #####"""
        `code
        span`\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><code>code   span</code></p>
        let normalizedCM = #####"""
        <p><code>code span</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9766-9771
    func testExample662() {
        let markdownTest =
        #####"""
        `code\
        span`\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><code>code\ span</code></p>
        let normalizedCM = #####"""
        <p><code>code\ span</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // or HTML tags:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9776-9782
    func testExample663() {
        let markdownTest =
        #####"""
        <a href="foo
        bar">\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="foo
      //bar"></p>
        let normalizedCM = #####"""
        <p><a href="foo
        bar"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9785-9791
    func testExample664() {
        let markdownTest =
        #####"""
        <a href="foo\
        bar">\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a href="foo\
      //bar"></p>
        let normalizedCM = #####"""
        <p><a href="foo\
        bar"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Hard line breaks are for separating inline content within a block.
    // Neither syntax for hard line breaks works at the end of a paragraph or
    // other block element:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9798-9802
    func testExample665() {
        let markdownTest =
        #####"""
        foo\
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo\</p>
        let normalizedCM = #####"""
        <p>foo\</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9805-9809
    func testExample666() {
        let markdownTest =
        #####"""
        foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo</p>
        let normalizedCM = #####"""
        <p>foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9812-9816
    func testExample667() {
        let markdownTest =
        #####"""
        ### foo\
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h3>foo\</h3>
        let normalizedCM = #####"""
        <h3>foo\</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9819-9823
    func testExample668() {
        let markdownTest =
        #####"""
        ### foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h3>foo</h3>
        let normalizedCM = #####"""
        <h3>foo</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension HardLineBreaksTests {
    static var allTests: Linux.TestList<HardLineBreaksTests> {
        return [
        ("testExample654", testExample654),
        ("testExample655", testExample655),
        ("testExample656", testExample656),
        ("testExample657", testExample657),
        ("testExample658", testExample658),
        ("testExample659", testExample659),
        ("testExample660", testExample660),
        ("testExample661", testExample661),
        ("testExample662", testExample662),
        ("testExample663", testExample663),
        ("testExample664", testExample664),
        ("testExample665", testExample665),
        ("testExample666", testExample666),
        ("testExample667", testExample667),
        ("testExample668", testExample668)
        ]
    }
}