import XCTest
@testable import DataTools

final class DataStreamTests: XCTestCase {
	
	func testNext() {
		let bytes: [UInt8] = [0x3F, 0x00, 0xA4]
		let data = Data(bytes)
		let stream = DataStream(data)

		for byte in bytes {
			XCTAssertEqual(stream.next(), byte)
		}
		for _ in 0..<100 {
			XCTAssertEqual(stream.next(), 0x00)
		}
	}
}
