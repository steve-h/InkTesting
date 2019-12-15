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

final class AtxHeadingsTests: XCTestCase {

    // 
    // 
    // ## ATX headings
    // 
    // An [ATX heading](@)
    // consists of a string of characters, parsed as inline content, between an
    // opening sequence of 1--6 unescaped `#` characters and an optional
    // closing sequence of any number of unescaped `#` characters.
    // The opening sequence of `#` characters must be followed by a
    // [space] or by the end of line. The optional closing sequence of `#`s must be
    // preceded by a [space] and may be followed by spaces only.  The opening
    // `#` character may be indented 0-3 spaces.  The raw contents of the
    // heading are stripped of leading and trailing spaces before being parsed
    // as inline content.  The heading level is equal to the number of `#`
    // characters in the opening sequence.
    // 
    // Simple headings:
    // 
    // 
    //     
    // spec.txt lines 1111-1125
    func testExample62() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # foo
        ## foo
        ### foo
        #### foo
        ##### foo
        ###### foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>foo</h1>
      //<h2>foo</h2>
      //<h3>foo</h3>
      //<h4>foo</h4>
      //<h5>foo</h5>
      //<h6>foo</h6>
        let normalizedCM = #####"""
        <h1>foo</h1><h2>foo</h2><h3>foo</h3><h4>foo</h4><h5>foo</h5><h6>foo</h6>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // More than six `#` characters is not a heading:
    // 
    // 
    //     
    // spec.txt lines 1130-1134
    func testExample63() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ####### foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>####### foo</p>
        let normalizedCM = #####"""
        <p>####### foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // At least one space is required between the `#` characters and the
    // heading's contents, unless the heading is empty.  Note that many
    // implementations currently do not require the space.  However, the
    // space was required by the
    // [original ATX implementation](http://www.aaronsw.com/2002/atx/atx.py),
    // and it helps prevent things like the following from being parsed as
    // headings:
    // 
    // 
    //     
    // spec.txt lines 1145-1152
    func testExample64() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        #5 bolt
        
        #hashtag
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>#5 bolt</p>
      //<p>#hashtag</p>
        let normalizedCM = #####"""
        <p>#5 bolt</p><p>#hashtag</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a heading, because the first `#` is escaped:
    // 
    // 
    //     
    // spec.txt lines 1157-1161
    func testExample65() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        \## foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>## foo</p>
        let normalizedCM = #####"""
        <p>## foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Contents are parsed as inlines:
    // 
    // 
    //     
    // spec.txt lines 1166-1170
    func testExample66() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # foo *bar* \*baz\*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>foo <em>bar</em> *baz*</h1>
        let normalizedCM = #####"""
        <h1>foo <em>bar</em> *baz*</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Leading and trailing [whitespace] is ignored in parsing inline content:
    // 
    // 
    //     
    // spec.txt lines 1175-1179
    func testExample67() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        #                  foo                     
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>foo</h1>
        let normalizedCM = #####"""
        <h1>foo</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // One to three spaces indentation are allowed:
    // 
    // 
    //     
    // spec.txt lines 1184-1192
    func testExample68() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
         ### foo
          ## foo
           # foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h3>foo</h3>
      //<h2>foo</h2>
      //<h1>foo</h1>
        let normalizedCM = #####"""
        <h3>foo</h3><h2>foo</h2><h1>foo</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Four spaces are too much:
    // 
    // 
    //     
    // spec.txt lines 1197-1202
    func testExample69() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            # foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code># foo
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code># foo
        </code></pre>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1205-1211
    func testExample70() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo
            # bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo
      //# bar</p>
        let normalizedCM = #####"""
        <p>foo # bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A closing sequence of `#` characters is optional:
    // 
    // 
    //     
    // spec.txt lines 1216-1222
    func testExample71() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ## foo ##
          ###   bar    ###
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h2>foo</h2>
      //<h3>bar</h3>
        let normalizedCM = #####"""
        <h2>foo</h2><h3>bar</h3>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // It need not be the same length as the opening sequence:
    // 
    // 
    //     
    // spec.txt lines 1227-1233
    func testExample72() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # foo ##################################
        ##### foo ##
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>foo</h1>
      //<h5>foo</h5>
        let normalizedCM = #####"""
        <h1>foo</h1><h5>foo</h5>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Spaces are allowed after the closing sequence:
    // 
    // 
    //     
    // spec.txt lines 1238-1242
    func testExample73() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ### foo ###     
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h3>foo</h3>
        let normalizedCM = #####"""
        <h3>foo</h3>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A sequence of `#` characters with anything but [spaces] following it
    // is not a closing sequence, but counts as part of the contents of the
    // heading:
    // 
    // 
    //     
    // spec.txt lines 1249-1253
    func testExample74() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ### foo ### b
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h3>foo ### b</h3>
        let normalizedCM = #####"""
        <h3>foo ### b</h3>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The closing sequence must be preceded by a space:
    // 
    // 
    //     
    // spec.txt lines 1258-1262
    func testExample75() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # foo#
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>foo#</h1>
        let normalizedCM = #####"""
        <h1>foo#</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Backslash-escaped `#` characters do not count as part
    // of the closing sequence:
    // 
    // 
    //     
    // spec.txt lines 1268-1276
    func testExample76() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ### foo \###
        ## foo #\##
        # foo \#
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h3>foo ###</h3>
      //<h2>foo ###</h2>
      //<h1>foo #</h1>
        let normalizedCM = #####"""
        <h3>foo ###</h3><h2>foo ###</h2><h1>foo #</h1>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // ATX headings need not be separated from surrounding content by blank
    // lines, and they can interrupt paragraphs:
    // 
    // 
    //     
    // spec.txt lines 1282-1290
    func testExample77() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ****
        ## foo
        ****
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<hr />
      //<h2>foo</h2>
      //<hr />
        let normalizedCM = #####"""
        <hr><h2>foo</h2><hr>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 1293-1301
    func testExample78() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo bar
        # baz
        Bar foo
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo bar</p>
      //<h1>baz</h1>
      //<p>Bar foo</p>
        let normalizedCM = #####"""
        <p>Foo bar</p><h1>baz</h1><p>Bar foo</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // ATX headings can be empty:
    // 
    // 
    //     
    // spec.txt lines 1306-1314
    func testExample79() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ## 
        #
        ### ###
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h2></h2>
      //<h1></h1>
      //<h3></h3>
        let normalizedCM = #####"""
        <h2></h2><h1></h1><h3></h3>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension AtxHeadingsTests {
    static var allTests: Linux.TestList<AtxHeadingsTests> {
        return [
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
        ("testExample76", testExample76),
        ("testExample77", testExample77),
        ("testExample78", testExample78),
        ("testExample79", testExample79)
        ]
    }
}