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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6573-6577
    func testExample360() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6583-6587
    func testExample361() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6594-6598
    func testExample362() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6603-6607
    func testExample363() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6612-6616
    func testExample364() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6619-6623
    func testExample365() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6628-6632
    func testExample366() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6638-6642
    func testExample367() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6648-6652
    func testExample368() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6657-6661
    func testExample369() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6664-6668
    func testExample370() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6671-6675
    func testExample371() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6681-6685
    func testExample372() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6692-6696
    func testExample373() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6704-6708
    func testExample374() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6714-6718
    func testExample375() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6723-6729
    func testExample376() {
        let markdownTest =
        #####"""
        *foo bar
        *\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6736-6740
    func testExample377() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6746-6750
    func testExample378() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6755-6759
    func testExample379() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6768-6772
    func testExample380() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6778-6782
    func testExample381() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6787-6791
    func testExample382() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6796-6800
    func testExample383() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6803-6807
    func testExample384() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6810-6814
    func testExample385() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6821-6825
    func testExample386() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6830-6834
    func testExample387() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6840-6844
    func testExample388() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6851-6855
    func testExample389() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6860-6864
    func testExample390() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6869-6873
    func testExample391() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6879-6883
    func testExample392() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6887-6893
    func testExample393() {
        let markdownTest =
        #####"""
        __
        foo bar__\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6899-6903
    func testExample394() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6908-6912
    func testExample395() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6915-6919
    func testExample396() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6922-6926
    func testExample397() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6929-6933
    func testExample398() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6940-6944
    func testExample399() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6953-6957
    func testExample400() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6966-6970
    func testExample401() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6976-6980
    func testExample402() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6983-6989
    func testExample403() {
        let markdownTest =
        #####"""
        **Gomphocarpus (*Gomphocarpus physocarpus*, syn.
        *Asclepias physocarpa*)**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
      //<em>Asclepias physocarpa</em>)</strong></p>
        let normalizedCM = #####"""
        <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn. <em>Asclepias physocarpa</em>)</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 6992-6996
    func testExample404() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7001-7005
    func testExample405() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7013-7017
    func testExample406() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7023-7027
    func testExample407() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7033-7037
    func testExample408() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7042-7046
    func testExample409() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7049-7053
    func testExample410() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7056-7060
    func testExample411() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7067-7071
    func testExample412() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7079-7083
    func testExample413() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7086-7092
    func testExample414() {
        let markdownTest =
        #####"""
        *foo
        bar*\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7098-7102
    func testExample415() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7105-7109
    func testExample416() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7112-7116
    func testExample417() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7119-7123
    func testExample418() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7126-7130
    func testExample419() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7132-7136
    func testExample420() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7156-7160
    func testExample421() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7169-7173
    func testExample422() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7176-7180
    func testExample423() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7183-7187
    func testExample424() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7194-7198
    func testExample425() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7200-7204
    func testExample426() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7209-7213
    func testExample427() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7216-7220
    func testExample428() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7225-7229
    func testExample429() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7232-7236
    func testExample430() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7245-7249
    func testExample431() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7252-7258
    func testExample432() {
        let markdownTest =
        #####"""
        **foo
        bar**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7264-7268
    func testExample433() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7271-7275
    func testExample434() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7278-7282
    func testExample435() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7285-7289
    func testExample436() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7292-7296
    func testExample437() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7299-7303
    func testExample438() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7306-7310
    func testExample439() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7313-7317
    func testExample440() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7322-7328
    func testExample441() {
        let markdownTest =
        #####"""
        **foo *bar **baz**
        bim* bop**\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><strong>foo <em>bar <strong>baz</strong>
      //bim</em> bop</strong></p>
        let normalizedCM = #####"""
        <p><strong>foo <em>bar <strong>baz</strong> bim</em> bop</strong></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7331-7335
    func testExample442() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7340-7344
    func testExample443() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7347-7351
    func testExample444() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7357-7361
    func testExample445() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7364-7368
    func testExample446() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7371-7375
    func testExample447() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7378-7382
    func testExample448() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7385-7389
    func testExample449() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7392-7396
    func testExample450() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7403-7407
    func testExample451() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7410-7414
    func testExample452() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7417-7421
    func testExample453() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7424-7428
    func testExample454() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7431-7435
    func testExample455() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7438-7442
    func testExample456() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7448-7452
    func testExample457() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7455-7459
    func testExample458() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7462-7466
    func testExample459() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7469-7473
    func testExample460() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7476-7480
    func testExample461() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7483-7487
    func testExample462() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7490-7494
    func testExample463() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7501-7505
    func testExample464() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7508-7512
    func testExample465() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7515-7519
    func testExample466() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7522-7526
    func testExample467() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7529-7533
    func testExample468() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7539-7543
    func testExample469() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7546-7550
    func testExample470() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7553-7557
    func testExample471() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7560-7564
    func testExample472() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7570-7574
    func testExample473() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7577-7581
    func testExample474() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7588-7592
    func testExample475() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7597-7601
    func testExample476() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7604-7608
    func testExample477() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7613-7617
    func testExample478() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7620-7624
    func testExample479() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7629-7633
    func testExample480() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7636-7640
    func testExample481() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7645-7649
    func testExample482() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7652-7656
    func testExample483() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7659-7663
    func testExample484() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7666-7670
    func testExample485() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7673-7677
    func testExample486() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7680-7684
    func testExample487() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7687-7691
    func testExample488() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7694-7698
    func testExample489() {
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
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 7701-7705
    func testExample490() {
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
        ("testExample480", testExample480),
        ("testExample481", testExample481),
        ("testExample482", testExample482),
        ("testExample483", testExample483),
        ("testExample484", testExample484),
        ("testExample485", testExample485),
        ("testExample486", testExample486),
        ("testExample487", testExample487),
        ("testExample488", testExample488),
        ("testExample489", testExample489),
        ("testExample490", testExample490)
        ]
    }
}