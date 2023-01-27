import XCTest
@testable import DataTools

final class DataStreamTests: XCTestCase {
	
	func testNext() {
		let bytes: [UInt8] = [0x3F, 0x00, 0xA4]
		let stream = DataStream(bytes)

		for byte in bytes {
			XCTAssertEqual(stream.next(), byte)
		}
		for _ in 0..<5 {
			XCTAssertNil(stream.next())
		}
	}
}
