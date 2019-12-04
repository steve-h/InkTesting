//
//  NormalizeHTML.swift
//  MakeTestCode
//
//  Created by Stephen Hume on 2019-12-04.
//  Copyright © 2019 Stephen Hume. All rights reserved.
//

import Foundation
import SwiftSoup

//  from: https://github.com/commonmark/commonmark-spec/blob/master/test/normalize.py
//    Return normalized form of HTML which ignores insignificant output
//    differences:
//    Multiple inner whitespaces are collapsed to a single space (except
//    in pre tags):
//        >>> normalize_html("<p>a  \t b</p>")
//        '<p>a b</p>'
//        >>> normalize_html("<p>a  \t\nb</p>")
//        '<p>a b</p>'
//    * Whitespace surrounding block-level tags is removed.
//        >>> normalize_html("<p>a  b</p>")
//        '<p>a b</p>'
//        >>> normalize_html(" <p>a  b</p>")
//        '<p>a b</p>'
//        >>> normalize_html("<p>a  b</p> ")
//        '<p>a b</p>'
//        >>> normalize_html("\n\t<p>\n\t\ta  b\t\t</p>\n\t")
//        '<p>a b</p>'
//        >>> normalize_html("<i>a  b</i> ")
//        '<i>a b</i> '
//    * Self-closing tags are converted to open tags.
//        >>> normalize_html("<br />")
//        '<br>'
//    * Attributes are sorted and lowercased.
//        >>> normalize_html('<a title="bar" HREF="foo">x</a>')
//        '<a href="foo" title="bar">x</a>'
//    * References are converted to unicode, except that '<', '>', '&', and
//      '"' are rendered using entities.
//        >>> normalize_html("&forall;&amp;&gt;&lt;&quot;")
//        '\u2200&amp;&gt;&lt;&quot;'

func normalize(html: String) -> String {
    do {
      
        let doc: Document = try SwiftSoup.parseBodyFragment(html)
        
        doc.outputSettings(doc.outputSettings().prettyPrint(pretty: false))
        
        return try doc.body()?.html() ?? ""
    } catch Exception.Error(let type, let message) {
        print(message)
    } catch {
        print("error")
    }
    return ""
}
