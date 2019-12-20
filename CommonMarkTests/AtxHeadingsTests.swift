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

final class AtxHeadingsTests: XCTestCase {

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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 784-798
    func testExample32() {
        let markdownTest =
        #####"""
        # foo
        ## foo
        ### foo
        #### foo
        ##### foo
        ###### foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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

    // More than six `#` characters is not a heading:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 803-807
    func testExample33() {
        let markdownTest =
        #####"""
        ####### foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>####### foo</p>
        let normalizedCM = #####"""
        <p>####### foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // At least one space is required between the `#` characters and the
    // heading's contents, unless the heading is empty.  Note that many
    // implementations currently do not require the space.  However, the
    // space was required by the
    // [original ATX implementation](http://www.aaronsw.com/2002/atx/atx.py),
    // and it helps prevent things like the following from being parsed as
    // headings:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 818-825
    func testExample34() {
        let markdownTest =
        #####"""
        #5 bolt
        
        #hashtag\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>#5 bolt</p>
      //<p>#hashtag</p>
        let normalizedCM = #####"""
        <p>#5 bolt</p><p>#hashtag</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not a heading, because the first `#` is escaped:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 830-834
    func testExample35() {
        let markdownTest =
        #####"""
        \## foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>## foo</p>
        let normalizedCM = #####"""
        <p>## foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Contents are parsed as inlines:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 839-843
    func testExample36() {
        let markdownTest =
        #####"""
        # foo *bar* \*baz\*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h1>foo <em>bar</em> *baz*</h1>
        let normalizedCM = #####"""
        <h1>foo <em>bar</em> *baz*</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Leading and trailing [whitespace] is ignored in parsing inline content:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 848-852
    func testExample37() {
        let markdownTest =
        #####"""
        #                  foo
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h1>foo</h1>
        let normalizedCM = #####"""
        <h1>foo</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // One to three spaces indentation are allowed:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 857-865
    func testExample38() {
        let markdownTest =
        #####"""
         ### foo
          ## foo
           # foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h3>foo</h3>
      //<h2>foo</h2>
      //<h1>foo</h1>
        let normalizedCM = #####"""
        <h3>foo</h3><h2>foo</h2><h1>foo</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Four spaces are too much:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 870-875
    func testExample39() {
        let markdownTest =
        #####"""
            # foo
        """#####
    
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 878-884
    func testExample40() {
        let markdownTest =
        #####"""
        foo
            # bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo
      //# bar</p>
        let normalizedCM = #####"""
        <p>foo # bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A closing sequence of `#` characters is optional:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 889-895
    func testExample41() {
        let markdownTest =
        #####"""
        ## foo ##
          ###   bar    ###\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h2>foo</h2>
      //<h3>bar</h3>
        let normalizedCM = #####"""
        <h2>foo</h2><h3>bar</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // It need not be the same length as the opening sequence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 900-906
    func testExample42() {
        let markdownTest =
        #####"""
        # foo ##################################
        ##### foo ##\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h1>foo</h1>
      //<h5>foo</h5>
        let normalizedCM = #####"""
        <h1>foo</h1><h5>foo</h5>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Spaces are allowed after the closing sequence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 911-915
    func testExample43() {
        let markdownTest =
        #####"""
        ### foo ###
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h3>foo</h3>
        let normalizedCM = #####"""
        <h3>foo</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A sequence of `#` characters with anything but [spaces] following it
    // is not a closing sequence, but counts as part of the contents of the
    // heading:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 922-926
    func testExample44() {
        let markdownTest =
        #####"""
        ### foo ### b
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h3>foo ### b</h3>
        let normalizedCM = #####"""
        <h3>foo ### b</h3>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The closing sequence must be preceded by a space:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 931-935
    func testExample45() {
        let markdownTest =
        #####"""
        # foo#
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<h1>foo#</h1>
        let normalizedCM = #####"""
        <h1>foo#</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash-escaped `#` characters do not count as part
    // of the closing sequence:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 941-949
    func testExample46() {
        let markdownTest =
        #####"""
        ### foo \###
        ## foo #\##
        # foo \#\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<h3>foo ###</h3>
      //<h2>foo ###</h2>
      //<h1>foo #</h1>
        let normalizedCM = #####"""
        <h3>foo ###</h3><h2>foo ###</h2><h1>foo #</h1>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // ATX headings need not be separated from surrounding content by blank
    // lines, and they can interrupt paragraphs:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 955-963
    func testExample47() {
        let markdownTest =
        #####"""
        ****
        ## foo
        ****\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<hr />
      //<h2>foo</h2>
      //<hr />
        let normalizedCM = #####"""
        <hr><h2>foo</h2><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 966-974
    func testExample48() {
        let markdownTest =
        #####"""
        Foo bar
        # baz
        Bar foo\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>Foo bar</p>
      //<h1>baz</h1>
      //<p>Bar foo</p>
        let normalizedCM = #####"""
        <p>Foo bar</p><h1>baz</h1><p>Bar foo</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // ATX headings can be empty:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 979-987
    func testExample49() {
        let markdownTest =
        #####"""
        ##
        #
        ### ###\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
        ("testExample32", testExample32),
        ("testExample33", testExample33),
        ("testExample34", testExample34),
        ("testExample35", testExample35),
        ("testExample36", testExample36),
        ("testExample37", testExample37),
        ("testExample38", testExample38),
        ("testExample39", testExample39),
        ("testExample40", testExample40),
        ("testExample41", testExample41),
        ("testExample42", testExample42),
        ("testExample43", testExample43),
        ("testExample44", testExample44),
        ("testExample45", testExample45),
        ("testExample46", testExample46),
        ("testExample47", testExample47),
        ("testExample48", testExample48),
        ("testExample49", testExample49)
        ]
    }
}