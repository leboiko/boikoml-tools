import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(boikoml_toolsTests.allTests),
    ]
}
#endif