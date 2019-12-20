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

final class RawHtmlTests: XCTestCase {

    // </div>
    // 
    // ## Raw HTML
    // 
    // Text between `<` and `>` that looks like an HTML tag is parsed as a
    // raw HTML tag and will be rendered in HTML without escaping.
    // Tag and attribute names are not limited to current HTML tags,
    // so custom tags (and even, say, DocBook tags) may be used.
    // 
    // Here is the grammar for tags:
    // 
    // A [tag name](@) consists of an ASCII letter
    // followed by zero or more ASCII letters, digits, or
    // hyphens (`-`).
    // 
    // An [attribute](@) consists of [whitespace],
    // an [attribute name], and an optional
    // [attribute value specification].
    // 
    // An [attribute name](@)
    // consists of an ASCII letter, `_`, or `:`, followed by zero or more ASCII
    // letters, digits, `_`, `.`, `:`, or `-`.  (Note:  This is the XML
    // specification restricted to ASCII.  HTML5 is laxer.)
    // 
    // An [attribute value specification](@)
    // consists of optional [whitespace],
    // a `=` character, optional [whitespace], and an [attribute
    // value].
    // 
    // An [attribute value](@)
    // consists of an [unquoted attribute value],
    // a [single-quoted attribute value], or a [double-quoted attribute value].
    // 
    // An [unquoted attribute value](@)
    // is a nonempty string of characters not
    // including [whitespace], `"`, `'`, `=`, `<`, `>`, or `` ` ``.
    // 
    // A [single-quoted attribute value](@)
    // consists of `'`, zero or more
    // characters not including `'`, and a final `'`.
    // 
    // A [double-quoted attribute value](@)
    // consists of `"`, zero or more
    // characters not including `"`, and a final `"`.
    // 
    // An [open tag](@) consists of a `<` character, a [tag name],
    // zero or more [attributes], optional [whitespace], an optional `/`
    // character, and a `>` character.
    // 
    // A [closing tag](@) consists of the string `</`, a
    // [tag name], optional [whitespace], and the character `>`.
    // 
    // An [HTML comment](@) consists of `<!--` + *text* + `-->`,
    // where *text* does not start with `>` or `->`, does not end with `-`,
    // and does not contain `--`.  (See the
    // [HTML5 spec](http://www.w3.org/TR/html5/syntax.html#comments).)
    // 
    // A [processing instruction](@)
    // consists of the string `<?`, a string
    // of characters not including the string `?>`, and the string
    // `?>`.
    // 
    // A [declaration](@) consists of the
    // string `<!`, a name consisting of one or more uppercase ASCII letters,
    // [whitespace], a string of characters not including the
    // character `>`, and the character `>`.
    // 
    // A [CDATA section](@) consists of
    // the string `<![CDATA[`, a string of characters not including the string
    // `]]>`, and the string `]]>`.
    // 
    // An [HTML tag](@) consists of an [open tag], a [closing tag],
    // an [HTML comment], a [processing instruction], a [declaration],
    // or a [CDATA section].
    // 
    // Here are some simple open tags:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9438-9442
    func testExample632() {
        let markdownTest =
        #####"""
        <a><bab><c2c>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a><bab><c2c></p>
        let normalizedCM = #####"""
        <p><a><bab><c2c></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Empty elements:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9447-9451
    func testExample633() {
        let markdownTest =
        #####"""
        <a/><b2/>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p><a/><b2/></p>
        let normalizedCM = #####"""
        <p><a/><b2/></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // [Whitespace] is allowed:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9456-9462
    func testExample634() {
        let markdownTest =
        #####"""
        <a  /><b2
        data="foo" >\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a  /><b2
      //data="foo" ></p>
        let normalizedCM = #####"""
        <p><a  /><b2
        data="foo" ></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // With attributes:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9467-9473
    func testExample635() {
        let markdownTest =
        #####"""
        <a foo="bar" bam = 'baz <em>"</em>'
        _boolean zoop:33=zoop:33 />\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p><a foo="bar" bam = 'baz <em>"</em>'
      //_boolean zoop:33=zoop:33 /></p>
        let normalizedCM = #####"""
        <p><a foo="bar" bam = 'baz <em>"</em>'
        _boolean zoop:33=zoop:33 /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Custom tag names can be used:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9478-9482
    func testExample636() {
        let markdownTest =
        #####"""
        Foo <responsive-image src="foo.jpg" />
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>Foo <responsive-image src="foo.jpg" /></p>
        let normalizedCM = #####"""
        <p>Foo <responsive-image src="foo.jpg" /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Illegal tag names, not parsed as HTML:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9487-9491
    func testExample637() {
        let markdownTest =
        #####"""
        <33> <__>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;33&gt; &lt;__&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;33&gt; &lt;__&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Illegal attribute names:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9496-9500
    func testExample638() {
        let markdownTest =
        #####"""
        <a h*#ref="hi">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Illegal attribute values:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9505-9509
    func testExample639() {
        let markdownTest =
        #####"""
        <a href="hi'> <a href=hi'>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Illegal [whitespace]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9514-9524
    func testExample640() {
        let markdownTest =
        #####"""
        < a><
        foo><bar/ >
        <foo bar=baz
        bim!bop />\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>&lt; a&gt;&lt;
      //foo&gt;&lt;bar/ &gt;
      //&lt;foo bar=baz
      //bim!bop /&gt;</p>
        let normalizedCM = #####"""
        <p>&lt; a&gt;&lt; foo&gt;&lt;bar/ &gt; <foo bar=baz
        bim!bop /></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Missing [whitespace]:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9529-9533
    func testExample641() {
        let markdownTest =
        #####"""
        <a href='bar'title=title>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;a href='bar'title=title&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;a href='bar'title=title&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Closing tags:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9538-9542
    func testExample642() {
        let markdownTest =
        #####"""
        </a></foo >
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p></a></foo ></p>
        let normalizedCM = #####"""
        <p></a></foo ></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Illegal attributes in closing tag:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9547-9551
    func testExample643() {
        let markdownTest =
        #####"""
        </a href="foo">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;/a href=&quot;foo&quot;&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;/a href=&quot;foo&quot;&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Comments:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9556-9562
    func testExample644() {
        let markdownTest =
        #####"""
        foo <!-- this is a
        comment - with hyphen -->\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo <!-- this is a
      //comment - with hyphen --></p>
        let normalizedCM = #####"""
        <p>foo <!-- this is a
        comment - with hyphen --></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9565-9569
    func testExample645() {
        let markdownTest =
        #####"""
        foo <!-- not a comment -- two hyphens -->
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>
        let normalizedCM = #####"""
        <p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Not comments:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9574-9581
    func testExample646() {
        let markdownTest =
        #####"""
        foo <!--> foo -->
        
        foo <!-- foo--->\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        .replacingOccurrences(of: ">\n<", with: "><")
        
      //<p>foo &lt;!--&gt; foo --&gt;</p>
      //<p>foo &lt;!-- foo---&gt;</p>
        let normalizedCM = #####"""
        <p>foo &lt;!--&gt; foo --&gt;</p><p>foo &lt;!-- foo---&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Processing instructions:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9586-9590
    func testExample647() {
        let markdownTest =
        #####"""
        foo <?php echo $a; ?>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo <?php echo $a; ?></p>
        let normalizedCM = #####"""
        <p>foo <?php echo $a; ?></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Declarations:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9595-9599
    func testExample648() {
        let markdownTest =
        #####"""
        foo <!ELEMENT br EMPTY>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo <!ELEMENT br EMPTY></p>
        let normalizedCM = #####"""
        <p>foo <!ELEMENT br EMPTY></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // CDATA sections:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9604-9608
    func testExample649() {
        let markdownTest =
        #####"""
        foo <![CDATA[>&<]]>
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo <![CDATA[>&<]]></p>
        let normalizedCM = #####"""
        <p>foo <![CDATA[>&<]]></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Entity and numeric character references are preserved in HTML
    // attributes:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9614-9618
    func testExample650() {
        let markdownTest =
        #####"""
        foo <a href="&ouml;">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo <a href="&ouml;"></p>
        let normalizedCM = #####"""
        <p>foo <a href="&ouml;"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Backslash escapes do not work in HTML attributes:
    // 
    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9623-9627
    func testExample651() {
        let markdownTest =
        #####"""
        foo <a href="\*">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>foo <a href="\*"></p>
        let normalizedCM = #####"""
        <p>foo <a href="\*"></p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/github/cmark-gfm/blob/master/test/spec.txt
    // spec.txt lines 9630-9634
    func testExample652() {
        let markdownTest =
        #####"""
        <a href="\"">
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
        
      //<p>&lt;a href=&quot;&quot;&quot;&gt;</p>
        let normalizedCM = #####"""
        <p>&lt;a href=&quot;&quot;&quot;&gt;</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension RawHtmlTests {
    static var allTests: Linux.TestList<RawHtmlTests> {
        return [
        ("testExample632", testExample632),
        ("testExample633", testExample633),
        ("testExample634", testExample634),
        ("testExample635", testExample635),
        ("testExample636", testExample636),
        ("testExample637", testExample637),
        ("testExample638", testExample638),
        ("testExample639", testExample639),
        ("testExample640", testExample640),
        ("testExample641", testExample641),
        ("testExample642", testExample642),
        ("testExample643", testExample643),
        ("testExample644", testExample644),
        ("testExample645", testExample645),
        ("testExample646", testExample646),
        ("testExample647", testExample647),
        ("testExample648", testExample648),
        ("testExample649", testExample649),
        ("testExample650", testExample650),
        ("testExample651", testExample651),
        ("testExample652", testExample652)
        ]
    }
}