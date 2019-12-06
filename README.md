#  InkTesting

*This is a prototyping project that I am using to understand the CommonMark spec*

Warning: it may not be easy to run.

The idea is that it starts with the spec.md file that is from the CommonMark website open source.

The XCode project has an App "MakeTestCode" that when run inside XCode will produce XCTest files in a CommonMarkTests folder.  These tests are also published with the repo so you do not need to run this test case builder.

If you instead "Test" (run testcases) on the MakeTestCode it will actually run the test on the Ink markdown parser. 

The testcases mostly fail and can act as a base to explore any improvements to Ink.
 
## Normalizer

I am now using SwiftSoup, an HTML Parser, to act as a normalizer.  The Ink output and the CommonMark spec expected result are both parsed and then re-emitted to try and normalize the whitespace.

A problem emerges with all the badly formed fragments. SwiftSoup "fixes" them to get a good parse. I get the fixes in my output.

## **Missing**
 
 -normalizer is still not preserving all test cases **!!!!!!!**
 - truly failing tests can be seen though
 - the tool is linking my fork of Ink (master) that may not be always up-to-date
 
 The code is pretty ugly but it is a one-shot tool to be run every spec upgrade.
 
## **ToDo**
 - verify the normalizer
 
 I will close the issues on GitHub.  Use a Pull Request to suggest improvements.  The code may be highly fluid.
 
## License

Generally MIT but the original spec that is parsed and ends up in the testcases follows
 
 These tests are extracted from https://spec.commonmark.org/0.29/
 title: CommonMark Spec
 author: John MacFarlane
 version: 0.29
 date: '2019-04-06'
 license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0
