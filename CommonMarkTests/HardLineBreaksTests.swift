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

final class HardLineBreaksTests: XCTestCase {

    // 
    // 
    // ## Hard line breaks
    // 
    // A line break (not in a code span or HTML tag) that is preceded
    // by two or more spaces and does not occur at the end of a block
    // is parsed as a [hard line break](@) (rendered
    // in HTML as a `<br />` tag):
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9166-9172
    func testExample630() {
        var markdownTest =
        #####"""
        foo  
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo<br>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // For a more visible alternative, a backslash before the
    // [line ending] may be used instead of two spaces:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9178-9184
    func testExample631() {
        var markdownTest =
        #####"""
        foo\
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo<br>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // More than two spaces can be used:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9189-9195
    func testExample632() {
        var markdownTest =
        #####"""
        foo       
        baz
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //baz</p>
        let normalizedCM = #####"""
        <p>foo<br>baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Leading spaces at the beginning of the next line are ignored:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9200-9206
    func testExample633() {
        var markdownTest =
        #####"""
        foo  
             bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo<br>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9209-9215
    func testExample634() {
        var markdownTest =
        #####"""
        foo\
             bar
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<br />
      //bar</p>
        let normalizedCM = #####"""
        <p>foo<br>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Line breaks can occur inside emphasis, links, and other constructs
    // that allow inline content:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9221-9227
    func testExample635() {
        var markdownTest =
        #####"""
        *foo  
        bar*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo<br />
      //bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo<br>bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9230-9236
    func testExample636() {
        var markdownTest =
        #####"""
        *foo\
        bar*
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo<br />
      //bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo<br>bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Line breaks do not occur inside code spans
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9241-9246
    func testExample637() {
        var markdownTest =
        #####"""
        `code 
        span`
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>code  span</code></p>
        let normalizedCM = #####"""
        <p><code>code span</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9249-9254
    func testExample638() {
        var markdownTest =
        #####"""
        `code\
        span`
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><code>code\ span</code></p>
        let normalizedCM = #####"""
        <p><code>code\ span</code></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // or HTML tags:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9259-9265
    func testExample639() {
        var markdownTest =
        #####"""
        <a href="foo  
        bar">
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo  
      //bar"></p>
        let normalizedCM = #####"""
        <p><a href="foo  
        bar"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9268-9274
    func testExample640() {
        var markdownTest =
        #####"""
        <a href="foo\
        bar">
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="foo\
      //bar"></p>
        let normalizedCM = #####"""
        <p><a href="foo\
        bar"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // Hard line breaks are for separating inline content within a block.
    // Neither syntax for hard line breaks works at the end of a paragraph or
    // other block element:
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9281-9285
    func testExample641() {
        var markdownTest =
        #####"""
        foo\
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo\</p>
        let normalizedCM = #####"""
        <p>foo\</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9288-9292
    func testExample642() {
        var markdownTest =
        #####"""
        foo  
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo</p>
        let normalizedCM = #####"""
        <p>foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9295-9299
    func testExample643() {
        var markdownTest =
        #####"""
        ### foo\
        """#####
        markdownTest = markdownTest + "\n"
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h3>foo\</h3>
        let normalizedCM = #####"""
        <h3>foo\</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }
    // 
    // 
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 9302-9306
    func testExample644() {
        var markdownTest =
        #####"""
        ### foo  
        """#####
        markdownTest = markdownTest + "\n"
    
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
        ("testExample630", testExample630),
        ("testExample631", testExample631),
        ("testExample632", testExample632),
        ("testExample633", testExample633),
        ("testExample634", testExample634),
        ("testExample635", testExample635),
        ("testExample636", testExample636),
        ("testExample637", testExample637),
        ("testExample638", testExample638),
        ("testExample639", testExample639),
        ("testExample640", testExample640),
        ("testExample641", testExample641),
        ("testExample642", testExample642),
        ("testExample643", testExample643),
        ("testExample644", testExample644)
        ]
    }
}