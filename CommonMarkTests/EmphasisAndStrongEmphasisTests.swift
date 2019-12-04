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

final class EmphasisAndStrongEmphasisTests: XCTestCase {

    // 
    // 
    // ## Emphasis and strong emphasis
    // 
    // John Gruber's original [Markdown syntax
    // description](http://daringfireball.net/projects/markdown/syntax#em) says:
    // 
    // > Markdown treats asterisks (`*`) and underscores (`_`) as indicators of
    // > emphasis. Text wrapped with one `*` or `_` will be wrapped with an HTML
    // > `<em>` tag; double `*`'s or `_`'s will be wrapped with an HTML `<strong>`
    // > tag.
    // 
    // This is enough for most users, but these rules leave much undecided,
    // especially when it comes to nested emphasis.  The original
    // `Markdown.pl` test suite makes it clear that triple `***` and
    // `___` delimiters can be used for strong emphasis, and most
    // implementations have also allowed the following patterns:
    // 
    // ``` markdown
    // ***strong emph***
    // ***strong** in emph*
    // ***emph* in strong**
    // **in strong *emph***
    // *in emph **strong***
    // ```
    // 
    // The following patterns are less widely supported, but the intent
    // is clear and they are useful (especially in contexts like bibliography
    // entries):
    // 
    // ``` markdown
    // *emph *with emph* in it*
    // **strong **with strong** in it**
    // ```
    // 
    // Many implementations have also restricted intraword emphasis to
    // the `*` forms, to avoid unwanted emphasis in words containing
    // internal underscores.  (It is best practice to put these in code
    // spans, but users often do not.)
    // 
    // ``` markdown
    // internal emphasis: foo*bar*baz
    // no emphasis: foo_bar_baz
    // ```
    // 
    // The rules given below capture all of these patterns, while allowing
    // for efficient parsing strategies that do not backtrack.
    // 
    // First, some definitions.  A [delimiter run](@) is either
    // a sequence of one or more `*` characters that is not preceded or
    // followed by a non-backslash-escaped `*` character, or a sequence
    // of one or more `_` characters that is not preceded or followed by
    // a non-backslash-escaped `_` character.
    // 
    // A [left-flanking delimiter run](@) is
    // a [delimiter run] that is (1) not followed by [Unicode whitespace],
    // and either (2a) not followed by a [punctuation character], or
    // (2b) followed by a [punctuation character] and
    // preceded by [Unicode whitespace] or a [punctuation character].
    // For purposes of this definition, the beginning and the end of
    // the line count as Unicode whitespace.
    // 
    // A [right-flanking delimiter run](@) is
    // a [delimiter run] that is (1) not preceded by [Unicode whitespace],
    // and either (2a) not preceded by a [punctuation character], or
    // (2b) preceded by a [punctuation character] and
    // followed by [Unicode whitespace] or a [punctuation character].
    // For purposes of this definition, the beginning and the end of
    // the line count as Unicode whitespace.
    // 
    // Here are some examples of delimiter runs.
    // 
    //   - left-flanking but not right-flanking:
    // 
    //     ```
    //     ***abc
    //       _abc
    //     **"abc"
    //      _"abc"
    //     ```
    // 
    //   - right-flanking but not left-flanking:
    // 
    //     ```
    //      abc***
    //      abc_
    //     "abc"**
    //     "abc"_
    //     ```
    // 
    //   - Both left and right-flanking:
    // 
    //     ```
    //      abc***def
    //     "abc"_"def"
    //     ```
    // 
    //   - Neither left nor right-flanking:
    // 
    //     ```
    //     abc *** def
    //     a _ b
    //     ```
    // 
    // (The idea of distinguishing left-flanking and right-flanking
    // delimiter runs based on the character before and the character
    // after comes from Roopesh Chander's
    // [vfmd](http://www.vfmd.org/vfmd-spec/specification/#procedure-for-identifying-emphasis-tags).
    // vfmd uses the terminology "emphasis indicator string" instead of "delimiter
    // run," and its rules for distinguishing left- and right-flanking runs
    // are a bit more complex than the ones given here.)
    // 
    // The following rules define emphasis and strong emphasis:
    // 
    // 1.  A single `*` character [can open emphasis](@)
    //     iff (if and only if) it is part of a [left-flanking delimiter run].
    // 
    // 2.  A single `_` character [can open emphasis] iff
    //     it is part of a [left-flanking delimiter run]
    //     and either (a) not part of a [right-flanking delimiter run]
    //     or (b) part of a [right-flanking delimiter run]
    //     preceded by punctuation.
    // 
    // 3.  A single `*` character [can close emphasis](@)
    //     iff it is part of a [right-flanking delimiter run].
    // 
    // 4.  A single `_` character [can close emphasis] iff
    //     it is part of a [right-flanking delimiter run]
    //     and either (a) not part of a [left-flanking delimiter run]
    //     or (b) part of a [left-flanking delimiter run]
    //     followed by punctuation.
    // 
    // 5.  A double `**` [can open strong emphasis](@)
    //     iff it is part of a [left-flanking delimiter run].
    // 
    // 6.  A double `__` [can open strong emphasis] iff
    //     it is part of a [left-flanking delimiter run]
    //     and either (a) not part of a [right-flanking delimiter run]
    //     or (b) part of a [right-flanking delimiter run]
    //     preceded by punctuation.
    // 
    // 7.  A double `**` [can close strong emphasis](@)
    //     iff it is part of a [right-flanking delimiter run].
    // 
    // 8.  A double `__` [can close strong emphasis] iff
    //     it is part of a [right-flanking delimiter run]
    //     and either (a) not part of a [left-flanking delimiter run]
    //     or (b) part of a [left-flanking delimiter run]
    //     followed by punctuation.
    // 
    // 9.  Emphasis begins with a delimiter that [can open emphasis] and ends
    //     with a delimiter that [can close emphasis], and that uses the same
    //     character (`_` or `*`) as the opening delimiter.  The
    //     opening and closing delimiters must belong to separate
    //     [delimiter runs].  If one of the delimiters can both
    //     open and close emphasis, then the sum of the lengths of the
    //     delimiter runs containing the opening and closing delimiters
    //     must not be a multiple of 3 unless both lengths are
    //     multiples of 3.
    // 
    // 10. Strong emphasis begins with a delimiter that
    //     [can open strong emphasis] and ends with a delimiter that
    //     [can close strong emphasis], and that uses the same character
    //     (`_` or `*`) as the opening delimiter.  The
    //     opening and closing delimiters must belong to separate
    //     [delimiter runs].  If one of the delimiters can both open
    //     and close strong emphasis, then the sum of the lengths of
    //     the delimiter runs containing the opening and closing
    //     delimiters must not be a multiple of 3 unless both lengths
    //     are multiples of 3.
    // 
    // 11. A literal `*` character cannot occur at the beginning or end of
    //     `*`-delimited emphasis or `**`-delimited strong emphasis, unless it
    //     is backslash-escaped.
    // 
    // 12. A literal `_` character cannot occur at the beginning or end of
    //     `_`-delimited emphasis or `__`-delimited strong emphasis, unless it
    //     is backslash-escaped.
    // 
    // Where rules 1--12 above are compatible with multiple parsings,
    // the following principles resolve ambiguity:
    // 
    // 13. The number of nestings should be minimized. Thus, for example,
    //     an interpretation `<strong>...</strong>` is always preferred to
    //     `<em><em>...</em></em>`.
    // 
    // 14. An interpretation `<em><strong>...</strong></em>` is always
    //     preferred to `<strong><em>...</em></strong>`.
    // 
    // 15. When two potential emphasis or strong emphasis spans overlap,
    //     so that the second begins before the first ends and ends after
    //     the first ends, the first takes precedence. Thus, for example,
    //     `*foo _bar* baz_` is parsed as `<em>foo _bar</em> baz_` rather
    //     than `*foo <em>bar* baz</em>`.
    // 
    // 16. When there are two potential emphasis or strong emphasis spans
    //     with the same closing delimiter, the shorter one (the one that
    //     opens later) takes precedence. Thus, for example,
    //     `**foo **bar baz**` is parsed as `**foo <strong>bar baz</strong>`
    //     rather than `<strong>foo **bar baz</strong>`.
    // 
    // 17. Inline code spans, links, images, and HTML tags group more tightly
    //     than emphasis.  So, when there is a choice between an interpretation
    //     that contains one of these elements and one that does not, the
    //     former always wins.  Thus, for example, `*[foo*](bar)` is
    //     parsed as `*<a href="bar">foo*</a>` rather than as
    //     `<em>[foo</em>](bar)`.
    // 
    // These rules can be illustrated through a series of examples.
    // 
    // Rule 1:
    // 
    // 
    //     
    // spec.txt lines 6296-6300
    func testExample350() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo bar</em></p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the opening `*` is followed by
    // whitespace, and hence not part of a [left-flanking delimiter run]:
    // 
    // 
    //     
    // spec.txt lines 6306-6310
    func testExample351() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        a * foo bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>a * foo bar*</p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the opening `*` is preceded
    // by an alphanumeric and followed by punctuation, and hence
    // not part of a [left-flanking delimiter run]:
    // 
    // 
    //     
    // spec.txt lines 6317-6321
    func testExample352() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        a*"foo"*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>a*&quot;foo&quot;*</p>
        """#####
        )
    }
    // 
    // 
    // Unicode nonbreaking spaces count as whitespace, too:
    // 
    // 
    //     
    // spec.txt lines 6326-6330
    func testExample353() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        * a *
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>* a *</p>
        """#####
        )
    }
    // 
    // 
    // Intraword emphasis with `*` is permitted:
    // 
    // 
    //     
    // spec.txt lines 6335-6339
    func testExample354() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo*bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<em>bar</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6342-6346
    func testExample355() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        5*6*78
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>5<em>6</em>78</p>
        """#####
        )
    }
    // 
    // 
    // Rule 2:
    // 
    // 
    //     
    // spec.txt lines 6351-6355
    func testExample356() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo bar_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo bar</em></p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the opening `_` is followed by
    // whitespace:
    // 
    // 
    //     
    // spec.txt lines 6361-6365
    func testExample357() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _ foo bar_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_ foo bar_</p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the opening `_` is preceded
    // by an alphanumeric and followed by punctuation:
    // 
    // 
    //     
    // spec.txt lines 6371-6375
    func testExample358() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        a_"foo"_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>a_&quot;foo&quot;_</p>
        """#####
        )
    }
    // 
    // 
    // Emphasis with `_` is not allowed inside words:
    // 
    // 
    //     
    // spec.txt lines 6380-6384
    func testExample359() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo_bar_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo_bar_</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6387-6391
    func testExample360() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        5_6_78
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>5_6_78</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6394-6398
    func testExample361() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        пристаням_стремятся_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>пристаням_стремятся_</p>
        """#####
        )
    }
    // 
    // 
    // Here `_` does not generate emphasis, because the first delimiter run
    // is right-flanking and the second left-flanking:
    // 
    // 
    //     
    // spec.txt lines 6404-6408
    func testExample362() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        aa_"bb"_cc
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>aa_&quot;bb&quot;_cc</p>
        """#####
        )
    }
    // 
    // 
    // This is emphasis, even though the opening delimiter is
    // both left- and right-flanking, because it is preceded by
    // punctuation:
    // 
    // 
    //     
    // spec.txt lines 6415-6419
    func testExample363() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo-_(bar)_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo-<em>(bar)</em></p>
        """#####
        )
    }
    // 
    // 
    // Rule 3:
    // 
    // This is not emphasis, because the closing delimiter does
    // not match the opening delimiter:
    // 
    // 
    //     
    // spec.txt lines 6427-6431
    func testExample364() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_foo*</p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the closing `*` is preceded by
    // whitespace:
    // 
    // 
    //     
    // spec.txt lines 6437-6441
    func testExample365() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo bar *
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*foo bar *</p>
        """#####
        )
    }
    // 
    // 
    // A newline also counts as whitespace:
    // 
    // 
    //     
    // spec.txt lines 6446-6452
    func testExample366() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo bar
        *
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*foo bar
        *</p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the second `*` is
    // preceded by punctuation and followed by an alphanumeric
    // (hence it is not part of a [right-flanking delimiter run]:
    // 
    // 
    //     
    // spec.txt lines 6459-6463
    func testExample367() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *(*foo)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*(*foo)</p>
        """#####
        )
    }
    // 
    // 
    // The point of this restriction is more easily appreciated
    // with this example:
    // 
    // 
    //     
    // spec.txt lines 6469-6473
    func testExample368() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *(*foo*)*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>(<em>foo</em>)</em></p>
        """#####
        )
    }
    // 
    // 
    // Intraword emphasis with `*` is allowed:
    // 
    // 
    //     
    // spec.txt lines 6478-6482
    func testExample369() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo*bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo</em>bar</p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 4:
    // 
    // This is not emphasis, because the closing `_` is preceded by
    // whitespace:
    // 
    // 
    //     
    // spec.txt lines 6491-6495
    func testExample370() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo bar _
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_foo bar _</p>
        """#####
        )
    }
    // 
    // 
    // This is not emphasis, because the second `_` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    // 
    //     
    // spec.txt lines 6501-6505
    func testExample371() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _(_foo)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_(_foo)</p>
        """#####
        )
    }
    // 
    // 
    // This is emphasis within emphasis:
    // 
    // 
    //     
    // spec.txt lines 6510-6514
    func testExample372() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _(_foo_)_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>(<em>foo</em>)</em></p>
        """#####
        )
    }
    // 
    // 
    // Intraword emphasis is disallowed for `_`:
    // 
    // 
    //     
    // spec.txt lines 6519-6523
    func testExample373() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo_bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_foo_bar</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6526-6530
    func testExample374() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _пристаням_стремятся
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_пристаням_стремятся</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6533-6537
    func testExample375() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo_bar_baz_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo_bar_baz</em></p>
        """#####
        )
    }
    // 
    // 
    // This is emphasis, even though the closing delimiter is
    // both left- and right-flanking, because it is followed by
    // punctuation:
    // 
    // 
    //     
    // spec.txt lines 6544-6548
    func testExample376() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _(bar)_.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>(bar)</em>.</p>
        """#####
        )
    }
    // 
    // 
    // Rule 5:
    // 
    // 
    //     
    // spec.txt lines 6553-6557
    func testExample377() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // This is not strong emphasis, because the opening delimiter is
    // followed by whitespace:
    // 
    // 
    //     
    // spec.txt lines 6563-6567
    func testExample378() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ** foo bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>** foo bar**</p>
        """#####
        )
    }
    // 
    // 
    // This is not strong emphasis, because the opening `**` is preceded
    // by an alphanumeric and followed by punctuation, and hence
    // not part of a [left-flanking delimiter run]:
    // 
    // 
    //     
    // spec.txt lines 6574-6578
    func testExample379() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        a**"foo"**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>a**&quot;foo&quot;**</p>
        """#####
        )
    }
    // 
    // 
    // Intraword strong emphasis with `**` is permitted:
    // 
    // 
    //     
    // spec.txt lines 6583-6587
    func testExample380() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo**bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<strong>bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // Rule 6:
    // 
    // 
    //     
    // spec.txt lines 6592-6596
    func testExample381() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo bar__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // This is not strong emphasis, because the opening delimiter is
    // followed by whitespace:
    // 
    // 
    //     
    // spec.txt lines 6602-6606
    func testExample382() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __ foo bar__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__ foo bar__</p>
        """#####
        )
    }
    // 
    // 
    // A newline counts as whitespace:
    // 
    //     
    // spec.txt lines 6610-6616
    func testExample383() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __
        foo bar__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__
        foo bar__</p>
        """#####
        )
    }
    // 
    // 
    // This is not strong emphasis, because the opening `__` is preceded
    // by an alphanumeric and followed by punctuation:
    // 
    // 
    //     
    // spec.txt lines 6622-6626
    func testExample384() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        a__"foo"__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>a__&quot;foo&quot;__</p>
        """#####
        )
    }
    // 
    // 
    // Intraword strong emphasis is forbidden with `__`:
    // 
    // 
    //     
    // spec.txt lines 6631-6635
    func testExample385() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo__bar__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo__bar__</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6638-6642
    func testExample386() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        5__6__78
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>5__6__78</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6645-6649
    func testExample387() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        пристаням__стремятся__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>пристаням__стремятся__</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6652-6656
    func testExample388() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo, __bar__, baz__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo, <strong>bar</strong>, baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // This is strong emphasis, even though the opening delimiter is
    // both left- and right-flanking, because it is preceded by
    // punctuation:
    // 
    // 
    //     
    // spec.txt lines 6663-6667
    func testExample389() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo-__(bar)__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo-<strong>(bar)</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 7:
    // 
    // This is not strong emphasis, because the closing delimiter is preceded
    // by whitespace:
    // 
    // 
    //     
    // spec.txt lines 6676-6680
    func testExample390() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo bar **
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**foo bar **</p>
        """#####
        )
    }
    // 
    // 
    // (Nor can it be interpreted as an emphasized `*foo bar *`, because of
    // Rule 11.)
    // 
    // This is not strong emphasis, because the second `**` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    // 
    //     
    // spec.txt lines 6689-6693
    func testExample391() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **(**foo)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**(**foo)</p>
        """#####
        )
    }
    // 
    // 
    // The point of this restriction is more easily appreciated
    // with these examples:
    // 
    // 
    //     
    // spec.txt lines 6699-6703
    func testExample392() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *(**foo**)*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>(<strong>foo</strong>)</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6706-6712
    func testExample393() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **Gomphocarpus (*Gomphocarpus physocarpus*, syn.
        *Asclepias physocarpa*)**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
        <em>Asclepias physocarpa</em>)</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6715-6719
    func testExample394() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo "*bar*" foo**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>
        """#####
        )
    }
    // 
    // 
    // Intraword emphasis:
    // 
    // 
    //     
    // spec.txt lines 6724-6728
    func testExample395() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo**bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo</strong>bar</p>
        """#####
        )
    }
    // 
    // 
    // Rule 8:
    // 
    // This is not strong emphasis, because the closing delimiter is
    // preceded by whitespace:
    // 
    // 
    //     
    // spec.txt lines 6736-6740
    func testExample396() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo bar __
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__foo bar __</p>
        """#####
        )
    }
    // 
    // 
    // This is not strong emphasis, because the second `__` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    // 
    //     
    // spec.txt lines 6746-6750
    func testExample397() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __(__foo)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__(__foo)</p>
        """#####
        )
    }
    // 
    // 
    // The point of this restriction is more easily appreciated
    // with this example:
    // 
    // 
    //     
    // spec.txt lines 6756-6760
    func testExample398() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _(__foo__)_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>(<strong>foo</strong>)</em></p>
        """#####
        )
    }
    // 
    // 
    // Intraword strong emphasis is forbidden with `__`:
    // 
    // 
    //     
    // spec.txt lines 6765-6769
    func testExample399() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo__bar
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__foo__bar</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6772-6776
    func testExample400() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __пристаням__стремятся
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__пристаням__стремятся</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6779-6783
    func testExample401() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo__bar__baz__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo__bar__baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // This is strong emphasis, even though the closing delimiter is
    // both left- and right-flanking, because it is followed by
    // punctuation:
    // 
    // 
    //     
    // spec.txt lines 6790-6794
    func testExample402() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __(bar)__.
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>(bar)</strong>.</p>
        """#####
        )
    }
    // 
    // 
    // Rule 9:
    // 
    // Any nonempty sequence of inline elements can be the contents of an
    // emphasized span.
    // 
    // 
    //     
    // spec.txt lines 6802-6806
    func testExample403() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo [bar](/url)*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <a href="/url">bar</a></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6809-6815
    func testExample404() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo
        bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo
        bar</em></p>
        """#####
        )
    }
    // 
    // 
    // In particular, emphasis and strong emphasis can be nested
    // inside emphasis:
    // 
    // 
    //     
    // spec.txt lines 6821-6825
    func testExample405() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo __bar__ baz_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <strong>bar</strong> baz</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6828-6832
    func testExample406() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo _bar_ baz_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <em>bar</em> baz</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6835-6839
    func testExample407() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo_ bar_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><em>foo</em> bar</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6842-6846
    func testExample408() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo *bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <em>bar</em></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6849-6853
    func testExample409() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo **bar** baz*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <strong>bar</strong> baz</em></p>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 6855-6859
    func testExample410() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo**bar**baz*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo<strong>bar</strong>baz</em></p>
        """#####
        )
    }
    // 
    // Note that in the preceding case, the interpretation
    // 
    // ``` markdown
    // <p><em>foo</em><em>bar<em></em>baz</em></p>
    // ```
    // 
    // 
    // is precluded by the condition that a delimiter that
    // can both open and close (like the `*` after `foo`)
    // cannot form emphasis if the sum of the lengths of
    // the delimiter runs containing the opening and
    // closing delimiters is a multiple of 3 unless
    // both lengths are multiples of 3.
    // 
    // 
    // For the same reason, we don't get two consecutive
    // emphasis sections in this example:
    // 
    // 
    //     
    // spec.txt lines 6879-6883
    func testExample411() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo**bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo**bar</em></p>
        """#####
        )
    }
    // 
    // 
    // The same condition ensures that the following
    // cases are all strong emphasis nested inside
    // emphasis, even when the interior spaces are
    // omitted:
    // 
    // 
    // 
    //     
    // spec.txt lines 6892-6896
    func testExample412() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ***foo** bar*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><strong>foo</strong> bar</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6899-6903
    func testExample413() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo **bar***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <strong>bar</strong></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6906-6910
    func testExample414() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo**bar***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo<strong>bar</strong></em></p>
        """#####
        )
    }
    // 
    // 
    // When the lengths of the interior closing and opening
    // delimiter runs are *both* multiples of 3, though,
    // they can match to create emphasis:
    // 
    // 
    //     
    // spec.txt lines 6917-6921
    func testExample415() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo***bar***baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<em><strong>bar</strong></em>baz</p>
        """#####
        )
    }
    // 
    // 
    //     
    // spec.txt lines 6923-6927
    func testExample416() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo******bar*********baz
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>
        """#####
        )
    }
    // 
    // 
    // Indefinite levels of nesting are possible:
    // 
    // 
    //     
    // spec.txt lines 6932-6936
    func testExample417() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo **bar *baz* bim** bop*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6939-6943
    func testExample418() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo [*bar*](/url)*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <a href="/url"><em>bar</em></a></em></p>
        """#####
        )
    }
    // 
    // 
    // There can be no empty emphasis or strong emphasis:
    // 
    // 
    //     
    // spec.txt lines 6948-6952
    func testExample419() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ** is not an empty emphasis
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>** is not an empty emphasis</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6955-6959
    func testExample420() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **** is not an empty strong emphasis
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**** is not an empty strong emphasis</p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 10:
    // 
    // Any nonempty sequence of inline elements can be the contents of an
    // strongly emphasized span.
    // 
    // 
    //     
    // spec.txt lines 6968-6972
    func testExample421() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo [bar](/url)**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <a href="/url">bar</a></strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6975-6981
    func testExample422() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo
        bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo
        bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // In particular, emphasis and strong emphasis can be nested
    // inside strong emphasis:
    // 
    // 
    //     
    // spec.txt lines 6987-6991
    func testExample423() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo _bar_ baz__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <em>bar</em> baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 6994-6998
    func testExample424() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo __bar__ baz__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <strong>bar</strong> baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7001-7005
    func testExample425() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ____foo__ bar__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong><strong>foo</strong> bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7008-7012
    func testExample426() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo **bar****
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <strong>bar</strong></strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7015-7019
    func testExample427() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo *bar* baz**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <em>bar</em> baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7022-7026
    func testExample428() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo*bar*baz**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo<em>bar</em>baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7029-7033
    func testExample429() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ***foo* bar**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong><em>foo</em> bar</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7036-7040
    func testExample430() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo *bar***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <em>bar</em></strong></p>
        """#####
        )
    }
    // 
    // 
    // Indefinite levels of nesting are possible:
    // 
    // 
    //     
    // spec.txt lines 7045-7051
    func testExample431() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo *bar **baz**
        bim* bop**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <em>bar <strong>baz</strong>
        bim</em> bop</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7054-7058
    func testExample432() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo [*bar*](/url)**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo <a href="/url"><em>bar</em></a></strong></p>
        """#####
        )
    }
    // 
    // 
    // There can be no empty emphasis or strong emphasis:
    // 
    // 
    //     
    // spec.txt lines 7063-7067
    func testExample433() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __ is not an empty emphasis
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__ is not an empty emphasis</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7070-7074
    func testExample434() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ____ is not an empty strong emphasis
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>____ is not an empty strong emphasis</p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 11:
    // 
    // 
    //     
    // spec.txt lines 7080-7084
    func testExample435() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo ***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo ***</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7087-7091
    func testExample436() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo *\**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <em>*</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7094-7098
    func testExample437() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo *_*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <em>_</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7101-7105
    func testExample438() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo *****
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo *****</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7108-7112
    func testExample439() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo **\***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <strong>*</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7115-7119
    func testExample440() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo **_**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <strong>_</strong></p>
        """#####
        )
    }
    // 
    // 
    // Note that when delimiters do not match evenly, Rule 11 determines
    // that the excess literal `*` characters will appear outside of the
    // emphasis, rather than inside it:
    // 
    // 
    //     
    // spec.txt lines 7126-7130
    func testExample441() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*<em>foo</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7133-7137
    func testExample442() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo</em>*</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7140-7144
    func testExample443() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ***foo**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*<strong>foo</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7147-7151
    func testExample444() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ****foo*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>***<em>foo</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7154-7158
    func testExample445() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo</strong>*</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7161-7165
    func testExample446() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo****
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo</em>***</p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 12:
    // 
    // 
    //     
    // spec.txt lines 7171-7175
    func testExample447() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo ___
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo ___</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7178-7182
    func testExample448() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo _\__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <em>_</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7185-7189
    func testExample449() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo _*_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <em>*</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7192-7196
    func testExample450() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo _____
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo _____</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7199-7203
    func testExample451() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo __\___
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <strong>_</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7206-7210
    func testExample452() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        foo __*__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>foo <strong>*</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7213-7217
    func testExample453() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_<em>foo</em></p>
        """#####
        )
    }
    // 
    // 
    // Note that when delimiters do not match evenly, Rule 12 determines
    // that the excess literal `_` characters will appear outside of the
    // emphasis, rather than inside it:
    // 
    // 
    //     
    // spec.txt lines 7224-7228
    func testExample454() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo</em>_</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7231-7235
    func testExample455() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ___foo__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_<strong>foo</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7238-7242
    func testExample456() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ____foo_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>___<em>foo</em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7245-7249
    func testExample457() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo___
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo</strong>_</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7252-7256
    func testExample458() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo____
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo</em>___</p>
        """#####
        )
    }
    // 
    // 
    // Rule 13 implies that if you want emphasis nested directly inside
    // emphasis, you must use different delimiters:
    // 
    // 
    //     
    // spec.txt lines 7262-7266
    func testExample459() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7269-7273
    func testExample460() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *_foo_*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><em>foo</em></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7276-7280
    func testExample461() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __foo__
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong>foo</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7283-7287
    func testExample462() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _*foo*_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><em>foo</em></em></p>
        """#####
        )
    }
    // 
    // 
    // However, strong emphasis within strong emphasis is possible without
    // switching delimiters:
    // 
    // 
    //     
    // spec.txt lines 7293-7297
    func testExample463() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ****foo****
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong><strong>foo</strong></strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7300-7304
    func testExample464() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ____foo____
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong><strong>foo</strong></strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    // Rule 13 can be applied to arbitrarily long sequences of
    // delimiters:
    // 
    // 
    //     
    // spec.txt lines 7311-7315
    func testExample465() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ******foo******
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><strong><strong><strong>foo</strong></strong></strong></p>
        """#####
        )
    }
    // 
    // 
    // Rule 14:
    // 
    // 
    //     
    // spec.txt lines 7320-7324
    func testExample466() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        ***foo***
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><strong>foo</strong></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7327-7331
    func testExample467() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _____foo_____
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em><strong><strong>foo</strong></strong></em></p>
        """#####
        )
    }
    // 
    // 
    // Rule 15:
    // 
    // 
    //     
    // spec.txt lines 7336-7340
    func testExample468() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo _bar* baz_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo _bar</em> baz_</p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7343-7347
    func testExample469() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo __bar *baz bim__ bam*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>foo <strong>bar *baz bim</strong> bam</em></p>
        """#####
        )
    }
    // 
    // 
    // Rule 16:
    // 
    // 
    //     
    // spec.txt lines 7352-7356
    func testExample470() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **foo **bar baz**
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**foo <strong>bar baz</strong></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7359-7363
    func testExample471() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *foo *bar baz*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*foo <em>bar baz</em></p>
        """#####
        )
    }
    // 
    // 
    // Rule 17:
    // 
    // 
    //     
    // spec.txt lines 7368-7372
    func testExample472() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *[bar*](/url)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*<a href="/url">bar*</a></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7375-7379
    func testExample473() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _foo [bar_](/url)
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>_foo <a href="/url">bar_</a></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7382-7386
    func testExample474() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *<img src="foo" title="*"/>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>*<img src="foo" title="*"/></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7389-7393
    func testExample475() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **<a href="**">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**<a href="**"></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7396-7400
    func testExample476() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __<a href="__">
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__<a href="__"></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7403-7407
    func testExample477() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        *a `*`*
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>a <code>*</code></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7410-7414
    func testExample478() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        _a `_`_
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p><em>a <code>_</code></em></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7417-7421
    func testExample479() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        **a<http://foo.bar/?q=**>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>
        """#####
        )
    }
    // 
    // 
    // 
    //     
    // spec.txt lines 7424-7428
    func testExample480() {
        let newlineChar = "\n"
        var markdownTest =
        #####"""
        __a<http://foo.bar/?q=__>
        """#####
        markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
        let html = MarkdownParser().html(from: markdownTest).replacingOccurrences(of: ">\n<", with: "><")
        XCTAssertEqual(html,#####"""
        <p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>
        """#####
        )
    }
}

extension EmphasisAndStrongEmphasisTests {
    static var allTests: Linux.TestList<EmphasisAndStrongEmphasisTests> {
        return [
        ("testExample350", testExample350),
        ("testExample351", testExample351),
        ("testExample352", testExample352),
        ("testExample353", testExample353),
        ("testExample354", testExample354),
        ("testExample355", testExample355),
        ("testExample356", testExample356),
        ("testExample357", testExample357),
        ("testExample358", testExample358),
        ("testExample359", testExample359),
        ("testExample360", testExample360),
        ("testExample361", testExample361),
        ("testExample362", testExample362),
        ("testExample363", testExample363),
        ("testExample364", testExample364),
        ("testExample365", testExample365),
        ("testExample366", testExample366),
        ("testExample367", testExample367),
        ("testExample368", testExample368),
        ("testExample369", testExample369),
        ("testExample370", testExample370),
        ("testExample371", testExample371),
        ("testExample372", testExample372),
        ("testExample373", testExample373),
        ("testExample374", testExample374),
        ("testExample375", testExample375),
        ("testExample376", testExample376),
        ("testExample377", testExample377),
        ("testExample378", testExample378),
        ("testExample379", testExample379),
        ("testExample380", testExample380),
        ("testExample381", testExample381),
        ("testExample382", testExample382),
        ("testExample383", testExample383),
        ("testExample384", testExample384),
        ("testExample385", testExample385),
        ("testExample386", testExample386),
        ("testExample387", testExample387),
        ("testExample388", testExample388),
        ("testExample389", testExample389),
        ("testExample390", testExample390),
        ("testExample391", testExample391),
        ("testExample392", testExample392),
        ("testExample393", testExample393),
        ("testExample394", testExample394),
        ("testExample395", testExample395),
        ("testExample396", testExample396),
        ("testExample397", testExample397),
        ("testExample398", testExample398),
        ("testExample399", testExample399),
        ("testExample400", testExample400),
        ("testExample401", testExample401),
        ("testExample402", testExample402),
        ("testExample403", testExample403),
        ("testExample404", testExample404),
        ("testExample405", testExample405),
        ("testExample406", testExample406),
        ("testExample407", testExample407),
        ("testExample408", testExample408),
        ("testExample409", testExample409),
        ("testExample410", testExample410),
        ("testExample411", testExample411),
        ("testExample412", testExample412),
        ("testExample413", testExample413),
        ("testExample414", testExample414),
        ("testExample415", testExample415),
        ("testExample416", testExample416),
        ("testExample417", testExample417),
        ("testExample418", testExample418),
        ("testExample419", testExample419),
        ("testExample420", testExample420),
        ("testExample421", testExample421),
        ("testExample422", testExample422),
        ("testExample423", testExample423),
        ("testExample424", testExample424),
        ("testExample425", testExample425),
        ("testExample426", testExample426),
        ("testExample427", testExample427),
        ("testExample428", testExample428),
        ("testExample429", testExample429),
        ("testExample430", testExample430),
        ("testExample431", testExample431),
        ("testExample432", testExample432),
        ("testExample433", testExample433),
        ("testExample434", testExample434),
        ("testExample435", testExample435),
        ("testExample436", testExample436),
        ("testExample437", testExample437),
        ("testExample438", testExample438),
        ("testExample439", testExample439),
        ("testExample440", testExample440),
        ("testExample441", testExample441),
        ("testExample442", testExample442),
        ("testExample443", testExample443),
        ("testExample444", testExample444),
        ("testExample445", testExample445),
        ("testExample446", testExample446),
        ("testExample447", testExample447),
        ("testExample448", testExample448),
        ("testExample449", testExample449),
        ("testExample450", testExample450),
        ("testExample451", testExample451),
        ("testExample452", testExample452),
        ("testExample453", testExample453),
        ("testExample454", testExample454),
        ("testExample455", testExample455),
        ("testExample456", testExample456),
        ("testExample457", testExample457),
        ("testExample458", testExample458),
        ("testExample459", testExample459),
        ("testExample460", testExample460),
        ("testExample461", testExample461),
        ("testExample462", testExample462),
        ("testExample463", testExample463),
        ("testExample464", testExample464),
        ("testExample465", testExample465),
        ("testExample466", testExample466),
        ("testExample467", testExample467),
        ("testExample468", testExample468),
        ("testExample469", testExample469),
        ("testExample470", testExample470),
        ("testExample471", testExample471),
        ("testExample472", testExample472),
        ("testExample473", testExample473),
        ("testExample474", testExample474),
        ("testExample475", testExample475),
        ("testExample476", testExample476),
        ("testExample477", testExample477),
        ("testExample478", testExample478),
        ("testExample479", testExample479),
        ("testExample480", testExample480)
        ]
    }
}