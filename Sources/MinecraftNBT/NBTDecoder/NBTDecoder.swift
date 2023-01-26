//
//  NBTDecoder.swift
//  
//
//  Created by Ezekiel Elin on 1/21/23.
//

import Foundation

public struct NBTDecoder {
	public init() { }
	
	public func decode<T: Decodable>(_ type: T.Type, from nbt: NBTStructure) throws -> T {
		let decoder = _NBTDecoder(nbt: nbt)
		let value = try type.init(from: decoder)
		return value
	}
}

class _NBTDecoder: Decoder {
	var _storage: _NBTDecodingStorage
	var codingPath: [CodingKey]
	let userInfo: [CodingUserInfoKey : Any] = [:]

	init(nbt: NBTStructure, with codingPath: [CodingKey] = []) {
		self._storage = _NBTDecodingStorage(nbt: nbt)
		self.codingPath = codingPath
	}
	
	init(from storage: _NBTDecodingStorage, with codingPath: [CodingKey] = []) {
		self._storage = storage
		self.codingPath = codingPath
	}
	
	func storage() -> _NBTDecodingStorage {
		return _storage
	}
	
	public func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> {
		return KeyedDecodingContainer(NBTKeyedDecoding<Key>(referencing: self))
	}
	
	public func unkeyedContainer() -> UnkeyedDecodingContainer {
		return NBTUnkeyedDecoding(referencing: self)
	}
	
	public func singleValueContainer() -> SingleValueDecodingContainer {
		return NBTSingleValueDecoding(referencing: self)
	}
}

fileprivate struct NBTKeyedDecoding<Key: CodingKey>: KeyedDecodingContainerProtocol {
	let decoder: _NBTDecoder
	var codingPath: [CodingKey]
	
	var tag: (any Tag)? {
		let path = codingPath.map { $0.stringValue }
		return try? decoder.storage().nbt.read(path)
	}
	var allKeys: [Key] {
		if let compound = tag as? Compound {
			return compound.contents.compactMap { Key(stringValue: $0.key) }
		} else {
			return []
		}
	}

	init(referencing encoder: _NBTDecoder) {
		self.decoder = encoder
		self.codingPath = encoder.codingPath
	}
		
	func contains(_ key: Key) -> Bool {
		return decoder.storage().nbt.tag[key.stringValue] != nil
	}
	
	func decodeNil(forKey key: Key) throws -> Bool {
		try decoder.storage().decodeNil(forKey: codingPath + [key])
	}
	
	func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: String.Type, forKey key: Key) throws -> String {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		try decoder.storage().decode(type, forKey: codingPath + [key])
	}
	
	func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
		let originalPath = decoder.codingPath
		defer { decoder.codingPath = originalPath }
		decoder.codingPath.append(key)
		return try type.init(from: decoder)
	}
	
	func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		var container = NBTKeyedDecoding<NestedKey>(referencing: decoder)
		container.codingPath.append(key)
		return KeyedDecodingContainer(container)
	}
	
	func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		var container = NBTUnkeyedDecoding(referencing: decoder)
		container.codingPath.append(key)
		return container
	}
	
	func superDecoder() throws -> Decoder {
		let superKey = Key(stringValue: "super")!
		return try superDecoder(forKey: superKey)
	}
	
	func superDecoder(forKey key: Key) throws -> Decoder {
		return _NBTReferencingDecoder(referencing: decoder, with: codingPath + [key])
	}
}

fileprivate struct NBTUnkeyedDecoding: UnkeyedDecodingContainer {
	let decoder: _NBTDecoder
	var codingPath: [CodingKey]
	var currentIndex: Int
	
	var tag: (any Tag)? {
		let path = codingPath.map { $0.stringValue }
		return try? decoder.storage().nbt.read(path)
	}
	var count: Int? {
		if let list = tag as? any AnyList {
			return list.elements.count
		} else {
			return nil
		}
	}
	var isAtEnd: Bool {
		return currentIndex >= count!
	}


	init(referencing decoder: _NBTDecoder) {
		self.decoder = decoder
		self.currentIndex = 0
		self.codingPath = decoder.codingPath
	}
		
	private mutating func nextIndexedKey() -> CodingKey {
		let nextCodingKey = IndexedCodingKey(intValue: currentIndex)!
		defer { currentIndex += 1 }
		return nextCodingKey
	}
	
	private struct IndexedCodingKey: CodingKey {
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
	
	mutating func decodeNil() throws -> Bool {
		try decoder.storage().decodeNil(forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Bool.Type) throws -> Bool {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: String.Type) throws -> String {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Double.Type) throws -> Double {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Float.Type) throws -> Float {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Int.Type) throws -> Int {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Int8.Type) throws -> Int8 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Int16.Type) throws -> Int16 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Int32.Type) throws -> Int32 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: Int64.Type) throws -> Int64 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: UInt.Type) throws -> UInt {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
		try decoder.storage().decode(type, forKey: codingPath + [nextIndexedKey()])
	}
	
	mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		let originalPath = decoder.codingPath
		defer { decoder.codingPath = originalPath }
		decoder.codingPath.append(nextIndexedKey())
		return try type.init(from: decoder)
	}

	mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		var container = NBTKeyedDecoding<NestedKey>(referencing: decoder)
		container.codingPath.append(nextIndexedKey())
		return KeyedDecodingContainer(container)
	}
	
	mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		var container = NBTUnkeyedDecoding(referencing: decoder)
		container.codingPath.append(nextIndexedKey())
		return container

	}

	mutating func superDecoder() throws -> Decoder {
		return _NBTReferencingDecoder(referencing: decoder, with: decoder.codingPath + [nextIndexedKey()])
	}
}

fileprivate struct NBTSingleValueDecoding: SingleValueDecodingContainer {
	let decoder: _NBTDecoder
	var codingPath: [CodingKey]

	init(referencing decoder: _NBTDecoder) {
		self.decoder = decoder
		self.codingPath = decoder.codingPath
	}
	
	func decodeNil() -> Bool {
		return false
	}
	
	func decode(_ type: Bool.Type) throws -> Bool {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: String.Type) throws -> String {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Double.Type) throws -> Double {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Float.Type) throws -> Float {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Int.Type) throws -> Int {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Int8.Type) throws -> Int8 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Int16.Type) throws -> Int16 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Int32.Type) throws -> Int32 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: Int64.Type) throws -> Int64 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: UInt.Type) throws -> UInt {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: UInt8.Type) throws -> UInt8 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: UInt16.Type) throws -> UInt16 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: UInt32.Type) throws -> UInt32 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode(_ type: UInt64.Type) throws -> UInt64 {
		try decoder.storage().decode(type, forKey: codingPath)
	}
	
	func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		let originalPath = decoder.codingPath
		defer { decoder.codingPath = originalPath }
		return try type.init(from: decoder)
	}
}


enum DecodingError: Error {
	case forbiddenType(String)
	case incorrectType(String)
	case missingValue(String)
	case unkeyedNotFound(String)
}
