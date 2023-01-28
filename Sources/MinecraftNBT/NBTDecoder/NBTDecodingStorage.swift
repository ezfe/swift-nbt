//
//  NBTDecodingStorage.swift
//  
//
//  Created by Ezekiel Elin on 1/24/23.
//

import Foundation

class _NBTDecodingStorage {
	private(set) var nbt: NBTStructure = NBTStructure()
	
	init(nbt: NBTStructure) {
		self.nbt = nbt
	}
	
	func decodeNil(forKey key: [CodingKey]) throws -> Bool {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		return tag == nil
	}
	
	func decode(_ type: Bool.Type, forKey key: [CodingKey]) throws -> Bool {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? NBTByte {
			return tag == 1
		} else if let tag {
			throw DecodingError.incorrectType("Expected `boolean`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `boolean`, found nothing at `\(key)`")
		}
	}
	
	func decode(_ type: String.Type, forKey key: [CodingKey]) throws -> String {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? NBTString {
			return tag
		} else if let tag {
			throw DecodingError.incorrectType("Expected `string`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `string`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Double.Type, forKey key: [CodingKey]) throws -> Double {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? NBTDouble {
			return tag
		} else if let tag {
			throw DecodingError.incorrectType("Expected `double`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `double`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Float.Type, forKey key: [CodingKey]) throws -> Float {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? NBTFloat {
			return tag
		} else if let tag {
			throw DecodingError.incorrectType("Expected `float`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `float`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Int.Type, forKey key: [CodingKey]) throws -> Int {
		return try Int(self.decode(Int64.self, forKey: key))
	}

	func decode(_ type: Int8.Type, forKey key: [CodingKey]) throws -> Int8 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? Int8Resizable {
			return tag.int8
		} else if let tag {
			throw DecodingError.incorrectType("Expected `int8`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `int8`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Int16.Type, forKey key: [CodingKey]) throws -> Int16 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? Int16Resizable {
			return tag.int16
		} else if let tag {
			throw DecodingError.incorrectType("Expected `int16`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `int16`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Int32.Type, forKey key: [CodingKey]) throws -> Int32 {
		let key = key.map { $0.stringValue }
		let tag = try self.nbt.read(key)
		if let tag = tag as? Int32Resizable {
			return tag.int32
		} else if let tag {
			throw DecodingError.incorrectType("Expected `int32`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `int32`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: Int64.Type, forKey key: [CodingKey]) throws -> Int64 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? Int64Resizable {
			return tag.int64
		} else if let tag {
			throw DecodingError.incorrectType("Expected `int64`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `int64`, found nothing at `\(key)`")
		}
	}
	
	func decode(_ type: UInt.Type, forKey key: [CodingKey]) throws -> UInt {
		return try UInt(self.decode(UInt64.self, forKey: key))
	}

	func decode(_ type: UInt8.Type, forKey key: [CodingKey]) throws -> UInt8 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? UInt8Resizable {
			return tag.uint8
		} else if let tag {
			throw DecodingError.incorrectType("Expected `uint8`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `uint8`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: UInt16.Type, forKey key: [CodingKey]) throws -> UInt16 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? UInt16Resizable {
			return tag.uint16
		} else if let tag {
			throw DecodingError.incorrectType("Expected `uint16`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `uint16`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: UInt32.Type, forKey key: [CodingKey]) throws -> UInt32 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? UInt32Resizable {
			return tag.uint32
		} else if let tag {
			throw DecodingError.incorrectType("Expected `uint32`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `uint32`, found nothing at `\(key)`")
		}
	}

	func decode(_ type: UInt64.Type, forKey key: [CodingKey]) throws -> UInt64 {
		let key = key.map { $0.stringValue }
		let tag = try nbt.read(key)
		if let tag = tag as? UInt64Resizable {
			return tag.uint64
		} else if let tag {
			throw DecodingError.incorrectType("Expected `uint64`, found `\(tag)` at `\(key)`")
		} else {
			throw DecodingError.missingValue("Expected `uint64`, found nothing at `\(key)`")
		}
	}
}
