import XCTest
@testable import MinecraftNBT
@testable import DataTools

final class IntegerDeserializationTests: XCTestCase {

    //MARK:- Unsigned Data
    // Unsigned data is tested by feeding in a series of bytes
    // and verifying they read out as the same value

    func testUInt8Deserialization() {
        let stream = DataStream(Data([0xAC]))
        let read = UInt8.make(with: stream)
        XCTAssertEqual(0xAC, read)
    }

    func testUInt16Deserialization() {
        let stream = DataStream(Data([0xA3, 0xC8]))
        let read = UInt16.make(with: stream)
        XCTAssertEqual(0xA3C8, read)
    }

    func testUInt32Deserialization() {
        let stream = DataStream(Data([0xDA, 0x09, 0xA7, 0x3F]))
        let read = UInt32.make(with: stream)
        XCTAssertEqual(0xDA09A73F, read)
    }

    func testUInt64Deserialization() {
        let stream = DataStream(Data([0xDC, 0x07, 0x88, 0x4D, 0xFA, 0x00, 0xD3, 0x78]))
        let read = UInt64.make(with: stream)
        XCTAssertEqual(0xDC07884DFA00D378, read)
    }

    //MARK:- Signed Data
    // Signed data is tested witha  positive and negative number
    // and verifying they read out properly

    func testInt8Deserialization() {
        let stream = DataStream(Data([0x4A]))
        let read = Int8.make(with: stream)
        XCTAssertEqual(74, read)

        let stream2 = DataStream(Data([0xB6]))
        let read2 = Int8.make(with: stream2)
        XCTAssertEqual(-74, read2)
    }

    func testInt16Deserialization() {
        let stream = DataStream(Data([0x6F, 0x10]))
        let read = Int16.make(with: stream)
        XCTAssertEqual(28432, read)

        let stream2 = DataStream(Data([0x90, 0xF0]))
        let read2 = Int16.make(with: stream2)
        XCTAssertEqual(-28432, read2)
    }

    func testInt32Deserialization() {
        let stream = DataStream(Data([0x79, 0xBC, 0x50, 0xFE]))
        let read = Int32.make(with: stream)
        XCTAssertEqual(2042384638, read)

        let stream2 = DataStream(Data([0x86, 0x43, 0xAF, 0x02]))
        let read2 = Int32.make(with: stream2)
        XCTAssertEqual(-2042384638, read2)
    }

    func testInt64Deserialization() {
        let stream = DataStream(Data([0x3A, 0xEA, 0x79, 0x2F, 0xAD, 0xA0, 0xCA, 0xCA]))
        let read = Int64.make(with: stream)
        XCTAssertEqual(4245338844433533642, read)

        let stream2 = DataStream(Data([0xC5, 0x15, 0x86, 0xD0, 0x52, 0x5F, 0x35, 0x36]))
        let read2 = Int64.make(with: stream2)
        XCTAssertEqual(-4245338844433533642, read2)
    }

    static var allTests = [
        ("testUInt8Deserialization", testUInt8Deserialization),
        ("testUInt16Deserialization", testUInt16Deserialization),
        ("testUInt32Deserialization", testUInt32Deserialization),
        ("testUInt64Deserialization", testUInt64Deserialization),
        ("testInt8Deserialization", testInt8Deserialization),
        ("testInt16Deserialization", testInt16Deserialization),
        ("testInt32Deserialization", testInt32Deserialization),
        ("testInt64Deserialization", testInt64Deserialization),
    ]
}
