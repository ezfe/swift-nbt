//
//  NBTEncoder.swift
//  
//
//  Created by Ezekiel Elin on 1/21/23.
//

import Foundation

public struct NBTEncoder {
	public init() { }
	
	public func encode<T: Encodable>(_ value: T) throws -> NBTStructure {
		let encoder = _NBTEncoder()
		try value.encode(to: encoder)
		return encoder.storage().nbt
	}
}

class _NBTEncoder: Encoder {
	var _storage: _NBTEncodingStorage
	var codingPath: [CodingKey]
	let userInfo: [CodingUserInfoKey : Any] = [:]

	init(to encodedData: _NBTEncodingStorage = _NBTEncodingStorage(), with codingPath: [CodingKey] = []) {
		self._storage = encodedData
		self.codingPath = codingPath
	}
	
	func storage() -> _NBTEncodingStorage {
		return _storage
	}
	
	func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
		return KeyedEncodingContainer(NBTKeyedEncoding<Key>(referencing: self))
	}
	
	func unkeyedContainer() -> UnkeyedEncodingContainer {
		return NBTUnkeyedEncoding(referencing: self)
	}
	
	func singleValueContainer() -> SingleValueEncodingContainer {
		return NBTSingleValueEncoding(referencing: self)
	}
}

fileprivate struct NBTKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {
	let encoder: _NBTEncoder
	var codingPath: [CodingKey]

	init(referencing encoder: _NBTEncoder) {
		self.encoder = encoder
		self.codingPath = encoder.codingPath
	}
		
	mutating func encodeNil(forKey key: Key) throws {
		try encoder.storage().encodeNil(forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Bool, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: String, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Double, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Float, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Int, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Int8, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Int16, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Int32, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: Int64, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: UInt, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: UInt8, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: UInt16, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: UInt32, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode(_ value: UInt64, forKey key: Key) throws {
		try encoder.storage().encode(value, forKey: codingPath + [key])
	}
	
	mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
		let originalPath = encoder.codingPath
		defer { encoder.codingPath = originalPath }
		encoder.codingPath.append(key)
		try value.encode(to: encoder)
	}
	
	mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		var container = NBTKeyedEncoding<NestedKey>(referencing: encoder)
		container.codingPath.append(key)
		return KeyedEncodingContainer(container)
	}
	
	mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		var container = NBTUnkeyedEncoding(referencing: encoder)
		container.codingPath.append(key)
		return container
	}
	
	mutating func superEncoder() -> Encoder {
		let key = Key(stringValue: "super")!
		return superEncoder(forKey: key)
	}
	
	mutating func superEncoder(forKey key: Key) -> Encoder {
		return _NBTReferencingEncoder(referencing: encoder, with: codingPath + [key])
	}
}

fileprivate struct NBTUnkeyedEncoding: UnkeyedEncodingContainer {
	
	let encoder: _NBTEncoder
	var codingPath: [CodingKey]
	var count: Int = 0

	init(referencing encoder: _NBTEncoder) {
		self.encoder = encoder
		self.codingPath = encoder.codingPath
	}
	
	mutating func nextIndexedKey() -> CodingKey {
		let nextCodingKey = IndexedCodingKey(intValue: count)!
		count += 1
		return nextCodingKey
	}
	
	struct IndexedCodingKey: CodingKey {
		let intValue: Int?
		let stringValue: String

		init?(intValue: Int) {
			self.intValue = intValue
			self.stringValue = intValue.description
		}

		init?(stringValue: String) {
			return nil
		}
	}
	
	mutating func encodeNil() throws {
		try encoder.storage().encodeNil(forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Bool) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: String) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Double) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Float) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Int) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Int8) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Int16) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Int32) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: Int64) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: UInt) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: UInt8) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: UInt16) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: UInt32) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode(_ value: UInt64) throws {
		try encoder.storage().encode(value, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func encode<T: Encodable>(_ value: T) throws {
		let originalPath = encoder.codingPath
		defer { encoder.codingPath = originalPath }
		encoder.codingPath.append(nextIndexedKey())
		try value.encode(to: encoder)
	}
	
	mutating func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
		var container = NBTKeyedEncoding<NestedKey>(referencing: encoder)
		container.codingPath.append(nextIndexedKey())
		return KeyedEncodingContainer(container)
	}
	
	mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		var container = NBTUnkeyedEncoding(referencing: encoder)
		container.codingPath.append(nextIndexedKey())
		return container
	}
	
	mutating func superEncoder() -> Encoder {
		return _NBTReferencingEncoder(referencing: encoder, with: encoder.codingPath + [nextIndexedKey()])
	}
}

fileprivate struct NBTSingleValueEncoding: SingleValueEncodingContainer {
	
	let encoder: _NBTEncoder
	var codingPath: [CodingKey]

	init(referencing encoder: _NBTEncoder) {
		self.encoder = encoder
		self.codingPath = encoder.codingPath
	}
		
	mutating func encodeNil() throws {
		try encoder.storage().encodeNil(forKey: codingPath)
	}
	
	mutating func encode(_ value: Bool) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: String) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Double) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Float) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Int) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Int8) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Int16) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Int32) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: Int64) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: UInt) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: UInt8) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: UInt16) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: UInt32) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode(_ value: UInt64) throws {
		try encoder.storage().encode(value, forKey: codingPath)
	}
	
	mutating func encode<T: Encodable>(_ value: T) throws {
		let originalPath = encoder.codingPath
		defer { encoder.codingPath = originalPath }
		try value.encode(to: encoder)
	}
}

enum EncodingError: Error {
	case forbiddenType(String)
}
