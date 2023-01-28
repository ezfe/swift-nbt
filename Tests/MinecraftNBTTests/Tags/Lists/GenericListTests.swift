import XCTest
import DataTools
@testable import MinecraftNBT

final class GenericListTests: XCTestCase {
	func testMakeWithBlankStream() {
		let dataStream = DataStream([])
		XCTAssertNil(NBTList.makeGenericList(with: dataStream))
	}
	
	func testMakeWithInvalidType() {
		let bytes: [UInt8] = [
			0xFF, // type: invalid
		]
		let stream = DataStream(bytes)
		XCTAssertNil(NBTList.makeGenericList(with: stream))
	}
	
	func testMakeWithTypeOnly() {
		let bytes: [UInt8] = [
			0x06, // type: double
		]
		let stream = DataStream(bytes)
		XCTAssertNil(NBTList.makeGenericList(with: stream))
	}
	
	func testMakeWithLengthMismatch() {
		let bytes: [UInt8] = [
			0x06, // type: double
			0x00, 0x00, 0x00, 0x05, // 5 items
		]
		let stream = DataStream(bytes)
		XCTAssertNil(NBTList.makeGenericList(with: stream))
	}
	
	func testMakeEmptyList() {
		let bytes: [UInt8] = [
			0x06, // type: double
			0x00, 0x00, 0x00, 0x00, // 0 items
		]
		let stream = DataStream(bytes)
		
		let actual = NBTList.makeGenericList(with: stream)
		let expected = NBTList(genericType: .double, elements: [])
		
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
		
		let actual = NBTList.makeGenericList(with: stream)
		let expected = NBTList(genericType: .short, elements: [
			NBTShort(0x0142),
			NBTShort(0x00AF),
			NBTShort(0x1938),
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
		
		let actual = NBTList.makeGenericList(with: stream)
		
		let expected = NBTList(genericType: .list, elements: [
			NBTList(genericType: .short, elements: []),
			NBTList(genericType: .byte, elements: [NBTByte(0x01), NBTByte(0x00), NBTByte(0x19)])
		])
		XCTAssertTrue(equal(expected, actual))
	}
	
	func testAppendEmptyList() {
		let accumulator = DataAccumulator()
		NBTList(genericType: .int, elements: []).append(to: accumulator)
		
		XCTAssertEqual(accumulator.data, Data([0x03, 0x00, 0x00, 0x00, 0x00]))
	}
	
	func testAppendSimpleList() {
		let accumulator = DataAccumulator()
		NBTList(genericType: .short, elements: [NBTShort(17961),
															 NBTShort(-34),
															 NBTShort(8)]).append(to: accumulator)
		
		XCTAssertEqual(accumulator.data, Data([
			0x02, //type: short
			0x00, 0x00, 0x00, 0x03, // 3 items
			0x46, 0x29, // 17961
			0xFF, 0xDE, // -34
			0x00, 0x08 // 8
		]))
	}
	
	func testEqualityEqualLists() {
		XCTAssertEqual(NBTList(genericType: .int, elements: [NBTInt(4), NBTInt(32)]),
							NBTList(genericType: .int, elements: [NBTInt(4), NBTInt(32)]))
	}
	
	func testEqualityUnequalLists() {
		XCTAssertNotEqual(NBTList(genericType: .int, elements: [NBTInt(4), NBTInt(32)]),
								NBTList(genericType: .int, elements: [NBTInt(8), NBTInt(12)]))
	}

	func testEqualityDifferentTypes() {
		XCTAssertNotEqual(NBTList(genericType: .int, elements: [NBTInt(4), NBTInt(32)]),
								NBTList(genericType: .long, elements: [NBTLong(4), NBTLong(32)]))
	}
	
	func testEqualityDifferentLengths() {
		XCTAssertNotEqual(NBTList(genericType: .int, elements: [NBTInt(4), NBTInt(32)]),
								NBTList(genericType: .int, elements: [NBTInt(4)]))
	}
}
