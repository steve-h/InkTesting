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

final class EmphasisAndStrongEmphasisTests: XCTestCase {

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
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6292-6296
    func testExample350() {
        let markdownTest =
        #####"""
        *foo bar*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the opening `*` is followed by
    // whitespace, and hence not part of a [left-flanking delimiter run]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6302-6306
    func testExample351() {
        let markdownTest =
        #####"""
        a * foo bar*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>a * foo bar*</p>
        let normalizedCM = #####"""
        <p>a * foo bar*</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the opening `*` is preceded
    // by an alphanumeric and followed by punctuation, and hence
    // not part of a [left-flanking delimiter run]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6313-6317
    func testExample352() {
        let markdownTest =
        #####"""
        a*"foo"*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>a*&quot;foo&quot;*</p>
        let normalizedCM = #####"""
        <p>a*&quot;foo&quot;*</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Unicode nonbreaking spaces count as whitespace, too:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6322-6326
    func testExample353() {
        let markdownTest =
        #####"""
        * a *
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>* a *</p>
        let normalizedCM = #####"""
        <ul><li>a *</li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword emphasis with `*` is permitted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6331-6335
    func testExample354() {
        let markdownTest =
        #####"""
        foo*bar*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<em>bar</em></p>
        let normalizedCM = #####"""
        <p>foo<em>bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6338-6342
    func testExample355() {
        let markdownTest =
        #####"""
        5*6*78
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>5<em>6</em>78</p>
        let normalizedCM = #####"""
        <p>5<em>6</em>78</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 2:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6347-6351
    func testExample356() {
        let markdownTest =
        #####"""
        _foo bar_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the opening `_` is followed by
    // whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6357-6361
    func testExample357() {
        let markdownTest =
        #####"""
        _ foo bar_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_ foo bar_</p>
        let normalizedCM = #####"""
        <p>_ foo bar_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the opening `_` is preceded
    // by an alphanumeric and followed by punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6367-6371
    func testExample358() {
        let markdownTest =
        #####"""
        a_"foo"_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>a_&quot;foo&quot;_</p>
        let normalizedCM = #####"""
        <p>a_&quot;foo&quot;_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Emphasis with `_` is not allowed inside words:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6376-6380
    func testExample359() {
        let markdownTest =
        #####"""
        foo_bar_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo_bar_</p>
        let normalizedCM = #####"""
        <p>foo_bar_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6383-6387
    func testExample360() {
        let markdownTest =
        #####"""
        5_6_78
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>5_6_78</p>
        let normalizedCM = #####"""
        <p>5_6_78</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6390-6394
    func testExample361() {
        let markdownTest =
        #####"""
        пристаням_стремятся_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>пристаням_стремятся_</p>
        let normalizedCM = #####"""
        <p>пристаням_стремятся_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here `_` does not generate emphasis, because the first delimiter run
    // is right-flanking and the second left-flanking:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6400-6404
    func testExample362() {
        let markdownTest =
        #####"""
        aa_"bb"_cc
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>aa_&quot;bb&quot;_cc</p>
        let normalizedCM = #####"""
        <p>aa_&quot;bb&quot;_cc</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is emphasis, even though the opening delimiter is
    // both left- and right-flanking, because it is preceded by
    // punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6411-6415
    func testExample363() {
        let markdownTest =
        #####"""
        foo-_(bar)_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo-<em>(bar)</em></p>
        let normalizedCM = #####"""
        <p>foo-<em>(bar)</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 3:
    // 
    // This is not emphasis, because the closing delimiter does
    // not match the opening delimiter:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6423-6427
    func testExample364() {
        let markdownTest =
        #####"""
        _foo*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_foo*</p>
        let normalizedCM = #####"""
        <p>_foo*</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the closing `*` is preceded by
    // whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6433-6437
    func testExample365() {
        let markdownTest =
        #####"""
        *foo bar *
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*foo bar *</p>
        let normalizedCM = #####"""
        <p>*foo bar *</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A newline also counts as whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6442-6448
    func testExample366() {
        let markdownTest =
        #####"""
        *foo bar
        *\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*foo bar
      //*</p>
        let normalizedCM = #####"""
        <p>*foo bar *</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the second `*` is
    // preceded by punctuation and followed by an alphanumeric
    // (hence it is not part of a [right-flanking delimiter run]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6455-6459
    func testExample367() {
        let markdownTest =
        #####"""
        *(*foo)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*(*foo)</p>
        let normalizedCM = #####"""
        <p>*(*foo)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The point of this restriction is more easily appreciated
    // with this example:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6465-6469
    func testExample368() {
        let markdownTest =
        #####"""
        *(*foo*)*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>(<em>foo</em>)</em></p>
        let normalizedCM = #####"""
        <p><em>(<em>foo</em>)</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword emphasis with `*` is allowed:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6474-6478
    func testExample369() {
        let markdownTest =
        #####"""
        *foo*bar
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo</em>bar</p>
        let normalizedCM = #####"""
        <p><em>foo</em>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 4:
    // 
    // This is not emphasis, because the closing `_` is preceded by
    // whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6487-6491
    func testExample370() {
        let markdownTest =
        #####"""
        _foo bar _
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_foo bar _</p>
        let normalizedCM = #####"""
        <p>_foo bar _</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not emphasis, because the second `_` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6497-6501
    func testExample371() {
        let markdownTest =
        #####"""
        _(_foo)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_(_foo)</p>
        let normalizedCM = #####"""
        <p>_(_foo)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is emphasis within emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6506-6510
    func testExample372() {
        let markdownTest =
        #####"""
        _(_foo_)_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>(<em>foo</em>)</em></p>
        let normalizedCM = #####"""
        <p><em>(<em>foo</em>)</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword emphasis is disallowed for `_`:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6515-6519
    func testExample373() {
        let markdownTest =
        #####"""
        _foo_bar
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_foo_bar</p>
        let normalizedCM = #####"""
        <p>_foo_bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6522-6526
    func testExample374() {
        let markdownTest =
        #####"""
        _пристаням_стремятся
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_пристаням_стремятся</p>
        let normalizedCM = #####"""
        <p>_пристаням_стремятся</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6529-6533
    func testExample375() {
        let markdownTest =
        #####"""
        _foo_bar_baz_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo_bar_baz</em></p>
        let normalizedCM = #####"""
        <p><em>foo_bar_baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is emphasis, even though the closing delimiter is
    // both left- and right-flanking, because it is followed by
    // punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6540-6544
    func testExample376() {
        let markdownTest =
        #####"""
        _(bar)_.
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>(bar)</em>.</p>
        let normalizedCM = #####"""
        <p><em>(bar)</em>.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 5:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6549-6553
    func testExample377() {
        let markdownTest =
        #####"""
        **foo bar**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo bar</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not strong emphasis, because the opening delimiter is
    // followed by whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6559-6563
    func testExample378() {
        let markdownTest =
        #####"""
        ** foo bar**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>** foo bar**</p>
        let normalizedCM = #####"""
        <p>** foo bar**</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not strong emphasis, because the opening `**` is preceded
    // by an alphanumeric and followed by punctuation, and hence
    // not part of a [left-flanking delimiter run]:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6570-6574
    func testExample379() {
        let markdownTest =
        #####"""
        a**"foo"**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>a**&quot;foo&quot;**</p>
        let normalizedCM = #####"""
        <p>a**&quot;foo&quot;**</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword strong emphasis with `**` is permitted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6579-6583
    func testExample380() {
        let markdownTest =
        #####"""
        foo**bar**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<strong>bar</strong></p>
        let normalizedCM = #####"""
        <p>foo<strong>bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 6:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6588-6592
    func testExample381() {
        let markdownTest =
        #####"""
        __foo bar__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo bar</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not strong emphasis, because the opening delimiter is
    // followed by whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6598-6602
    func testExample382() {
        let markdownTest =
        #####"""
        __ foo bar__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__ foo bar__</p>
        let normalizedCM = #####"""
        <p>__ foo bar__</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // A newline counts as whitespace:
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6606-6612
    func testExample383() {
        let markdownTest =
        #####"""
        __
        foo bar__\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__
      //foo bar__</p>
        let normalizedCM = #####"""
        <p>__ foo bar__</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not strong emphasis, because the opening `__` is preceded
    // by an alphanumeric and followed by punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6618-6622
    func testExample384() {
        let markdownTest =
        #####"""
        a__"foo"__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>a__&quot;foo&quot;__</p>
        let normalizedCM = #####"""
        <p>a__&quot;foo&quot;__</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword strong emphasis is forbidden with `__`:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6627-6631
    func testExample385() {
        let markdownTest =
        #####"""
        foo__bar__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo__bar__</p>
        let normalizedCM = #####"""
        <p>foo__bar__</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6634-6638
    func testExample386() {
        let markdownTest =
        #####"""
        5__6__78
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>5__6__78</p>
        let normalizedCM = #####"""
        <p>5__6__78</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6641-6645
    func testExample387() {
        let markdownTest =
        #####"""
        пристаням__стремятся__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>пристаням__стремятся__</p>
        let normalizedCM = #####"""
        <p>пристаням__стремятся__</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6648-6652
    func testExample388() {
        let markdownTest =
        #####"""
        __foo, __bar__, baz__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo, <strong>bar</strong>, baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo, <strong>bar</strong>, baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is strong emphasis, even though the opening delimiter is
    // both left- and right-flanking, because it is preceded by
    // punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6659-6663
    func testExample389() {
        let markdownTest =
        #####"""
        foo-__(bar)__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo-<strong>(bar)</strong></p>
        let normalizedCM = #####"""
        <p>foo-<strong>(bar)</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 7:
    // 
    // This is not strong emphasis, because the closing delimiter is preceded
    // by whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6672-6676
    func testExample390() {
        let markdownTest =
        #####"""
        **foo bar **
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**foo bar **</p>
        let normalizedCM = #####"""
        <p>**foo bar **</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // (Nor can it be interpreted as an emphasized `*foo bar *`, because of
    // Rule 11.)
    // 
    // This is not strong emphasis, because the second `**` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6685-6689
    func testExample391() {
        let markdownTest =
        #####"""
        **(**foo)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**(**foo)</p>
        let normalizedCM = #####"""
        <p>**(**foo)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The point of this restriction is more easily appreciated
    // with these examples:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6695-6699
    func testExample392() {
        let markdownTest =
        #####"""
        *(**foo**)*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>(<strong>foo</strong>)</em></p>
        let normalizedCM = #####"""
        <p><em>(<strong>foo</strong>)</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6702-6708
    func testExample393() {
        let markdownTest =
        #####"""
        **Gomphocarpus (*Gomphocarpus physocarpus*, syn.
        *Asclepias physocarpa*)**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
      //<em>Asclepias physocarpa</em>)</strong></p>
        let normalizedCM = #####"""
        <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn. <em>Asclepias physocarpa</em>)</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6711-6715
    func testExample394() {
        let markdownTest =
        #####"""
        **foo "*bar*" foo**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6720-6724
    func testExample395() {
        let markdownTest =
        #####"""
        **foo**bar
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo</strong>bar</p>
        let normalizedCM = #####"""
        <p><strong>foo</strong>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 8:
    // 
    // This is not strong emphasis, because the closing delimiter is
    // preceded by whitespace:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6732-6736
    func testExample396() {
        let markdownTest =
        #####"""
        __foo bar __
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__foo bar __</p>
        let normalizedCM = #####"""
        <p>__foo bar __</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is not strong emphasis, because the second `__` is
    // preceded by punctuation and followed by an alphanumeric:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6742-6746
    func testExample397() {
        let markdownTest =
        #####"""
        __(__foo)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__(__foo)</p>
        let normalizedCM = #####"""
        <p>__(__foo)</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The point of this restriction is more easily appreciated
    // with this example:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6752-6756
    func testExample398() {
        let markdownTest =
        #####"""
        _(__foo__)_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>(<strong>foo</strong>)</em></p>
        let normalizedCM = #####"""
        <p><em>(<strong>foo</strong>)</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Intraword strong emphasis is forbidden with `__`:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6761-6765
    func testExample399() {
        let markdownTest =
        #####"""
        __foo__bar
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__foo__bar</p>
        let normalizedCM = #####"""
        <p>__foo__bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6768-6772
    func testExample400() {
        let markdownTest =
        #####"""
        __пристаням__стремятся
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__пристаням__стремятся</p>
        let normalizedCM = #####"""
        <p>__пристаням__стремятся</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6775-6779
    func testExample401() {
        let markdownTest =
        #####"""
        __foo__bar__baz__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo__bar__baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo__bar__baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // This is strong emphasis, even though the closing delimiter is
    // both left- and right-flanking, because it is followed by
    // punctuation:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6786-6790
    func testExample402() {
        let markdownTest =
        #####"""
        __(bar)__.
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>(bar)</strong>.</p>
        let normalizedCM = #####"""
        <p><strong>(bar)</strong>.</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 9:
    // 
    // Any nonempty sequence of inline elements can be the contents of an
    // emphasized span.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6798-6802
    func testExample403() {
        let markdownTest =
        #####"""
        *foo [bar](/url)*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <a href="/url">bar</a></em></p>
        let normalizedCM = #####"""
        <p><em>foo <a href="/url">bar</a></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6805-6811
    func testExample404() {
        let markdownTest =
        #####"""
        *foo
        bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo
      //bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In particular, emphasis and strong emphasis can be nested
    // inside emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6817-6821
    func testExample405() {
        let markdownTest =
        #####"""
        _foo __bar__ baz_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <strong>bar</strong> baz</em></p>
        let normalizedCM = #####"""
        <p><em>foo <strong>bar</strong> baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6824-6828
    func testExample406() {
        let markdownTest =
        #####"""
        _foo _bar_ baz_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <em>bar</em> baz</em></p>
        let normalizedCM = #####"""
        <p><em>foo <em>bar</em> baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6831-6835
    func testExample407() {
        let markdownTest =
        #####"""
        __foo_ bar_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><em>foo</em> bar</em></p>
        let normalizedCM = #####"""
        <p><em><em>foo</em> bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6838-6842
    func testExample408() {
        let markdownTest =
        #####"""
        *foo *bar**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <em>bar</em></em></p>
        let normalizedCM = #####"""
        <p><em>foo <em>bar</em></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6845-6849
    func testExample409() {
        let markdownTest =
        #####"""
        *foo **bar** baz*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <strong>bar</strong> baz</em></p>
        let normalizedCM = #####"""
        <p><em>foo <strong>bar</strong> baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6851-6855
    func testExample410() {
        let markdownTest =
        #####"""
        *foo**bar**baz*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo<strong>bar</strong>baz</em></p>
        let normalizedCM = #####"""
        <p><em>foo<strong>bar</strong>baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that in the preceding case, the interpretation
    // 
    // ``` markdown
    // <p><em>foo</em><em>bar<em></em>baz</em></p>
    // ```
    // 
    // is precluded by the condition that a delimiter that
    // can both open and close (like the `*` after `foo`)
    // cannot form emphasis if the sum of the lengths of
    // the delimiter runs containing the opening and
    // closing delimiters is a multiple of 3 unless
    // both lengths are multiples of 3.
    // 
    // For the same reason, we don't get two consecutive
    // emphasis sections in this example:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6875-6879
    func testExample411() {
        let markdownTest =
        #####"""
        *foo**bar*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo**bar</em></p>
        let normalizedCM = #####"""
        <p><em>foo**bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The same condition ensures that the following
    // cases are all strong emphasis nested inside
    // emphasis, even when the interior spaces are
    // omitted:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6888-6892
    func testExample412() {
        let markdownTest =
        #####"""
        ***foo** bar*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><strong>foo</strong> bar</em></p>
        let normalizedCM = #####"""
        <p><em><strong>foo</strong> bar</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6895-6899
    func testExample413() {
        let markdownTest =
        #####"""
        *foo **bar***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <strong>bar</strong></em></p>
        let normalizedCM = #####"""
        <p><em>foo <strong>bar</strong></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6902-6906
    func testExample414() {
        let markdownTest =
        #####"""
        *foo**bar***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo<strong>bar</strong></em></p>
        let normalizedCM = #####"""
        <p><em>foo<strong>bar</strong></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // When the lengths of the interior closing and opening
    // delimiter runs are *both* multiples of 3, though,
    // they can match to create emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6913-6917
    func testExample415() {
        let markdownTest =
        #####"""
        foo***bar***baz
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<em><strong>bar</strong></em>baz</p>
        let normalizedCM = #####"""
        <p>foo***bar***baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6919-6923
    func testExample416() {
        let markdownTest =
        #####"""
        foo******bar*********baz
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>
        let normalizedCM = #####"""
        <p>foo******bar*********baz</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Indefinite levels of nesting are possible:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6928-6932
    func testExample417() {
        let markdownTest =
        #####"""
        *foo **bar *baz* bim** bop*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>
        let normalizedCM = #####"""
        <p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6935-6939
    func testExample418() {
        let markdownTest =
        #####"""
        *foo [*bar*](/url)*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <a href="/url"><em>bar</em></a></em></p>
        let normalizedCM = #####"""
        <p><em>foo <a href="/url"><em>bar</em></a></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // There can be no empty emphasis or strong emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6944-6948
    func testExample419() {
        let markdownTest =
        #####"""
        ** is not an empty emphasis
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>** is not an empty emphasis</p>
        let normalizedCM = #####"""
        <p>** is not an empty emphasis</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6951-6955
    func testExample420() {
        let markdownTest =
        #####"""
        **** is not an empty strong emphasis
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**** is not an empty strong emphasis</p>
        let normalizedCM = #####"""
        <p>**** is not an empty strong emphasis</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 10:
    // 
    // Any nonempty sequence of inline elements can be the contents of an
    // strongly emphasized span.
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6964-6968
    func testExample421() {
        let markdownTest =
        #####"""
        **foo [bar](/url)**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <a href="/url">bar</a></strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <a href="/url">bar</a></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6971-6977
    func testExample422() {
        let markdownTest =
        #####"""
        **foo
        bar**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo
      //bar</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // In particular, emphasis and strong emphasis can be nested
    // inside strong emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6983-6987
    func testExample423() {
        let markdownTest =
        #####"""
        __foo _bar_ baz__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <em>bar</em> baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <em>bar</em> baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6990-6994
    func testExample424() {
        let markdownTest =
        #####"""
        __foo __bar__ baz__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <strong>bar</strong> baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <strong>bar</strong> baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 6997-7001
    func testExample425() {
        let markdownTest =
        #####"""
        ____foo__ bar__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong><strong>foo</strong> bar</strong></p>
        let normalizedCM = #####"""
        <p><strong><strong>foo</strong> bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7004-7008
    func testExample426() {
        let markdownTest =
        #####"""
        **foo **bar****
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <strong>bar</strong></strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <strong>bar</strong></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7011-7015
    func testExample427() {
        let markdownTest =
        #####"""
        **foo *bar* baz**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <em>bar</em> baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <em>bar</em> baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7018-7022
    func testExample428() {
        let markdownTest =
        #####"""
        **foo*bar*baz**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo<em>bar</em>baz</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo<em>bar</em>baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7025-7029
    func testExample429() {
        let markdownTest =
        #####"""
        ***foo* bar**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong><em>foo</em> bar</strong></p>
        let normalizedCM = #####"""
        <p><strong><em>foo</em> bar</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7032-7036
    func testExample430() {
        let markdownTest =
        #####"""
        **foo *bar***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <em>bar</em></strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <em>bar</em></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Indefinite levels of nesting are possible:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7041-7047
    func testExample431() {
        let markdownTest =
        #####"""
        **foo *bar **baz**
        bim* bop**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <em>bar <strong>baz</strong>
      //bim</em> bop</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <em>bar <strong>baz</strong> bim</em> bop</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7050-7054
    func testExample432() {
        let markdownTest =
        #####"""
        **foo [*bar*](/url)**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <a href="/url"><em>bar</em></a></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // There can be no empty emphasis or strong emphasis:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7059-7063
    func testExample433() {
        let markdownTest =
        #####"""
        __ is not an empty emphasis
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__ is not an empty emphasis</p>
        let normalizedCM = #####"""
        <p>__ is not an empty emphasis</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7066-7070
    func testExample434() {
        let markdownTest =
        #####"""
        ____ is not an empty strong emphasis
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>____ is not an empty strong emphasis</p>
        let normalizedCM = #####"""
        <p>____ is not an empty strong emphasis</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 11:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7076-7080
    func testExample435() {
        let markdownTest =
        #####"""
        foo ***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo ***</p>
        let normalizedCM = #####"""
        <p>foo ***</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7083-7087
    func testExample436() {
        let markdownTest =
        #####"""
        foo *\**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <em>*</em></p>
        let normalizedCM = #####"""
        <p>foo <em>*</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7090-7094
    func testExample437() {
        let markdownTest =
        #####"""
        foo *_*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <em>_</em></p>
        let normalizedCM = #####"""
        <p>foo <em>_</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7097-7101
    func testExample438() {
        let markdownTest =
        #####"""
        foo *****
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo *****</p>
        let normalizedCM = #####"""
        <p>foo *****</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7104-7108
    func testExample439() {
        let markdownTest =
        #####"""
        foo **\***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <strong>*</strong></p>
        let normalizedCM = #####"""
        <p>foo <strong>*</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7111-7115
    func testExample440() {
        let markdownTest =
        #####"""
        foo **_**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <strong>_</strong></p>
        let normalizedCM = #####"""
        <p>foo <strong>_</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that when delimiters do not match evenly, Rule 11 determines
    // that the excess literal `*` characters will appear outside of the
    // emphasis, rather than inside it:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7122-7126
    func testExample441() {
        let markdownTest =
        #####"""
        **foo*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<em>foo</em></p>
        let normalizedCM = #####"""
        <p>*<em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7129-7133
    func testExample442() {
        let markdownTest =
        #####"""
        *foo**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo</em>*</p>
        let normalizedCM = #####"""
        <p><em>foo</em>*</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7136-7140
    func testExample443() {
        let markdownTest =
        #####"""
        ***foo**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<strong>foo</strong></p>
        let normalizedCM = #####"""
        <p>*<strong>foo</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7143-7147
    func testExample444() {
        let markdownTest =
        #####"""
        ****foo*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>***<em>foo</em></p>
        let normalizedCM = #####"""
        <p>***<em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7150-7154
    func testExample445() {
        let markdownTest =
        #####"""
        **foo***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo</strong>*</p>
        let normalizedCM = #####"""
        <p><strong>foo</strong>*</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7157-7161
    func testExample446() {
        let markdownTest =
        #####"""
        *foo****
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo</em>***</p>
        let normalizedCM = #####"""
        <p><em>foo</em>***</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 12:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7167-7171
    func testExample447() {
        let markdownTest =
        #####"""
        foo ___
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo ___</p>
        let normalizedCM = #####"""
        <p>foo ___</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7174-7178
    func testExample448() {
        let markdownTest =
        #####"""
        foo _\__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <em>_</em></p>
        let normalizedCM = #####"""
        <p>foo <em>_</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7181-7185
    func testExample449() {
        let markdownTest =
        #####"""
        foo _*_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <em>*</em></p>
        let normalizedCM = #####"""
        <p>foo <em>*</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7188-7192
    func testExample450() {
        let markdownTest =
        #####"""
        foo _____
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo _____</p>
        let normalizedCM = #####"""
        <p>foo _____</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7195-7199
    func testExample451() {
        let markdownTest =
        #####"""
        foo __\___
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <strong>_</strong></p>
        let normalizedCM = #####"""
        <p>foo <strong>_</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7202-7206
    func testExample452() {
        let markdownTest =
        #####"""
        foo __*__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>foo <strong>*</strong></p>
        let normalizedCM = #####"""
        <p>foo <strong>*</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7209-7213
    func testExample453() {
        let markdownTest =
        #####"""
        __foo_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_<em>foo</em></p>
        let normalizedCM = #####"""
        <p>_<em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Note that when delimiters do not match evenly, Rule 12 determines
    // that the excess literal `_` characters will appear outside of the
    // emphasis, rather than inside it:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7220-7224
    func testExample454() {
        let markdownTest =
        #####"""
        _foo__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo</em>_</p>
        let normalizedCM = #####"""
        <p><em>foo</em>_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7227-7231
    func testExample455() {
        let markdownTest =
        #####"""
        ___foo__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_<strong>foo</strong></p>
        let normalizedCM = #####"""
        <p>_<strong>foo</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7234-7238
    func testExample456() {
        let markdownTest =
        #####"""
        ____foo_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>___<em>foo</em></p>
        let normalizedCM = #####"""
        <p>___<em>foo</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7241-7245
    func testExample457() {
        let markdownTest =
        #####"""
        __foo___
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo</strong>_</p>
        let normalizedCM = #####"""
        <p><strong>foo</strong>_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7248-7252
    func testExample458() {
        let markdownTest =
        #####"""
        _foo____
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo</em>___</p>
        let normalizedCM = #####"""
        <p><em>foo</em>___</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 13 implies that if you want emphasis nested directly inside
    // emphasis, you must use different delimiters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7258-7262
    func testExample459() {
        let markdownTest =
        #####"""
        **foo**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7265-7269
    func testExample460() {
        let markdownTest =
        #####"""
        *_foo_*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><em>foo</em></em></p>
        let normalizedCM = #####"""
        <p><em><em>foo</em></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7272-7276
    func testExample461() {
        let markdownTest =
        #####"""
        __foo__
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong>foo</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7279-7283
    func testExample462() {
        let markdownTest =
        #####"""
        _*foo*_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><em>foo</em></em></p>
        let normalizedCM = #####"""
        <p><em><em>foo</em></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, strong emphasis within strong emphasis is possible without
    // switching delimiters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7289-7293
    func testExample463() {
        let markdownTest =
        #####"""
        ****foo****
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong><strong>foo</strong></strong></p>
        let normalizedCM = #####"""
        <p><strong><strong>foo</strong></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7296-7300
    func testExample464() {
        let markdownTest =
        #####"""
        ____foo____
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong><strong>foo</strong></strong></p>
        let normalizedCM = #####"""
        <p><strong><strong>foo</strong></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 13 can be applied to arbitrarily long sequences of
    // delimiters:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7307-7311
    func testExample465() {
        let markdownTest =
        #####"""
        ******foo******
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><strong><strong><strong>foo</strong></strong></strong></p>
        let normalizedCM = #####"""
        <p><strong><strong><strong>foo</strong></strong></strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 14:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7316-7320
    func testExample466() {
        let markdownTest =
        #####"""
        ***foo***
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><strong>foo</strong></em></p>
        let normalizedCM = #####"""
        <p><em><strong>foo</strong></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7323-7327
    func testExample467() {
        let markdownTest =
        #####"""
        _____foo_____
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em><strong><strong>foo</strong></strong></em></p>
        let normalizedCM = #####"""
        <p><em><strong><strong>foo</strong></strong></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 15:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7332-7336
    func testExample468() {
        let markdownTest =
        #####"""
        *foo _bar* baz_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo _bar</em> baz_</p>
        let normalizedCM = #####"""
        <p><em>foo _bar</em> baz_</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7339-7343
    func testExample469() {
        let markdownTest =
        #####"""
        *foo __bar *baz bim__ bam*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>foo <strong>bar *baz bim</strong> bam</em></p>
        let normalizedCM = #####"""
        <p><em>foo <strong>bar *baz bim</strong> bam</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 16:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7348-7352
    func testExample470() {
        let markdownTest =
        #####"""
        **foo **bar baz**
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**foo <strong>bar baz</strong></p>
        let normalizedCM = #####"""
        <p>**foo <strong>bar baz</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7355-7359
    func testExample471() {
        let markdownTest =
        #####"""
        *foo *bar baz*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*foo <em>bar baz</em></p>
        let normalizedCM = #####"""
        <p>*foo <em>bar baz</em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Rule 17:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7364-7368
    func testExample472() {
        let markdownTest =
        #####"""
        *[bar*](/url)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<a href="/url">bar*</a></p>
        let normalizedCM = #####"""
        <p>*<a href="/url">bar*</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7371-7375
    func testExample473() {
        let markdownTest =
        #####"""
        _foo [bar_](/url)
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>_foo <a href="/url">bar_</a></p>
        let normalizedCM = #####"""
        <p>_foo <a href="/url">bar_</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7378-7382
    func testExample474() {
        let markdownTest =
        #####"""
        *<img src="foo" title="*"/>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>*<img src="foo" title="*"/></p>
        let normalizedCM = #####"""
        <p>*<img src="foo" title="*"/></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7385-7389
    func testExample475() {
        let markdownTest =
        #####"""
        **<a href="**">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**<a href="**"></p>
        let normalizedCM = #####"""
        <p>**<a href="**"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7392-7396
    func testExample476() {
        let markdownTest =
        #####"""
        __<a href="__">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__<a href="__"></p>
        let normalizedCM = #####"""
        <p>__<a href="__"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7399-7403
    func testExample477() {
        let markdownTest =
        #####"""
        *a `*`*
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>a <code>*</code></em></p>
        let normalizedCM = #####"""
        <p><em>a <code>*</code></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7406-7410
    func testExample478() {
        let markdownTest =
        #####"""
        _a `_`_
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p><em>a <code>_</code></em></p>
        let normalizedCM = #####"""
        <p><em>a <code>_</code></em></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7413-7417
    func testExample479() {
        let markdownTest =
        #####"""
        **a<http://foo.bar/?q=**>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>
        let normalizedCM = #####"""
        <p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 7420-7424
    func testExample480() {
        let markdownTest =
        #####"""
        __a<http://foo.bar/?q=__>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>
        let normalizedCM = #####"""
        <p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
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