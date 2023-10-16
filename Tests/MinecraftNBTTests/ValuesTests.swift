import XCTest
@testable import MinecraftNBT
@testable import DataTools

final class ValuesTests: XCTestCase {
	func testAppendToAccumulator() {
		let accumulator = DataAccumulator()
		
		NBTByte(0x3F).append(to: accumulator)
		NBTShort(0x4629).append(to: accumulator)
		NBTInt(0x0C771D5E).append(to: accumulator)
		NBTLong(0x07274DAAD884B926).append(to: accumulator)
		NBTFloat(9012384.0).append(to: accumulator)
		NBTDouble(80912894123122320).append(to: accumulator)
		NBTString("Hello").append(to: accumulator)
		NBTList(genericType: .float, elements: []).append(to: accumulator)
		NBTList(bytes: []).append(to: accumulator)
		NBTList(ints: []).append(to: accumulator)
		NBTList(longs: []).append(to: accumulator)
		NBTCompound(contents: [:]).append(to: accumulator)

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
		]
		XCTAssertEqual(accumulator.data, Data(bytes))
	}
	
	func testBasicEquality() {
		let byte = NBTByte(0x3F)
		let short = NBTShort(0x4629)
		let int = NBTInt(0x0C771D5E)
		let long = NBTLong(0x07274DAAD884B926)
		let float = NBTFloat(9012384.0)
		let double = NBTDouble(80912894123122320)
		let string = NBTString("Hello")
		let list = NBTList(genericType: .float, elements: [NBTFloat(9012384.0), NBTFloat(12842.12)])
		let byteList = NBTList(bytes: [0x12, 0x34, 0x12])
		let intList = NBTList(ints: [0x153, 0x34223, 0x121])
		let longList = NBTList(longs: [0x15341344, 0x34223425, 0x121234])
		let compound = NBTCompound(contents: ["Hello": "World!"])
		
		let elements: [any NBTTag] = [byte, short, int, long, float, double, string, list, byteList, intList, longList, compound]
		for (i, l) in elements.enumerated() {
			for (j, r) in elements.enumerated() {
				if i == j {
					XCTAssertTrue(l.equal(to: r))
					XCTAssertTrue(r.equal(to: l))
				} else {
					XCTAssertFalse(l.equal(to: r))
					XCTAssertFalse(r.equal(to: l))
				}
			}
		}
	}
	
	func testValueInequality() {
		XCTAssertFalse(NBTByte(5).equal(to: NBTByte(84)))
		XCTAssertFalse(NBTShort(230).equal(to: NBTShort(182)))
		XCTAssertFalse(NBTInt(29301).equal(to: NBTInt(4203)))
		XCTAssertFalse(NBTLong(2939184920).equal(to: NBTLong(928059182)))
		XCTAssertFalse(NBTFloat(923.324).equal(to: NBTFloat(1920.432)))
		XCTAssertFalse(NBTDouble(93102894.23).equal(to: NBTDouble(129.212)))
		XCTAssertFalse(NBTString("Hello").equal(to: NBTString("World")))

		XCTAssertFalse(NBTList(genericType: .float, elements: [NBTFloat(9012384.0), NBTFloat(12842.12)])
			.equal(to: NBTList(genericType: .float, elements: [NBTFloat(12842.12), NBTFloat(9012384.0)])))
		XCTAssertFalse(NBTList(genericType: .float, elements: [NBTFloat(9012384.0), NBTFloat(12842.12)])
			.equal(to: NBTList(genericType: .float, elements: [NBTFloat(9012384.0)])))
		XCTAssertFalse(NBTList(genericType: .float, elements: [NBTFloat(9012384.0), NBTFloat(12842.12)])
			.equal(to: NBTList(genericType: .float, elements: [])))
		
		XCTAssertFalse(NBTList(bytes: [0x15, 0x34, 0x12]).equal(to: NBTList(bytes: [0x12, 0x32, 0x51])))
		XCTAssertFalse(NBTList(bytes: [0x15, 0x34, 0x12]).equal(to: NBTList(bytes: [0x15])))
		XCTAssertFalse(NBTList(bytes: [0x15, 0x34, 0x12]).equal(to: NBTList(bytes: [])))
		
		XCTAssertFalse(NBTList(ints: [0x153, 0x34223, 0x121]).equal(to: NBTList(ints: [0x152, 0x12112, 0x342])))
		XCTAssertFalse(NBTList(ints: [0x155, 0x34423, 0x123]).equal(to: NBTList(ints: [0x155])))
		XCTAssertFalse(NBTList(ints: [0x151, 0x34323, 0x124]).equal(to: NBTList(ints: [])))
		
		XCTAssertFalse(NBTList(longs: [0x15341344, 0x34223425, 0x121234]).equal(to: NBTList(longs: [0x152134134, 0x121234232, 0x3424674])))
		XCTAssertFalse(NBTList(longs: [0x1551343, 0x34413413, 0x1231345]).equal(to: NBTList(longs: [0x34413413])))
		XCTAssertFalse(NBTList(longs: [0x15132, 0x3434567, 0x1244567]).equal(to: NBTList(longs: [])))
		
		XCTAssertFalse(NBTCompound(contents: ["Hello": "World!"])
			.equal(to: NBTCompound(contents: ["Hello": "World?"])))
		XCTAssertFalse(NBTCompound(contents: ["Hello": "World!"])
			.equal(to: NBTCompound(contents: ["HelloNot": "World!"])))
		XCTAssertFalse(NBTCompound(contents: ["Hello": "World!"])
			.equal(to: NBTCompound(contents: ["Hello": "World!", "There": NBTFloat(43.1234)])))
		XCTAssertFalse(NBTCompound(contents: ["Hello": "World!"])
			.equal(to: NBTCompound(contents: [:])))
		
		// End tag cannot be unequal to itself
	}
}
