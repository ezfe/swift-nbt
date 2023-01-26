import XCTest
@testable import MinecraftNBT
@testable import DataTools

final class ValuesTests: XCTestCase {
	func testAppendToAccumulator() {
		let accumulator = DataAccumulator()
		
		ByteValue(value: 0x3F).append(to: accumulator)
		ShortValue(value: 0x4629).append(to: accumulator)
		IntValue(value: 0x0C771D5E).append(to: accumulator)
		LongValue(value: 0x07274DAAD884B926).append(to: accumulator)
		FloatValue(value: 9012384.0).append(to: accumulator)
		DoubleValue(value: 80912894123122320).append(to: accumulator)
		StringValue(value: "Hello").append(to: accumulator)
		GenericList(genericType: .float, elements: []).append(to: accumulator)
		ByteArray(elements: []).append(to: accumulator)
		IntArray(elements: []).append(to: accumulator)
		LongArray(elements: []).append(to: accumulator)
		Compound(contents: []).append(to: accumulator)
		End().append(to: accumulator)

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
		XCTAssertEqual(accumulator.data, Data(bytes))
	}
	
	func testBasicEquality() {
		let byte = ByteValue(value: 0x3F)
		let short = ShortValue(value: 0x4629)
		let int = IntValue(value: 0x0C771D5E)
		let long = LongValue(value: 0x07274DAAD884B926)
		let float = FloatValue(value: 9012384.0)
		let double = DoubleValue(value: 80912894123122320)
		let string = StringValue(value: "Hello")
		let list = GenericList(genericType: .float, elements: [FloatValue(value: 9012384.0), FloatValue(value: 12842.12)])
		let byteArray = ByteArray(elements: [0x12, 0x34, 0x12])
		let intArray = IntArray(elements: [0x153, 0x34223, 0x121])
		let longArray = LongArray(elements: [0x15341344, 0x34223425, 0x121234])
		let compound = Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!"))])
		let end = End()
		
		let elements: [any Tag] = [byte, short, int, long, float, double, string, list, byteArray, intArray, longArray, compound, end]
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
		XCTAssertFalse(ByteValue(value: 5).equal(to: ByteValue(value: 84)))
		XCTAssertFalse(ShortValue(value: 230).equal(to: ShortValue(value: 182)))
		XCTAssertFalse(IntValue(value: 29301).equal(to: IntValue(value: 4203)))
		XCTAssertFalse(LongValue(value: 2939184920).equal(to: LongValue(value: 928059182)))
		XCTAssertFalse(FloatValue(value: 923.324).equal(to: FloatValue(value: 1920.432)))
		XCTAssertFalse(DoubleValue(value: 93102894.23).equal(to: DoubleValue(value: 129.212)))
		XCTAssertFalse(StringValue(value: "Hello").equal(to: StringValue(value: "World")))

		XCTAssertFalse(GenericList(genericType: .float, elements: [FloatValue(value: 9012384.0), FloatValue(value: 12842.12)])
			.equal(to: GenericList(genericType: .float, elements: [FloatValue(value: 12842.12), FloatValue(value: 9012384.0)])))
		XCTAssertFalse(GenericList(genericType: .float, elements: [FloatValue(value: 9012384.0), FloatValue(value: 12842.12)])
			.equal(to: GenericList(genericType: .float, elements: [FloatValue(value: 9012384.0)])))
		XCTAssertFalse(GenericList(genericType: .float, elements: [FloatValue(value: 9012384.0), FloatValue(value: 12842.12)])
			.equal(to: GenericList(genericType: .float, elements: [])))
		
		XCTAssertFalse(ByteArray(elements: [0x15, 0x34, 0x12]).equal(to: ByteArray(elements: [0x12, 0x32, 0x51])))
		XCTAssertFalse(ByteArray(elements: [0x15, 0x34, 0x12]).equal(to: ByteArray(elements: [0x15])))
		XCTAssertFalse(ByteArray(elements: [0x15, 0x34, 0x12]).equal(to: ByteArray(elements: [])))
		
		XCTAssertFalse(IntArray(elements: [0x153, 0x34223, 0x121]).equal(to: IntArray(elements: [0x152, 0x12112, 0x342])))
		XCTAssertFalse(IntArray(elements: [0x155, 0x34423, 0x123]).equal(to: IntArray(elements: [0x155])))
		XCTAssertFalse(IntArray(elements: [0x151, 0x34323, 0x124]).equal(to: IntArray(elements: [])))
		
		XCTAssertFalse(LongArray(elements: [0x15341344, 0x34223425, 0x121234]).equal(to: LongArray(elements: [0x152134134, 0x121234232, 0x3424674])))
		XCTAssertFalse(LongArray(elements: [0x1551343, 0x34413413, 0x1231345]).equal(to: LongArray(elements: [0x34413413])))
		XCTAssertFalse(LongArray(elements: [0x15132, 0x3434567, 0x1244567]).equal(to: LongArray(elements: [])))
		
		XCTAssertFalse(Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!"))])
			.equal(to: Compound(contents: [.init(key: "Hello", value: StringValue(value: "World?"))])))
		XCTAssertFalse(Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!"))])
			.equal(to: Compound(contents: [.init(key: "HelloNot", value: StringValue(value: "World!"))])))
		XCTAssertFalse(Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!"))])
			.equal(to: Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!")), .init(key: "There", value: FloatValue(value: 43.1234))])))
		XCTAssertFalse(Compound(contents: [.init(key: "Hello", value: StringValue(value: "World!"))])
			.equal(to: Compound(contents: [])))
		
		// End tag cannot be unequal to itself
	}
}
