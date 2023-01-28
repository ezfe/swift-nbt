import XCTest
@testable import MinecraftNBT

final class DescriptionTests: XCTestCase {
	func testByte() {
		XCTAssertEqual(NBTByte(43).description(indentation: 3), "[byte:43]")
	}

	func testShort() {
		XCTAssertEqual(NBTShort(43).description(indentation: 3), "[short:43]")
	}

	func testInt() {
		XCTAssertEqual(NBTInt(43).description(indentation: 3), "[int:43]")
	}

	func testLong() {
		XCTAssertEqual(NBTLong(43).description(indentation: 3), "[long:43]")
	}

	func testFloat() {
		XCTAssertEqual(NBTFloat(43.23).description(indentation: 3), "[float:43.23]")
	}

	func testDouble() {
		XCTAssertEqual(NBTDouble(43.23).description(indentation: 3), "[double:43.23]")
	}

	func testString() {
		XCTAssertEqual("SomeValue".description(indentation: 3), "[text:SomeValue]")
	}

	func testList() {
		XCTAssertEqual(NBTList(genericType: .string,
									  elements: ["Value1",  "Value2"]).description(indentation: 3),
							"[list<genericList(text)>:\n          > [text:Value1]\n          > [text:Value2]\n         ]")
	}

	func testByteList() {
		XCTAssertEqual(NBTList(bytes: [103, 32]).description(indentation: 3),
							"[list<byteList>:\n          > [byte:103]\n          > [byte:32]\n         ]")
	}
	
	func testIntList() {
		XCTAssertEqual(NBTList(ints: [10343, 3212]).description(indentation: 3),
							"[list<intList>:\n          > [int:10343]\n          > [int:3212]\n         ]")
	}
	
	func testLongList() {
		XCTAssertEqual(NBTList(longs: [1203915, 12309123]).description(indentation: 3),
							"[list<longList>:\n          > [long:1203915]\n          > [long:12309123]\n         ]")
	}

	func testCompound() {
		XCTAssertEqual(NBTCompound(contents: ["SomeKey": "SomeStrVal"]).description(indentation: 3),
							"[dict:\n          > `SomeKey` -> [text:SomeStrVal]\n         ]")
	}
}
