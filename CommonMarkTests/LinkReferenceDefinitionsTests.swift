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
    // spec.txt lines 3159-3165
    func testExample191() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url "title"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a href="/url" title="title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3168-3176
    func testExample192() {
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
        let normalizedCM = #####"""
        <p><a href="/url" title="the title">foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3179-3185
    func testExample193() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [Foo*bar\]]:my_(url) 'title (with parens)'
        
        [Foo*bar\]]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3188-3196
    func testExample194() {
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
    // spec.txt lines 3201-3215
    func testExample195() {
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
    // spec.txt lines 3220-3230
    func testExample196() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url 'title
        
        with blank line'
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3235-3242
    func testExample197() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]:
        /url
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3247-3254
    func testExample198() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]:
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3259-3265
    func testExample199() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: <>
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3270-3277
    func testExample200() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: <bar>(baz)
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3283-3289
    func testExample201() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url\bar\*baz "foo\"bar\baz"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3294-3300
    func testExample202() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3306-3313
    func testExample203() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        [foo]: first
        [foo]: second
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3319-3325
    func testExample204() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [FOO]: /url
        
        [Foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <p><a href="/url">Foo</a></p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    // 
    //     
    // spec.txt lines 3328-3334
    func testExample205() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [ΑΓΩ]: /φου
        
        [αγω]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3340-3343
    func testExample206() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3348-3355
    func testExample207() {
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
    // spec.txt lines 3361-3365
    func testExample208() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url "title" ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3370-3375
    func testExample209() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        "title" ok
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3381-3389
    func testExample210() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
            [foo]: /url "title"
        
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3395-3405
    func testExample211() {
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
    // spec.txt lines 3410-3419
    func testExample212() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        Foo
        [bar]: /baz
        
        [bar]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3425-3434
    func testExample213() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        # [Foo]
        [foo]: /url
        > bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        <h1><a href="/url">Foo</a></h1><blockquote><p>bar</p></blockquote>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 3436-3444
    func testExample214() {
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
        let normalizedCM = #####"""
        <h1>[foo]: /url bar</h1><p>[foo]</p>
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
    // 
    // 
    //     
    // spec.txt lines 3446-3453
    func testExample215() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        ===
        [foo]
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3459-3472
    func testExample216() {
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
    // spec.txt lines 3480-3488
    func testExample217() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]
        
        > [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
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
    // spec.txt lines 3497-3500
    func testExample218() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        [foo]: /url
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest)
        let normalizedCM = #####"""
        
        """#####
        XCTAssertEqual(html,normalizedCM)

    }
}

extension LinkReferenceDefinitionsTests {
    static var allTests: Linux.TestList<LinkReferenceDefinitionsTests> {
        return [
        ("testExample191", testExample191),
        ("testExample192", testExample192),
        ("testExample193", testExample193),
        ("testExample194", testExample194),
        ("testExample195", testExample195),
        ("testExample196", testExample196),
        ("testExample197", testExample197),
        ("testExample198", testExample198),
        ("testExample199", testExample199),
        ("testExample200", testExample200),
        ("testExample201", testExample201),
        ("testExample202", testExample202),
        ("testExample203", testExample203),
        ("testExample204", testExample204),
        ("testExample205", testExample205),
        ("testExample206", testExample206),
        ("testExample207", testExample207),
        ("testExample208", testExample208),
        ("testExample209", testExample209),
        ("testExample210", testExample210),
        ("testExample211", testExample211),
        ("testExample212", testExample212),
        ("testExample213", testExample213),
        ("testExample214", testExample214),
        ("testExample215", testExample215),
        ("testExample216", testExample216),
        ("testExample217", testExample217),
        ("testExample218", testExample218)
        ]
    }
}