import XCTest
@testable import MinecraftNBT

public class DescriptionTests: XCTestCase {
	func testByte() {
		XCTAssertEqual(ByteValue(value: 43).description, "[byte:43]")
		XCTAssertEqual(ByteValue(value: 43).description(indentation: 3), "[byte:43]")
	}

	func testShort() {
		XCTAssertEqual(ShortValue(value: 43).description, "[short:43]")
		XCTAssertEqual(ShortValue(value: 43).description(indentation: 3), "[short:43]")
	}

	func testInt() {
		XCTAssertEqual(IntValue(value: 43).description, "[int:43]")
		XCTAssertEqual(IntValue(value: 43).description(indentation: 3), "[int:43]")
	}

	func testLong() {
		XCTAssertEqual(LongValue(value: 43).description, "[long:43]")
		XCTAssertEqual(LongValue(value: 43).description(indentation: 3), "[long:43]")
	}

	func testFloat() {
		XCTAssertEqual(FloatValue(value: 43.23).description, "[float:43.23]")
		XCTAssertEqual(FloatValue(value: 43.23).description(indentation: 3), "[float:43.23]")
	}

	func testDouble() {
		XCTAssertEqual(DoubleValue(value: 43.23).description, "[double:43.23]")
		XCTAssertEqual(DoubleValue(value: 43.23).description(indentation: 3), "[double:43.23]")
	}

	func testString() {
		XCTAssertEqual(StringValue(value: "SomeValue").description, "[text:SomeValue]")
		XCTAssertEqual(StringValue(value: "SomeValue").description(indentation: 3), "[text:SomeValue]")
	}

	func testList() {
		XCTAssertEqual(GenericList(genericType: .string, elements: [StringValue(value: "Value1"),
																						StringValue(value: "Value2")]).description,
							"[list:\n > [text:Value1]\n > [text:Value2]\n]")
		XCTAssertEqual(GenericList(genericType: .string, elements: [StringValue(value: "Value1"),
																						StringValue(value: "Value2")]).description(indentation: 3),
							"[list:\n          > [text:Value1]\n          > [text:Value2]\n         ]")
	}

	func testByteArray() {
		XCTAssertEqual(ByteArray(elements: [103, 32]).description, "[list:\n > [byte:103]\n > [byte:32]\n]")
		XCTAssertEqual(ByteArray(elements: [103, 32]).description(indentation: 3),
							"[list:\n          > [byte:103]\n          > [byte:32]\n         ]")
	}

	func testIntArray() {
		XCTAssertEqual(IntArray(elements: [10343, 3212]).description, "[list:\n > [int:10343]\n > [int:3212]\n]")
		XCTAssertEqual(IntArray(elements: [10343, 3212]).description(indentation: 3),
							"[list:\n          > [int:10343]\n          > [int:3212]\n         ]")
	}

	func testCompound() {
		XCTAssertEqual(Compound(contents: [.init(key: "SomeKey", value: StringValue(value: "SomeStrVal"))]).description,
							"[dict:\n > `SomeKey` -> [text:SomeStrVal]\n]")
		XCTAssertEqual(Compound(contents: [.init(key: "SomeKey", value: StringValue(value: "SomeStrVal"))]).description(indentation: 3),
							"[dict:\n          > `SomeKey` -> [text:SomeStrVal]\n         ]")
	}

	func testEnd() {
		XCTAssertEqual(End().description, "[end]")
		XCTAssertEqual(End().description(indentation: 3 ), "[end]")
	}
}
