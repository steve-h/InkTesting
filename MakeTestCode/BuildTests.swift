//
//  BuildTests.swift
//  MakeTestCode
//
//  Created by Stephen Hume on 2019-12-04.
//  Copyright © 2019 Stephen Hume. All rights reserved.
//

import Foundation
import Files
import SwiftMarkdown

let indent = "    "
var testsFolder: Folder?
var sectionNames: [String] = []
var recentSection = ""
var currentFile: File?
var testNamesInSection: [String] = []
func setOutputFolder (_ name: String) {
    testsFolder = try? folder.createSubfolderIfNeeded(at: name)
}

func closeCurrentFile() {
    guard currentFile != nil else {return}
    let testFileName = recentSection.upperCamelCased + "Tests"
    
    let closingMatter = """
    
    }

    extension \(testFileName) {
        static var allTests: Linux.TestList<\(testFileName)> {
            return [
    """
    try? currentFile?.append(closingMatter)
    var linuxTestList = ""
    for testName in testNamesInSection {
        linuxTestList = linuxTestList + "\n        (\"\(testName)\", \(testName)),"
    }
    linuxTestList.removeLast()
    try? currentFile?.append(linuxTestList)
    testNamesInSection = []
    let ending = """
    
            ]
        }
    }
    """
    try? currentFile?.append(ending)
    
}
func makeXCTestManifest() {
    let openingMatter = """
    /**
    *  Ink
    *  Copyright (c) Steve Hume 2019
    *  MIT license, see LICENSE file for details
    */

    import XCTest

    public func allTests() -> [Linux.TestCase] {
        return [
    
    """
    let testFileName = "XCTestManifests"
    currentFile = try? testsFolder?.createFileIfNeeded(withName: testFileName + ".swift")
    try? currentFile?.write(openingMatter)
    var linuxTestList = ""
    for testName in sectionNames {
        linuxTestList = linuxTestList + "\n        Linux.makeTestCase(using: \(testName.upperCamelCased)Tests.allTests),"
    }
    linuxTestList.removeLast()
    try? currentFile?.append(linuxTestList)
    
    let closing = """
    
        ]
    }
    
    """
    try? currentFile?.append(closing)
}
func openNewFile() {
    let openingMatter = """
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
    
    """
    let testFileName = recentSection.upperCamelCased + "Tests"
    currentFile = try? testsFolder?.createFileIfNeeded(withName: testFileName + ".swift")
    try? currentFile?.write(openingMatter)
    let openingClass = """
    
    final class \(testFileName): XCTestCase {
    
    """
    try? currentFile?.append(openingClass)
}

func outputTestCase(_ test: Test) {
    var preamblesegment = "\n"
    if test.preamble != "\n" {
        preamblesegment = "\n    // " + test.preamble.components(separatedBy: "\n").joined(separator:"\n    // ")
    }
    try? currentFile?.append(preamblesegment)
    let testCaseName = "testExample\(test.example)"
    testNamesInSection.append(testCaseName)
    let sepstr:String = "\n        "
    
    let markdownsegment = test.markdown.components(separatedBy: "\n").dropLast().joined(separator:sepstr)
        
//    let htmlsegment = test.html.components(separatedBy: "\n").joined(separator:"\\n").components(separatedBy: "\"").joined(separator:"\\\"")
//    let normalizedhtml = test.html.replacingOccurrences(of: ">\n<", with: "><").replacingOccurrences(of: "<hr />", with: "<hr>")
//    let htmlsegments = normalizedhtml.components(separatedBy: "\n").dropLast()
    let cMarkhtml = try! markdownToHTML(test.markdown, options: [.normalize, .noBreaks])
    let normalizedcMark = cMarkhtml.replacingOccurrences(of: ">\n<", with: "><").replacingOccurrences(of: "<hr />", with: "<hr>").replacingOccurrences(of: "<br />", with: "<br>")
    
    let htmlsegments = normalizedcMark.components(separatedBy: "\n").dropLast()
    let htmlsegment = htmlsegments.joined(separator:sepstr)
//    let poststr = "curl -X POST -s --data-urlencode 'input=" + htmlsegments.joined() + "' https://html-minifier.com/raw"
//    let minifiedHTML = run(bash: poststr).stdout
    
    let testCase = """
        
        // spec.txt lines \(test.startLine)-\(test.endLine)
        func \(testCaseName)() {
            let newlineChar = "\\n"
            var markdownTest =
            #####\"\"\"
            \(markdownsegment)
            \"\"\"#####
            markdownTest = markdownTest + newlineChar // adding because the multiline literal does not include last newline!
            let html = MarkdownParser().html(from: markdownTest)
            let normalizedCM = #####\"\"\"
            \(htmlsegment)
            \"\"\"#####
            XCTAssertEqual(html,normalizedCM)
    
    """
    + "\n    }"
    try? currentFile?.append(testCase)
}
 
