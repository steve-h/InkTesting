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

final class IndentedCodeBlocksTests: XCTestCase {

    // ## Indented code blocks
    // 
    // An [indented code block](@) is composed of one or more
    // [indented chunks] separated by blank lines.
    // An [indented chunk](@) is a sequence of non-blank lines,
    // each indented four or more spaces. The contents of the code block are
    // the literal contents of the lines, including trailing
    // [line endings], minus four spaces of indentation.
    // An indented code block has no [info string].
    // 
    // An indented code block cannot interrupt a paragraph, so there must be
    // a blank line between a paragraph and a following indented code block.
    // (A blank line is not needed, however, between a code block and a following
    // paragraph.)
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1408-1415
    func testExample77() {
        let markdownTest =
        #####"""
            a simple
              indented code block\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>a simple
      //  indented code block
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>a simple
          indented code block
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // If there is any ambiguity between an interpretation of indentation
    // as a code block and as indicating that material belongs to a [list
    // item][list items], the list item interpretation takes precedence:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1422-1433
    func testExample78() {
        let markdownTest =
        #####"""
          - foo
        
            bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ul>
      //<li>
      //<p>foo</p>
      //<p>bar</p>
      //</li>
      //</ul>
        let normalizedCM = #####"""
        <ul><li><p>foo</p><p>bar</p></li></ul>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1436-1449
    func testExample79() {
        let markdownTest =
        #####"""
        1.  foo
        
            - bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<ol>
      //<li>
      //<p>foo</p>
      //<ul>
      //<li>bar</li>
      //</ul>
      //</li>
      //</ol>
        let normalizedCM = #####"""
        <ol><li><p>foo</p><ul><li>bar</li></ul></li></ol>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The contents of a code block are literal text, and do not get parsed
    // as Markdown:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1456-1467
    func testExample80() {
        let markdownTest =
        #####"""
            <a/>
            *hi*
        
            - one\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>&lt;a/&gt;
      //*hi*
      //
      //- one
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>&lt;a/&gt;
        *hi*
        
        - one
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Here we have three chunks separated by blank lines:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1472-1489
    func testExample81() {
        let markdownTest =
        #####"""
            chunk1
        
            chunk2
          
         
         
            chunk3\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>chunk1
      //
      //chunk2
      //
      //
      //
      //chunk3
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>chunk1
        
        chunk2
        
        
        
        chunk3
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Any initial spaces beyond four will be included in the content, even
    // in interior blank lines:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1495-1504
    func testExample82() {
        let markdownTest =
        #####"""
            chunk1
              
              chunk2\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>chunk1
      //  
      //  chunk2
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>chunk1
          
          chunk2
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // An indented code block cannot interrupt a paragraph.  (This
    // allows hanging indents and the like.)
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1510-1517
    func testExample83() {
        let markdownTest =
        #####"""
        Foo
            bar
        \#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<p>Foo
      //bar</p>
        let normalizedCM = #####"""
        <p>Foo bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // However, any non-blank line with fewer than four leading spaces ends
    // the code block immediately.  So a paragraph may occur immediately
    // after indented code:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1524-1531
    func testExample84() {
        let markdownTest =
        #####"""
            foo
        bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>foo
      //</code></pre>
      //<p>bar</p>
        let normalizedCM = #####"""
        <pre><code>foo
        </code></pre><p>bar</p>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // And indented code can occur immediately before and after other kinds of
    // blocks:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1537-1552
    func testExample85() {
        let markdownTest =
        #####"""
        # Heading
            foo
        Heading
        ------
            foo
        ----\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<h1>Heading</h1>
      //<pre><code>foo
      //</code></pre>
      //<h2>Heading</h2>
      //<pre><code>foo
      //</code></pre>
      //<hr />
        let normalizedCM = #####"""
        <h1>Heading</h1><pre><code>foo
        </code></pre><h2>Heading</h2><pre><code>foo
        </code></pre><hr>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // The first line can be indented more than four spaces:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1557-1564
    func testExample86() {
        let markdownTest =
        #####"""
                foo
            bar\#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>    foo
      //bar
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>    foo
        bar
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Blank lines preceding or following an indented code block
    // are not included in it:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1570-1579
    func testExample87() {
        let markdownTest =
        #####"""
        
            
            foo
            
        \#####n
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>foo
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>foo
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

    // Trailing spaces are included in the code block's content:
    // 
    //     
    // https://github.com/commonmark/commonmark-spec
    // spec.txt lines 1584-1589
    func testExample88() {
        let markdownTest =
        #####"""
            foo  
        """#####
    
        let html = MarkdownParser().html(from: markdownTest)
        
      //<pre><code>foo  
      //</code></pre>
        let normalizedCM = #####"""
        <pre><code>foo  
        </code></pre>
        """#####
    
        XCTAssertEqual(html,normalizedCM)
    }

}

extension IndentedCodeBlocksTests {
    static var allTests: Linux.TestList<IndentedCodeBlocksTests> {
        return [
        ("testExample77", testExample77),
        ("testExample78", testExample78),
        ("testExample79", testExample79),
        ("testExample80", testExample80),
        ("testExample81", testExample81),
        ("testExample82", testExample82),
        ("testExample83", testExample83),
        ("testExample84", testExample84),
        ("testExample85", testExample85),
        ("testExample86", testExample86),
        ("testExample87", testExample87),
        ("testExample88", testExample88)
        ]
    }
}