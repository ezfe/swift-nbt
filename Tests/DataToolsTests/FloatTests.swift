import XCTest
@testable import DataTools

final class FloatTests: XCTestCase {
	
	func testFloat32Serialization() {
		let acc = DataAccumulator()
		Float32(1).append(to: acc)
		XCTAssertEqual(Data([0x3F, 0x80, 0x00, 0x00]), acc.data)
	}
	
	func testFloat32Deserialization() {
		let stream = DataStream(Data([0x3F, 0x80, 0x00, 0x00]))
		let read = Float32.make(with: stream)
		XCTAssertEqual(1, read)
	}
	
	func testFloat64Serialization() {
		let acc = DataAccumulator()
		Float64(1).append(to: acc)
		XCTAssertEqual(Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]), acc.data)
	}
	
	func testFloat64Deserialization() {
		let stream = DataStream(Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
		let read = Float64.make(with: stream)
		XCTAssertEqual(1, read)
	}
}
