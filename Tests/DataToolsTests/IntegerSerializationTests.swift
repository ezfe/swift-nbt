import XCTest
@testable import DataTools

final class IntegerSerializationTests: XCTestCase {
	
	//MARK:- Unsigned Data
	// Unsigned data is tested by feeding in a series of bytes
	// and verifying they read out as the same value
	
	func testUInt8Serialization() {
		let acc = DataAccumulator()
		UInt8(0xAC).append(to: acc)
		XCTAssertEqual(Data([0xAC]), acc.data)
	}
	
	func testUInt16Serialization() {
		let acc = DataAccumulator()
		UInt16(0xA3C8).append(to: acc)
		XCTAssertEqual(Data([0xA3, 0xC8]), acc.data)
	}
	
	func testUInt32Serialization() {
		let acc = DataAccumulator()
		UInt32(0xDA09A73F).append(to: acc)
		XCTAssertEqual(Data([0xDA, 0x09, 0xA7, 0x3F]), acc.data)
	}
	
	func testUInt64Serialization() {
		let acc = DataAccumulator()
		UInt64(0xDC07884DFA00D378).append(to: acc)
		XCTAssertEqual(Data([0xDC, 0x07, 0x88, 0x4D, 0xFA, 0x00, 0xD3, 0x78]), acc.data)
	}
	
	//MARK:- Signed Data
	// Signed data is tested with  positive and negative number
	// and verifying they read out properly
	
	func testInt8Serialization() {
		let acc = DataAccumulator()
		Int8(74).append(to: acc)
		XCTAssertEqual(Data([0x4A]), acc.data)
		
		let acc2 = DataAccumulator()
		Int8(-74).append(to: acc2)
		XCTAssertEqual(Data([0xB6]), acc2.data)
	}
	
	func testInt16Serialization() {
		let acc = DataAccumulator()
		Int16(28432).append(to: acc)
		XCTAssertEqual(Data([0x6F, 0x10]), acc.data)
		
		let acc2 = DataAccumulator()
		Int16(-28432).append(to: acc2)
		XCTAssertEqual(Data([0x90, 0xF0]), acc2.data)
	}
	
	func testInt32Serialization() {
		let acc = DataAccumulator()
		Int32(2042384638).append(to: acc)
		XCTAssertEqual(Data([0x79, 0xBC, 0x50, 0xFE]), acc.data)
		
		let acc2 = DataAccumulator()
		Int32(-2042384638).append(to: acc2)
		XCTAssertEqual(Data([0x86, 0x43, 0xAF, 0x02]), acc2.data)
	}
	
	func testInt64Serialization() {
		let acc = DataAccumulator()
		Int64(4245338844433533642).append(to: acc)
		XCTAssertEqual(Data([0x3A, 0xEA, 0x79, 0x2F, 0xAD, 0xA0, 0xCA, 0xCA]), acc.data)
		
		let acc2 = DataAccumulator()
		Int64(-4245338844433533642).append(to: acc2)
		XCTAssertEqual(Data([0xC5, 0x15, 0x86, 0xD0, 0x52, 0x5F, 0x35, 0x36]), acc2.data)
	}
}
