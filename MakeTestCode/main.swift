//
//  main.swift
//  MakeTestCode
//
//  Created by Stephen Hume on 2019-11-26.
//  Copyright © 2019 Stephen Hume. All rights reserved.
//

import Foundation
import Ink
import Files
import SwiftShell

guard CommandLine.arguments.count > 1 else {
    print("""
    Ink: Markdown -> HTML converter
    -------------------------------
    Pass a Markdown string to convert as input,
    and HTML will be returned as output.
    """)
    exit(0)
}
print (CommandLine.arguments[1])
let folder = try Folder(path: CommandLine.arguments[1])
let commonMarkSpec = try folder.file(named: "spec.md").readAsString()

let allTheTests = getTests(commonMarkSpec)
setOutputFolder("CommonMarkTests")
for test in allTheTests {
    if test.section != recentSection {
        closeCurrentFile()
        recentSection = test.section
        sectionNames.append(recentSection)
        openNewFile()
    }
    outputTestCase(test)
}
closeCurrentFile()
makeXCTestManifest()
