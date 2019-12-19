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

final class ImagesTests: XCTestCase {

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8483-8487
    func testExample568() {
        let markdownTest =
        #####"""
        ![foo](/url "title")
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8490-8496
    func testExample569() {
        let markdownTest =
        #####"""
        ![foo *bar*]
        
        [foo *bar*]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8499-8503
    func testExample570() {
        let markdownTest =
        #####"""
        ![foo ![bar](/url)](/url2)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url2" alt="foo bar" /></p>
        let normalizedCM = #####"""
        <p><img src="/url2" alt="foo bar" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8506-8510
    func testExample571() {
        let markdownTest =
        #####"""
        ![foo [bar](/url)](/url2)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url2" alt="foo bar" /></p>
        let normalizedCM = #####"""
        <p><img src="/url2" alt="foo bar" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Though this spec is concerned with parsing, not rendering, it is
    // recommended that in rendering to HTML, only the plain string content
    // of the [image description] be used.  Note that in
    // the above example, the alt attribute's value is `foo bar`, not `foo
    // [bar](/url)` or `foo <a href="/url">bar</a>`.  Only the plain string
    // content is rendered, without formatting.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8520-8526
    func testExample572() {
        let markdownTest =
        #####"""
        ![foo *bar*][]
        
        [foo *bar*]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8529-8535
    func testExample573() {
        let markdownTest =
        #####"""
        ![foo *bar*][foobar]
        
        [FOOBAR]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8538-8542
    func testExample574() {
        let markdownTest =
        #####"""
        ![foo](train.jpg)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="train.jpg" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8545-8549
    func testExample575() {
        let markdownTest =
        #####"""
        My ![foo bar](/path/to/train.jpg  "title"   )
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>
        let normalizedCM = #####"""
        <p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8552-8556
    func testExample576() {
        let markdownTest =
        #####"""
        ![foo](<url>)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="url" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="url" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8559-8563
    func testExample577() {
        let markdownTest =
        #####"""
        ![](/url)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Reference-style:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8568-8574
    func testExample578() {
        let markdownTest =
        #####"""
        ![foo][bar]
        
        [bar]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8577-8583
    func testExample579() {
        let markdownTest =
        #####"""
        ![foo][bar]
        
        [BAR]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Collapsed:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8588-8594
    func testExample580() {
        let markdownTest =
        #####"""
        ![foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8597-8603
    func testExample581() {
        let markdownTest =
        #####"""
        ![*foo* bar][]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo bar" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The labels are case-insensitive:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8608-8614
    func testExample582() {
        let markdownTest =
        #####"""
        ![Foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="Foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="Foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // As with reference links, [whitespace] is not allowed
    // between the two sets of brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8620-8628
    func testExample583() {
        let markdownTest =
        #####"""
        ![foo] 
        []
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" title="title" />
      //[]</p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /> []</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Shortcut:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8633-8639
    func testExample584() {
        let markdownTest =
        #####"""
        ![foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8642-8648
    func testExample585() {
        let markdownTest =
        #####"""
        ![*foo* bar]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="foo bar" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that link labels cannot contain unescaped brackets:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8653-8660
    func testExample586() {
        let markdownTest =
        #####"""
        ![[foo]]
        
        [[foo]]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>![[foo]]</p>
      //<p>[[foo]]: /url &quot;title&quot;</p>
        let normalizedCM = #####"""
        <p>![[foo]]</p><p>[[foo]]: /url &quot;title&quot;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The link labels are case-insensitive:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8665-8671
    func testExample587() {
        let markdownTest =
        #####"""
        ![Foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><img src="/url" alt="Foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="Foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If you just want a literal `!` followed by bracketed text, you can
    // backslash-escape the opening `[`:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8677-8683
    func testExample588() {
        let markdownTest =
        #####"""
        !\[foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>![foo]</p>
        let normalizedCM = #####"""
        <p>![foo]</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If you want a link after a literal `!`, backslash-escape the
    // `!`:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 8689-8695
    func testExample589() {
        let markdownTest =
        #####"""
        \![foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>!<a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p>!<a href="/url" title="title">foo</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension ImagesTests {
    static var allTests: Linux.TestList<ImagesTests> {
        return [
        ("testExample568", testExample568),
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
        ("testExample589", testExample589)
        ]
    }
}