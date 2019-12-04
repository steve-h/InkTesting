#  InkTesting

*This is a prototyping project that I am using to understand the CommonMark spec*

Warning: it may not be easy to run.

The idea is that it starts with the spec.md file that is from the CommonMark website open source.

The XCode project has an App "MakeTestCode" that when run inside XCode will produce XCTest files in a CommonMarkTests folder.  These tests are also published with the repo so you do not need to run this test case builder.

If you instead "Test" (run testcases) on the MakeTestCode it will actually run the test on the Ink markdown parser. 

The testcases mostly fail and can act as a base to explore any improvements to Ink.
 
## **Missing**
 - a normalizer for the test result from the spec.  Things like whitespace differences will cause test failures.  So in a meta-way I am using the tests to improve the normalizer first.
 - truly failing tests can be seen though
 - the tool is linking my fork of Ink (master) that may not be always up-to-date
 
 The code is pretty ugly but it is a one-shot tool to be run every spec upgrade.
 
## **ToDo**
 - an html normalizer
 
 I will close the issues on GitHub.  Use a Pull Request to suggest improvements.  The code may be highly fluid.
 
## License

Generally MIT but the original spec that is parsed and ends up in the testcases follows
 
 These tests are extracted from https://spec.commonmark.org/0.29/
 title: CommonMark Spec
 author: John MacFarlane
 version: 0.29
 date: '2019-04-06'
 license: '[CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0
