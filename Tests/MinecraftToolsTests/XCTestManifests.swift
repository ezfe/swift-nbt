import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IntegerDeserializationTests.allTests),
        testCase(IntegerSerializationTests.allTests),
        testCase(StringTests.allTests),
    ]
}
#endif
