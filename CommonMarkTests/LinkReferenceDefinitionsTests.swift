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

final class LinkReferenceDefinitionsTests: XCTestCase {

    // 
    // 
    // Fortunately, blank lines are usually not necessary and can be
    // deleted.  The exception is inside `<pre>` tags, but as described
    // [above][HTML blocks], raw HTML blocks starting with `<pre>`
    // *can* contain blank lines.
    // 
    // ## Link reference definitions
    // 
    // A [link reference definition](@)
    // consists of a [link label], indented up to three spaces, followed
    // by a colon (`:`), optional [whitespace] (including up to one
    // [line ending]), a [link destination],
    // optional [whitespace] (including up to one
    // [line ending]), and an optional [link
    // title], which if it is present must be separated
    // from the [link destination] by [whitespace].
    // No further [non-whitespace characters] may occur on the line.
    // 
    // A [link reference definition]
    // does not correspond to a structural element of a document.  Instead, it
    // defines a label which can be used in [reference links]
    // and reference-style [images] elsewhere in the document.  [Link
    // reference definitions] can come either before or after the links that use
    // them.
    // 
    // 
    //     
    // spec.txt lines 2816-2822
    func testExample161() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url "title"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2825-2833
    func testExample162() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
           [foo]: 
              /url  
                   'the title'  
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="the title">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="the title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2836-2842
    func testExample163() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo*bar\]]:my_(url) 'title (with parens)'
        
        [Foo*bar\]]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>
        let normalizedCM = #####"""
        <p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2845-2853
    func testExample164() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo bar]:
        <my url>
        'title'
        
        [Foo bar]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="my%20url" title="title">Foo bar</a></p>
        let normalizedCM = #####"""
        <p>[Foo bar]: <my url> 'title'</p><p>[Foo bar]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The title may extend over multiple lines:
    // 
    // 
    //     
    // spec.txt lines 2858-2872
    func testExample165() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url '
        title
        line1
        line2
        '
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url" title="
      //title
      //line1
      //line2
      //">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url" title="
        title
        line1
        line2
        ">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, it may not contain a [blank line]:
    // 
    // 
    //     
    // spec.txt lines 2877-2887
    func testExample166() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url 'title
        
        with blank line'
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]: /url 'title</p>
      //<p>with blank line'</p>
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <p>[foo]: /url 'title</p><p>with blank line'</p><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The title may be omitted:
    // 
    // 
    //     
    // spec.txt lines 2892-2899
    func testExample167() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]:
        /url
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // The link destination may not be omitted:
    // 
    // 
    //     
    // spec.txt lines 2904-2911
    func testExample168() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]:
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]:</p>
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <p>[foo]:</p><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    //  However, an empty link destination may be specified using
    //  angle brackets:
    // 
    // 
    //     
    // spec.txt lines 2916-2922
    func testExample169() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: <>
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // The title must be separated from the link destination by
    // whitespace:
    // 
    // 
    //     
    // spec.txt lines 2927-2934
    func testExample170() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: <bar>(baz)
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]: <bar>(baz)</p>
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <p><a href="bar" title="baz">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Both title and destination can contain backslash escapes
    // and literal backslashes:
    // 
    // 
    //     
    // spec.txt lines 2940-2946
    func testExample171() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url\bar\*baz "foo\"bar\baz"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url%5Cbar*baz" title="foo&quot;bar\baz">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url%5Cbar*baz" title="foo&quot;bar\baz">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A link can come before its corresponding definition:
    // 
    // 
    //     
    // spec.txt lines 2951-2957
    func testExample172() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="url">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="url">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // If there are several matching definitions, the first one takes
    // precedence:
    // 
    // 
    //     
    // spec.txt lines 2963-2970
    func testExample173() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: first
        [foo]: second
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="first">foo</a></p>
        let normalizedCM = #####"""
        <p><a href="first">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // As noted in the section on [Links], matching of labels is
    // case-insensitive (see [matches]).
    // 
    // 
    //     
    // spec.txt lines 2976-2982
    func testExample174() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [FOO]: /url
        
        [Foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">Foo</a></p>
        let normalizedCM = #####"""
        <p><a href="/url">Foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 2985-2991
    func testExample175() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [ΑΓΩ]: /φου
        
        [αγω]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>
        let normalizedCM = #####"""
        <p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here is a link reference definition with no corresponding link.
    // It contributes nothing to the document.
    // 
    // 
    //     
    // spec.txt lines 2997-3000
    func testExample176() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //
        let normalizedCM = #####"""
        
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Here is another one:
    // 
    // 
    //     
    // spec.txt lines 3005-3012
    func testExample177() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [
        foo
        ]: /url
        bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>bar</p>
        let normalizedCM = #####"""
        <p>bar</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a link reference definition, because there are
    // [non-whitespace characters] after the title:
    // 
    // 
    //     
    // spec.txt lines 3018-3022
    func testExample178() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url "title" ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>[foo]: /url &quot;title&quot; ok</p>
        let normalizedCM = #####"""
        <p>[foo]: /url &quot;title&quot; ok</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is a link reference definition, but it has no title:
    // 
    // 
    //     
    // spec.txt lines 3027-3032
    func testExample179() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        "title" ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>&quot;title&quot; ok</p>
        let normalizedCM = #####"""
        <p>&quot;title&quot; ok</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a link reference definition, because it is indented
    // four spaces:
    // 
    // 
    //     
    // spec.txt lines 3038-3046
    func testExample180() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            [foo]: /url "title"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>[foo]: /url &quot;title&quot;
      //</code></pre>
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <pre><code>[foo]: /url &quot;title&quot;
        </code></pre><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // This is not a link reference definition, because it occurs inside
    // a code block:
    // 
    // 
    //     
    // spec.txt lines 3052-3062
    func testExample181() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ```
        [foo]: /url
        ```
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>[foo]: /url
      //</code></pre>
      //<p>[foo]</p>
        let normalizedCM = #####"""
        <pre><code>[foo]: /url
        </code></pre><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // A [link reference definition] cannot interrupt a paragraph.
    // 
    // 
    //     
    // spec.txt lines 3067-3076
    func testExample182() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        [bar]: /baz
        
        [bar]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo
      //[bar]: /baz</p>
      //<p>[bar]</p>
        let normalizedCM = #####"""
        <p>Foo [bar]: /baz</p><p>[bar]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // However, it can directly follow other block elements, such as headings
    // and thematic breaks, and it need not be followed by a blank line.
    // 
    // 
    //     
    // spec.txt lines 3082-3091
    func testExample183() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # [Foo]
        [foo]: /url
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1><a href="/url">Foo</a></h1>
      //<blockquote>
      //<p>bar</p>
      //</blockquote>
        let normalizedCM = #####"""
        <h1><a href="/url">Foo</a></h1><blockquote><p>bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 3093-3101
    func testExample184() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        bar
        ===
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>bar</h1>
      //<p><a href="/url">foo</a></p>
        let normalizedCM = #####"""
        <h1>[foo]: /url bar</h1><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 3103-3110
    func testExample185() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        ===
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>===
      //<a href="/url">foo</a></p>
        let normalizedCM = #####"""
        <h1>[foo]: /url</h1><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Several [link reference definitions]
    // can occur one after another, without intervening blank lines.
    // 
    // 
    //     
    // spec.txt lines 3116-3129
    func testExample186() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /foo-url "foo"
        [bar]: /bar-url
          "bar"
        [baz]: /baz-url
        
        [foo],
        [bar],
        [baz]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/foo-url" title="foo">foo</a>,
      //<a href="/bar-url" title="bar">bar</a>,
      //<a href="/baz-url">baz</a></p>
        let normalizedCM = #####"""
        <p><a href="/foo-url" title="foo">foo</a>, <a href="/bar-url" title="bar">bar</a>, <a href="/baz-url">baz</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // [Link reference definitions] can occur
    // inside block containers, like lists and block quotations.  They
    // affect the entire document, not just the container in which they
    // are defined:
    // 
    // 
    //     
    // spec.txt lines 3137-3145
    func testExample187() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        > [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><a href="/url">foo</a></p>
      //<blockquote>
      //</blockquote>
        let normalizedCM = #####"""
        <p><a href="/url">foo</a></p><blockquote></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // Whether something is a [link reference definition] is
    // independent of whether the link reference it defines is
    // used in the document.  Thus, for example, the following
    // document contains just a link reference definition, and
    // no visible content:
    // 
    // 
    //     
    // spec.txt lines 3154-3157
    func testExample188() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        
      //
        let normalizedCM = #####"""
        
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension LinkReferenceDefinitionsTests {
    static var allTests: Linux.TestList<LinkReferenceDefinitionsTests> {
        return [
        ("testExample161", testExample161),
        ("testExample162", testExample162),
        ("testExample163", testExample163),
        ("testExample164", testExample164),
        ("testExample165", testExample165),
        ("testExample166", testExample166),
        ("testExample167", testExample167),
        ("testExample168", testExample168),
        ("testExample169", testExample169),
        ("testExample170", testExample170),
        ("testExample171", testExample171),
        ("testExample172", testExample172),
        ("testExample173", testExample173),
        ("testExample174", testExample174),
        ("testExample175", testExample175),
        ("testExample176", testExample176),
        ("testExample177", testExample177),
        ("testExample178", testExample178),
        ("testExample179", testExample179),
        ("testExample180", testExample180),
        ("testExample181", testExample181),
        ("testExample182", testExample182),
        ("testExample183", testExample183),
        ("testExample184", testExample184),
        ("testExample185", testExample185),
        ("testExample186", testExample186),
        ("testExample187", testExample187),
        ("testExample188", testExample188)
        ]
    }
}