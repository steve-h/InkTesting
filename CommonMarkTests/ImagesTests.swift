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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8792-8796
    func testExample580() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8799-8805
    func testExample581() {
        let markdownTest =
        #####"""
        ![foo *bar*]
        
        [foo *bar*]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8808-8812
    func testExample582() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8815-8819
    func testExample583() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8829-8835
    func testExample584() {
        let markdownTest =
        #####"""
        ![foo *bar*][]
        
        [foo *bar*]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8838-8844
    func testExample585() {
        let markdownTest =
        #####"""
        ![foo *bar*][foobar]
        
        [FOOBAR]: train.jpg "train & tracks"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        let normalizedCM = #####"""
        <p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8847-8851
    func testExample586() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8854-8858
    func testExample587() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8861-8865
    func testExample588() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8868-8872
    func testExample589() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8877-8883
    func testExample590() {
        let markdownTest =
        #####"""
        ![foo][bar]
        
        [bar]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8886-8892
    func testExample591() {
        let markdownTest =
        #####"""
        ![foo][bar]
        
        [BAR]: /url\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Collapsed:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8897-8903
    func testExample592() {
        let markdownTest =
        #####"""
        ![foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8906-8912
    func testExample593() {
        let markdownTest =
        #####"""
        ![*foo* bar][]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo bar" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The labels are case-insensitive:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8917-8923
    func testExample594() {
        let markdownTest =
        #####"""
        ![Foo][]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8929-8937
    func testExample595() {
        let markdownTest =
        #####"""
        ![foo]
        []
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8942-8948
    func testExample596() {
        let markdownTest =
        #####"""
        ![foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8951-8957
    func testExample597() {
        let markdownTest =
        #####"""
        ![*foo* bar]
        
        [*foo* bar]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><img src="/url" alt="foo bar" title="title" /></p>
        let normalizedCM = #####"""
        <p><img src="/url" alt="foo bar" title="title" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that link labels cannot contain unescaped brackets:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8962-8969
    func testExample598() {
        let markdownTest =
        #####"""
        ![[foo]]
        
        [[foo]]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8974-8980
    func testExample599() {
        let markdownTest =
        #####"""
        ![Foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8986-8992
    func testExample600() {
        let markdownTest =
        #####"""
        !\[foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 8998-9004
    func testExample601() {
        let markdownTest =
        #####"""
        \![foo]
        
        [foo]: /url "title"\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
        ("testExample601", testExample601)
        ]
    }
}