#  InkTesting

*This is a prototyping project that I am using to understand the CommonMark spec*

Warning: it may not be easy to run.

The idea is that it starts with the spec.txt file that is from the [CommonMark website open source](https://github.com/commonmark/commonmark-spec).

The XCode project has an App "MakeTestCode" that when run inside XCode will produce XCTest files in a CommonMarkTests folder.  These tests are also published with the repo so you do not need to run this test case builder in order to see the result.

If you instead "Test" (run testcases) on the MakeTestCode it will actually run the tests on the Ink Markdown parser. 

The testcases mostly fail and can act as a base to explore any improvements to Ink. I have used them in an interactive debug to understand how Ink works.
 
## Normalizer

I have stopped using SwiftSoup, an HTML Parser, to act as a normalizer.

The latest version uses the [SwiftMarkdown](https://github.com/vapor-community/markdown) package with the GitHub flavoured Markdown C-code implementation as the **"reference truth"** instead of the spec.txt file.

The Markdown test is executed on cMark and the result is used to write the testcase.

## Missing

 - the tool is linking my fork of Ink (master) that may not be always up-to-date
 
 The code is pretty ugly but it is a one-shot tool to be run every spec upgrade.
 
## ToDo
 
 I will close the issues on GitHub.  Use a Pull Request to suggest improvements.  The code may be highly fluid.
 
## License

Generally MIT but the original spec that is parsed and ends up in the testcases follows
 
 These tests are extracted from https://spec.commonmark.org/0.29/
 title: CommonMark Spec
 author: John MacFarlane
 version: 0.29
 date: '2019-04-06'
 license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0
