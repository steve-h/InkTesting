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

final class ImagesTests: XCTestCase {

    // 
    // 
    // 
    // ## Images
    // 
    // Syntax for images is like the syntax for links, with one
    // difference. Instead of [link text], we have an
    // [image description](@).  The rules for this are the
    // same as for [link text], except that (a) an
    // image description starts with `![` rather than `[`, and
    // (b) an image description may contain links.
    // An image description has inline elements
    // as its contents.  When an image is rendered to HTML,
    // this is standardly used as the image's `alt` attribute.
    // 
    // 
    //     
    // spec.txt lines 8494-8498
    func testExample569() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo](/url "title")
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8501-8507
    func testExample570() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo *bar*]
        
        [foo *bar*]: train.jpg "train & tracks"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8510-8514
    func testExample571() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo ![bar](/url)](/url2)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url2" alt="foo bar" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8517-8521
    func testExample572() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo [bar](/url)](/url2)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url2" alt="foo bar" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Though this spec is concerned with parsing, not rendering, it is
    // recommended that in rendering to HTML, only the plain string content
    // of the [image description] be used.  Note that in
    // the above example, the alt attribute's value is `foo bar`, not `foo
    // [bar](/url)` or `foo <a href="/url">bar</a>`.  Only the plain string
    // content is rendered, without formatting.
    // 
    // 
    //     
    // spec.txt lines 8531-8537
    func testExample573() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo *bar*][]
        
        [foo *bar*]: train.jpg "train & tracks"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8540-8546
    func testExample574() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo *bar*][foobar]
        
        [FOOBAR]: train.jpg "train & tracks"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8549-8553
    func testExample575() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo](train.jpg)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8556-8560
    func testExample576() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        My ![foo bar](/path/to/train.jpg  "title"   )
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8563-8567
    func testExample577() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo](<url>)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="url" alt="foo" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8570-8574
    func testExample578() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![](/url)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Reference-style:
    // 
    // 
    //     
    // spec.txt lines 8579-8585
    func testExample579() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo][bar]
        
        [bar]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8588-8594
    func testExample580() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo][bar]
        
        [BAR]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Collapsed:
    // 
    // 
    //     
    // spec.txt lines 8599-8605
    func testExample581() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo][]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8608-8614
    func testExample582() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![*foo* bar][]
        
        [*foo* bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The labels are case-insensitive:
    // 
    // 
    //     
    // spec.txt lines 8619-8625
    func testExample583() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![Foo][]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="Foo" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // As with reference links, [whitespace] is not allowed
    // between the two sets of brackets:
    // 
    // 
    //     
    // spec.txt lines 8631-8639
    func testExample584() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo] 
        []
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" />
        []</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Shortcut:
    // 
    // 
    //     
    // spec.txt lines 8644-8650
    func testExample585() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 8653-8659
    func testExample586() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![*foo* bar]
        
        [*foo* bar]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Note that link labels cannot contain unescaped brackets:
    // 
    // 
    //     
    // spec.txt lines 8664-8671
    func testExample587() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![[foo]]
        
        [[foo]]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>![[foo]]</p><p>[[foo]]: /url &quot;title&quot;</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link labels are case-insensitive:
    // 
    // 
    //     
    // spec.txt lines 8676-8682
    func testExample588() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ![Foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><img src="/url" alt="Foo" title="title" /></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // If you just want a literal `!` followed by bracketed text, you can
    // backslash-escape the opening `[`:
    // 
    // 
    //     
    // spec.txt lines 8688-8694
    func testExample589() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        !\[foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>![foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // If you want a link after a literal `!`, backslash-escape the
    // `!`:
    // 
    // 
    //     
    // spec.txt lines 8700-8706
    func testExample590() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        \![foo]
        
        [foo]: /url "title"
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p>!<a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension ImagesTests {
    static var allTests: Linux.TestList<ImagesTests> {
        return [
        ("testExample569", testExample569),
        ("testExample570", testExample570),
        ("testExample571", testExample571),
        ("testExample572", testExample572),
        ("testExample573", testExample573),
        ("testExample574", testExample574),
        ("testExample575", testExample575),
        ("testExample576", testExample576),
        ("testExample577", testExample577),
        ("testExample578", testExample578),
        ("testExample579", testExample579),
        ("testExample580", testExample580),
        ("testExample581", testExample581),
        ("testExample582", testExample582),
        ("testExample583", testExample583),
        ("testExample584", testExample584),
        ("testExample585", testExample585),
        ("testExample586", testExample586),
        ("testExample587", testExample587),
        ("testExample588", testExample588),
        ("testExample589", testExample589),
        ("testExample590", testExample590)
        ]
    }
}