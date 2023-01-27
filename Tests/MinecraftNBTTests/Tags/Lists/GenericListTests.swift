import XCTest
import DataTools
@testable import MinecraftNBT

final class GenericListTests: XCTestCase {
	func testMakeWithBlankStream() {
		let dataStream = DataStream([])
		XCTAssertNil(GenericList.make(with: dataStream))
	}
	
	func testMakeWithInvalidType() {
		let bytes: [UInt8] = [
			0xFF, // type: invalid
		]
		let stream = DataStream(bytes)
		XCTAssertNil(GenericList.make(with: stream))
	}
	
	func testMakeWithTypeOnly() {
		let bytes: [UInt8] = [
			0x06, // type: double
		]
		let stream = DataStream(bytes)
		XCTAssertNil(GenericList.make(with: stream))
	}
	
	func testMakeWithLengthMismatch() {
		let bytes: [UInt8] = [
			0x06, // type: double
			0x00, 0x00, 0x00, 0x05, // 5 items
		]
		let stream = DataStream(bytes)
		XCTAssertNil(GenericList.make(with: stream))
	}
	
	func testMakeEmptyList() {
		let bytes: [UInt8] = [
			0x06, // type: double
			0x00, 0x00, 0x00, 0x00, // 0 items
		]
		let stream = DataStream(bytes)
		
		let actual = GenericList.make(with: stream)
		let expected = GenericList(genericType: .double, elements: [])
		
		XCTAssertTrue(equal(expected, actual))
	}
	
	func testMakeListWithSimpleItems() {
		let bytes: [UInt8] = [
			0x02, // type: short
			0x00, 0x00, 0x00, 0x03, // 3 items
			0x01, 0x42,
			0x00, 0xAF,
			0x19, 0x38,
		]
		let stream = DataStream(bytes)
		
		let actual = GenericList.make(with: stream)
		let expected = GenericList(genericType: .short, elements: [
			ShortValue(value: 0x0142),
			ShortValue(value: 0x00AF),
			ShortValue(value: 0x1938),
		])
		
		XCTAssertTrue(equal(expected, actual))
	}
	
	func testMakeListWithComplexItems() {
		let bytes: [UInt8] = [
			0x09, // type: list
			0x00, 0x00, 0x00, 0x02, // 2 items
			// sublist 1
			0x02, // type: short
			0x00, 0x00, 0x00, 0x00, // 0 items
			// sublist 2
			0x01, // type: byte
			0x00, 0x00, 0x00, 0x03, // 3 items
			0x01,
			0x00,
			0x19,
		]
		let stream = DataStream(bytes)
		
		let actual = GenericList.make(with: stream)
		
		let expected = GenericList(genericType: .list, elements: [
			GenericList(genericType: .short, elements: []),
			GenericList(genericType: .byte, elements: [ByteValue(value: 0x01),
																	 ByteValue(value: 0x00),
																	 ByteValue(value: 0x19)])
		])
		XCTAssertTrue(equal(expected, actual))
	}
	
	func testAppendEmptyList() {
		let accumulator = DataAccumulator()
		GenericList(genericType: .int, elements: []).append(to: accumulator)
		
		XCTAssertEqual(accumulator.data, Data([0x03, 0x00, 0x00, 0x00, 0x00]))
	}
	
	func testAppendSimpleList() {
		let accumulator = DataAccumulator()
		GenericList(genericType: .short, elements: [ShortValue(value: 17961),
																  ShortValue(value: -34),
																  ShortValue(value: 8)]).append(to: accumulator)
		
		XCTAssertEqual(accumulator.data, Data([
			0x02, //type: short
			0x00, 0x00, 0x00, 0x03, // 3 items
			0x46, 0x29, // 17961
			0xFF, 0xDE, // -34
			0x00, 0x08 // 8
		]))
	}
	
	func testEqualityEqualLists() {
		XCTAssertEqual(GenericList(genericType: .int, elements: [IntValue(value: 4), IntValue(value: 32)]),
							GenericList(genericType: .int, elements: [IntValue(value: 4), IntValue(value: 32)]))
	}
	
	func testEqualityUnequalLists() {
		XCTAssertNotEqual(GenericList(genericType: .int, elements: [IntValue(value: 4), IntValue(value: 32)]),
							GenericList(genericType: .int, elements: [IntValue(value: 8), IntValue(value: 12)]))
	}

	func testEqualityDifferentTypes() {
		XCTAssertNotEqual(GenericList(genericType: .int, elements: [IntValue(value: 4), IntValue(value: 32)]),
								GenericList(genericType: .long, elements: [LongValue(value: 4), LongValue(value: 32)]))
	}
	
	func testEqualityDifferentLengths() {
		XCTAssertNotEqual(GenericList(genericType: .int, elements: [IntValue(value: 4), IntValue(value: 32)]),
								GenericList(genericType: .int, elements: [IntValue(value: 4)]))
	}
}
