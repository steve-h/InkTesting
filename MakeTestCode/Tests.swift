//
//  Tests.swift
//  MakeTestCode
//
//  Created by Stephen Hume on 2019-12-04.
//  Copyright © 2019 Stephen Hume. All rights reserved.
//

// Modeled after the extractor in commonmark
// https://github.com/commonmark/commonmark-spec/blob/master/test/spec_tests.py
// The original Python code to parse tests
//        def get_tests(specfile):
//            line_number = 0
//            start_line = 0
//            end_line = 0
//            example_number = 0
//            markdown_lines = []
//            html_lines = []
//            state = 0  # 0 regular text, 1 markdown example, 2 html output
//            headertext = ''
//            tests = []
//
//            header_re = re.compile('#+ ')
//
//            with open(specfile, 'r', encoding='utf-8', newline='\n') as specf:
//                for line in specf:
//                    line_number = line_number + 1
//                    l = line.strip()
//                    if l == "`" * 32 + " example":
//                        state = 1
//                    elif state == 2 and l == "`" * 32:
//                        state = 0
//                        example_number = example_number + 1
//                        end_line = line_number
//                        tests.append({
//                            "markdown":''.join(markdown_lines).replace('→',"\t"),
//                            "html":''.join(html_lines).replace('→',"\t"),
//                            "example": example_number,
//                            "start_line": start_line,
//                            "end_line": end_line,
//                            "section": headertext})
//                        start_line = 0
//                        markdown_lines = []
//                        html_lines = []
//                    elif l == ".":
//                        state = 2
//                    elif state == 1:
//                        if start_line == 0:
//                            start_line = line_number - 1
//                        markdown_lines.append(line)
//                    elif state == 2:
//                        html_lines.append(line)
//                    elif state == 0 and re.match(header_re, line):
//                        headertext = header_re.sub('', line).strip()
//            return tests
import Foundation

struct Test {
    var markdown: String = ""
    var html: String = ""
    var example: Int = 0
    var startLine: Int = 0
    var endLine: Int = 0
    var section: String = ""
    var preamble: String = ""
}
// These are the test boundaries in the commonmark spec.txt file
// https://github.com/commonmark/commonmark-spec/blob/master/spec.txt
let exampleEndMarker = String(repeating: "`", count: 32)
let exampleStartMarker = exampleEndMarker + " example"

// Feed the commonmark spec.txt file into this extractor
func getTests(_ specFile: String) -> [Test] {
    enum State {
        case collectPreamble
        case collectMarkdown
        case collectHTML
        }
    
    var tests: [Test] = []
    var test: Test = Test()
    var recentSection: String = ""
    var exampleNumber: Int = 0
    var state:State = .collectPreamble
    
    var preambleLines: Array<Substring> = []
    var markdownLines: Array<Substring> = []
    var htmlLines: Array<Substring> = []
    
    let lines: Array<Substring> = specFile.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)

    for (index, linefromArray) in lines.enumerated() {
        let line = linefromArray + "\n"
        
        switch state {
        case .collectPreamble:
            if linefromArray == exampleStartMarker {
                test.preamble = preambleLines.joined(separator: "") + "\n"
                preambleLines = []
                markdownLines  = []
                state = .collectMarkdown
                test.section = recentSection
                test.startLine = index + 1   // line number where test starts
            } else {
                preambleLines.append(line)
                let linetext = line.drop(while: {char in char.isWhitespace})
                let head = linetext.prefix(while: {char in char == "#"})
                if head.count > 0 {
                    let remaining = linetext.drop(while: {char in char == "#"})
                    if remaining.first == " " {
                        recentSection = String(remaining.drop(while: {char in char.isWhitespace}).dropLast())
                    }
                }
            }
        
        case .collectMarkdown:
            if linefromArray == "." {
                test.markdown = String(markdownLines.joined(separator: "").map({char in
                    if char == "→" {return "\t"}
                    return char
                }) as [Character])
                htmlLines = []
                markdownLines  = []
                state = .collectHTML
            } else {
                markdownLines.append(line)
            }
        case .collectHTML:
            if linefromArray == exampleEndMarker {
                test.html = String(htmlLines.joined(separator: "").map({char in
                    if char == "→" {return "\t"}
                    return char
                }) as [Character])
                htmlLines = []
                
                state = .collectPreamble
                exampleNumber = exampleNumber + 1 // only increment if we get a whole test
                test.example = exampleNumber
                test.endLine = index + 1 // line number where test ends
                tests.append(test)
//                print("\(test)")
                test = Test()
            } else {
                htmlLines.append(line)
            }
        }
    }
    return tests
}
