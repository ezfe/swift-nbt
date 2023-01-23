//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/21/23.
//

/*
import Foundation

class NBTEncoder {
	public func encode<T: Encodable>(_ value: T) throws -> String {
		
	}
}

struct NBTEncoding: Encoder {
	fileprivate final class NBTWrapper {
		var nbt: Compound = Compound()
	}
	
	fileprivate var data: NBTWrapper
	
	fileprivate init(to encodedData: NBTWrapper = NBTWrapper()) {
		self.data = encodedData
	}
	
	var codingPath: [CodingKey] = []
	let userInfo: [CodingUserInfoKey : Any] = [:]
	
	func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
		var container = NBTKeyedEncoding<Key>(to: data)
		container.codingPath = codingPath
		return KeyedEncodingContainer(container)
	}
	
//	func unkeyedContainer() -> UnkeyedEncodingContainer {
//		var container = NBTUnkeyedEncoding(to: data)
//		container.codingPath = codingPath
//		return container
//	}
//
//	func singleValueContainer() -> SingleValueEncodingContainer {
//		var container = NBTSingleValueEncoding(to: data)
//		container.codingPath = codingPath
//		return container
//	}
}

fileprivate struct NBTKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {
	private let data: NBTEncoding.NBTWrapper
	
	init(to data: NBTEncoding.NBTWrapper) {
		self.data = data
	}

	var codingPath: [CodingKey] = []
	
	mutating func encodeNil(forKey key: Key) throws {
		throw EncodingError.forbiddenType("nil cannot be encoded to NBT")
	}
	
	mutating func encode(_ value: Bool, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int8(value ? 1 : 0))
	}
	
	mutating func encode(_ value: String, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .string(value))
	}
	
	mutating func encode(_ value: Double, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .float64(value))
	}
	
	mutating func encode(_ value: Float, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .float32(value))
	}
	
	mutating func encode(_ value: Int, forKey key: Key) throws {
		try self.encode(Int64(value), forKey: key)
	}
	
	mutating func encode(_ value: Int8, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int8(value))
	}
	
	mutating func encode(_ value: Int16, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int16(value))
	}
	
	mutating func encode(_ value: Int32, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int32(value))
	}
	
	mutating func encode(_ value: Int64, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int64(value))
	}
	
	mutating func encode(_ value: UInt, forKey key: Key) throws {
		try self.encode(UInt64(value), forKey: key)
	}
	
	mutating func encode(_ value: UInt8, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int16(Int16(value)))
	}
	
	mutating func encode(_ value: UInt16, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int32(Int32(value)))
	}
	
	mutating func encode(_ value: UInt32, forKey key: Key) throws {
		data.nbt[key.stringValue] = Value(value: .int64(Int64(value)))
	}
	
	mutating func encode(_ value: UInt64, forKey key: Key) throws {
		if 0...UInt64(Int64.max) ~= value {
			data.nbt[key.stringValue] = Value(value: .int64(Int64(value)))
		} else {
			print("Warning: Storing UInt value `\(value)` as `float64`")
			data.nbt[key.stringValue] = Value(value: .float64(Double(value)))
		}
	}
	
	mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
		<#code#>
	}
	
	mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		<#code#>
	}
	
	mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		<#code#>
	}
	
	mutating func superEncoder() -> Encoder {
		<#code#>
	}
	
	mutating func superEncoder(forKey key: Key) -> Encoder {
		<#code#>
	}

}

enum EncodingError: Error {
	case forbiddenType(String)
}
*/
