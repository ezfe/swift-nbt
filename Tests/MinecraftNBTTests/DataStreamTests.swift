import XCTest
@testable import MinecraftNBT
@testable import DataTools

final class DataStreamTests: XCTestCase {
	func testReadPayload() {
		let bytes: [UInt8] = [
			0x3F,                                           // byte
			0x46, 0x29,                                     // short
			0x0C, 0x77, 0x1D, 0x5E,                         // int
			0x07, 0x27, 0x4D, 0xAA, 0xD8, 0x84, 0xB9, 0x26, // long
			0x4b, 0x09, 0x84, 0xa0,                         // float
			0x43, 0x71, 0xF7, 0x5D, 0x93, 0x7F, 0x51, 0xE9, // double
			0x00, 0x05, 0x48, 0x65, 0x6C, 0x6C, 0x6F,       // string
			0x05, 0x00, 0x00, 0x00, 0x00,                   // empty generic list of floats
			0x00, 0x00, 0x00, 0x00,                         // empty generic list of bytes
			0x00, 0x00, 0x00, 0x00,                         // empty generic list of ints
			0x00, 0x00, 0x00, 0x00,                         // empty generic list of longs
			0x00,                                           // empty compound
			0x00,                                           // end tag
		]
		let data = Data(bytes)
		let stream = DataStream(data)
		
		XCTAssertTrue(stream.readPayload(type: .byte).equal(to: ByteValue(value: 0x3F)))
		XCTAssertTrue(stream.readPayload(type: .short).equal(to: ShortValue(value: 0x4629)))
		XCTAssertTrue(stream.readPayload(type: .int).equal(to: IntValue(value: 0x0C771D5E)))
		XCTAssertTrue(stream.readPayload(type: .long).equal(to: LongValue(value: 0x07274DAAD884B926)))
		XCTAssertTrue(stream.readPayload(type: .float).equal(to: FloatValue(value: 9012384.0)))
		XCTAssertTrue(stream.readPayload(type: .double).equal(to: DoubleValue(value: 80912894123122320)))
		XCTAssertTrue(stream.readPayload(type: .string).equal(to: StringValue(value: "Hello")))
		XCTAssertTrue(stream.readPayload(type: .list).equal(to: GenericList(genericType: .float, elements: [])))
		XCTAssertTrue(stream.readPayload(type: .byteArray).equal(to: ByteArray(elements: [])))
		XCTAssertTrue(stream.readPayload(type: .intArray).equal(to: IntArray(elements: [])))
		XCTAssertTrue(stream.readPayload(type: .longArray).equal(to: LongArray(elements: [])))
		XCTAssertTrue(stream.readPayload(type: .compound).equal(to: Compound(contents: [])))
		XCTAssertTrue(stream.readPayload(type: .end).equal(to: End()))
	}
}
