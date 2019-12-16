/**
*  Ink
*  Copyright (c) Steve Hume 2019
*  MIT license, see LICENSE file for details
*/

import XCTest

public func allTests() -> [Linux.TestCase] {
    return [

        Linux.makeTestCase(using: TabsTests.allTests),
        Linux.makeTestCase(using: PrecedenceTests.allTests),
        Linux.makeTestCase(using: ThematicBreaksTests.allTests),
        Linux.makeTestCase(using: AtxHeadingsTests.allTests),
        Linux.makeTestCase(using: SetextHeadingsTests.allTests),
        Linux.makeTestCase(using: IndentedCodeBlocksTests.allTests),
        Linux.makeTestCase(using: FencedCodeBlocksTests.allTests),
        Linux.makeTestCase(using: HtmlBlocksTests.allTests),
        Linux.makeTestCase(using: LinkReferenceDefinitionsTests.allTests),
        Linux.makeTestCase(using: ParagraphsTests.allTests),
        Linux.makeTestCase(using: BlankLinesTests.allTests),
        Linux.makeTestCase(using: BlockQuotesTests.allTests),
        Linux.makeTestCase(using: ListItemsTests.allTests),
        Linux.makeTestCase(using: ListsTests.allTests),
        Linux.makeTestCase(using: InlinesTests.allTests),
        Linux.makeTestCase(using: BackslashEscapesTests.allTests),
        Linux.makeTestCase(using: EntityAndNumericCharacterReferencesTests.allTests),
        Linux.makeTestCase(using: CodeSpansTests.allTests),
        Linux.makeTestCase(using: EmphasisAndStrongEmphasisTests.allTests),
        Linux.makeTestCase(using: LinksTests.allTests),
        Linux.makeTestCase(using: ImagesTests.allTests),
        Linux.makeTestCase(using: AutolinksTests.allTests),
        Linux.makeTestCase(using: RawHtmlTests.allTests),
        Linux.makeTestCase(using: HardLineBreaksTests.allTests),
        Linux.makeTestCase(using: SoftLineBreaksTests.allTests),
        Linux.makeTestCase(using: TextualContentTests.allTests)
    ]
}
