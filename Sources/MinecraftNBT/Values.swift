//
//  File.swift
//  
//
//  Created by Ezekiel on 7/4/20.
//

import Foundation
import DataTools

func readPayload(type: NBTTagType, stream: DataStream) -> Tag {
	switch type {
		case .byte:
			return ByteValue(value: stream.read(Int8.self))
		case .short:
			return ShortValue(value: stream.read(Int16.self))
		case .int:
			return IntValue(value: stream.read(Int32.self))
		case .long:
			return LongValue(value: stream.read(Int64.self))
		case .float:
			return FloatValue(value: stream.read(Float32.self))
		case .double:
			return DoubleValue(value: stream.read(Float64.self))
			
		case .string:
			return StringValue(value: stream.read(String.self))
			
		case .list:
			return GenericList.make(with: stream)
			
		case .byteArray:
			return ByteArray.make(with: stream)
		case .intArray:
			return IntArray.make(with: stream)
		case .longArray:
			return LongArray.make(with: stream)
			
		case .compound:
			return Compound.make(with: stream)
			
		case .end:
			return End()
	}
}

// MARK:-

public protocol Tag: DataAccumulatorWritable, CustomStringConvertible {
	var type: NBTTagType { get }
	
	func description(indentation: UInt) -> String
}

extension Tag {
	internal func makeIndent(_ quantity: UInt) -> String {
		return String(repeating: " ", count: 3 * Int(quantity))
	}
	
	public var description: String {
		return self.description(indentation: 0)
	}
}

struct End: Tag {
	let type = NBTTagType.end
	
	func append(to accumulator: DataAccumulator) {
		self.type.rawValue.append(to: accumulator)
	}
	
	func description(indentation: UInt) -> String {
		return makeIndent(indentation) + "[Tag:End]"
	}
}

// MARK:- Lists

public protocol AnyList: Tag, DataStreamReadable {
	associatedtype Element
	var elements: [Element] { get }
}

public struct GenericList: AnyList {
	public let type = NBTTagType.list
	
	public var genericType: NBTTagType
	public var elements: [Tag]
	
	public static func make(with stream: DataStream) -> GenericList {
		guard let type = NBTTagType(rawValue: stream.read(Int8.self)) else {
			print("Failed to find type")
			exit(4)
		}
		
		let length = stream.read(Int32.self)
		
		var elements = [Tag]()
		elements.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			elements.append(readPayload(type: type, stream: stream))
		}
		
		return GenericList(genericType: type, elements: elements)
	}
	
	public func append(to accumulator: DataAccumulator) {
		self.genericType.rawValue.append(to: accumulator)
		Int32(self.elements.count).append(to: accumulator)
		
		for tag in self.elements {
			tag.append(to: accumulator)
		}
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[List:"
		for tag in self.elements {
			result += "\n\(makeIndent(indentation)) > \(tag.description(indentation: indentation + 1))"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}
}

protocol SpecializedArray: AnyList {
	associatedtype SType where SType: DataStreamReadable & DataAccumulatorWritable
	
	var elements: [SType] { get set }
	var nbtValues: [any SpecializedValue] { get }
	
	init(elements: [SType])
}

public struct ByteArray: SpecializedArray {
	public let type = NBTTagType.byteArray
	public var elements: [Int8]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { ByteValue(value: $0) }
	}
}

public struct IntArray: SpecializedArray {
	public let type = NBTTagType.intArray
	public var elements: [Int32]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { IntValue(value: $0) }
	}
}

public struct LongArray: SpecializedArray {
	public let type = NBTTagType.longArray
	public var elements: [Int64]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { LongValue(value: $0) }
	}
}

extension SpecializedArray {
	public static func make(with stream: DataStream) -> Self {
		let length = stream.read(Int32.self)
		
		var storage = [SType]()
		storage.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			storage.append(stream.read(SType.self))
		}
		
		return .init(elements: storage)
	}
	
	public func append(to accumulator: DataAccumulator) {
		Int32(self.elements.count).append(to: accumulator)
		self.elements.forEach { $0.append(to: accumulator) }
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[List:"
		for value in self.elements {
			result += "\n\(makeIndent(indentation)) > [\(type.description):\(value)]"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}

}

// MARK:- Compound

public struct Compound: Tag, DataStreamReadable, DataAccumulatorWritable {
	public struct Pair {
		public let key: String
		public let value: Tag
	}
	
	public let type = NBTTagType.compound
	
	public var contents: [Pair]
	
	public init() {
		self.contents = []
	}
	
	public init(contents: [Pair]) {
		self.contents = contents
	}
	
	public subscript(key: String) -> Tag? {
		set {
			self.contents.removeAll { $0.key == key }
			if let newValue = newValue {
				self.contents.append(Pair(key: key, value: newValue))
			}
		}
		get {
			return self.contents.first { $0.key == key }?.value
		}
	}
	
	public static func make(with stream: DataStream) -> Compound {
		var contents = [String: Tag]()
		
		// TODO: make this loop nicer
		while true {
			guard let type = NBTTagType(rawValue: stream.read(Int8.self)) else {
				print("Failed to find type: ")
				break
			}
			
			if type == .end {
				break
			}
			
			let name = stream.read(String.self)
			let payload = readPayload(type: type, stream: stream)
			
			if let _ = payload as? End {
				break
			}
			
			contents[name] = payload
		}
		
		return Compound(contents: contents
			.map({ Pair(key: $0.key, value: $0.value) })
			.sorted(by: { $0.key > $1.key }))
	}
	
	public func append(to accumulator: DataAccumulator) {
		for pair in self.contents {
			let name = pair.key
			let tag = pair.value
			
			tag.type.rawValue.append(to: accumulator)
			name.append(to: accumulator)
			tag.append(to: accumulator)
		}
		End().append(to: accumulator)
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[Dict:"
		for pair in self.contents {
			result += "\n\(makeIndent(indentation)) > `\(pair.key)` -> \(pair.value.description(indentation: indentation + 2))"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}
}

// MARK:- Generic

public protocol SpecializedValue: Tag {
	associatedtype SType where SType: DataAccumulatorWritable
	
	var value: SType { get set }
	
	init(value: SType)
}

extension SpecializedValue {
	public func append(to accumulator: DataAccumulator) {
		value.append(to: accumulator)
	}
	
	public func description(indentation: UInt) -> String {
		return "[\(type.description):\(value)]"
	}
}

public struct ByteValue: SpecializedValue {
	public var type = NBTTagType.byte
	
	public var value: Int8
	
	public init(value: Int8) {
		self.value = value
	}
}

public struct ShortValue: SpecializedValue {
	public var type = NBTTagType.short
	
	public var value: Int16
	
	public init(value: Int16) {
		self.value = value
	}
}

public struct IntValue: SpecializedValue {
	public var type = NBTTagType.int
	
	public var value: Int32
	
	public init(value: Int32) {
		self.value = value
	}
}

public struct LongValue: SpecializedValue {
	public var type = NBTTagType.long
	
	public var value: Int64
	
	public init(value: Int64) {
		self.value = value
	}
}

public struct FloatValue: SpecializedValue {
	public var type = NBTTagType.float
	
	public var value: Float32
	
	public init(value: Float32) {
		self.value = value
	}
}

public struct DoubleValue: SpecializedValue {
	public var type = NBTTagType.double
	
	public var value: Float64
	
	public init(value: Float64) {
		self.value = value
	}
}

public struct StringValue: SpecializedValue {
	public var type = NBTTagType.string
	
	public var value: String
	
	public init(value: String) {
		self.value = value
	}
}

// MARK: Resizability

public protocol Int8Resizable {
	var int8: Int8 { get }
}
public protocol Int16Resizable {
	var int16: Int16 { get }
}
public protocol Int32Resizable {
	var int32: Int32 { get }
}
public protocol Int64Resizable {
	var int64: Int64 { get }
}

public protocol UInt8Resizable {
	var uint8: UInt8 { get }
}
public protocol UInt16Resizable {
	var uint16: UInt16 { get }
}
public protocol UInt32Resizable {
	var uint32: UInt32 { get }
}
public protocol UInt64Resizable {
	var uint64: UInt64 { get }
}

extension ByteValue: Int8Resizable, Int16Resizable, Int32Resizable, Int64Resizable {
	public var int8: Int8 { value }
	public var int16: Int16 { Int16(value) }
	public var int32: Int32 { Int32(value) }
	public var int64: Int64 { Int64(value) }
}
extension ByteValue: UInt8Resizable, UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint8: UInt8 { UInt8(value) }
	public var uint16: UInt16 { UInt16(value) }
	public var uint32: UInt32 { UInt32(value) }
	public var uint64: UInt64 { UInt64(value) }
}

extension ShortValue: Int16Resizable, Int32Resizable, Int64Resizable {
	public var int16: Int16 { value }
	public var int32: Int32 { Int32(value) }
	public var int64: Int64 { Int64(value) }
}
extension ShortValue: UInt8Resizable, UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint8: UInt8 { UInt8(value) }
	public var uint16: UInt16 { UInt16(value) }
	public var uint32: UInt32 { UInt32(value) }
	public var uint64: UInt64 { UInt64(value) }
}

extension IntValue: Int32Resizable, Int64Resizable {
	public var int32: Int32 { value }
	public var int64: Int64 { Int64(value) }
}
extension IntValue: UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint16: UInt16 { UInt16(value) }
	public var uint32: UInt32 { UInt32(value) }
	public var uint64: UInt64 { UInt64(value) }
}

extension LongValue: Int64Resizable {
	public var int64: Int64 { value }
}
extension LongValue: UInt32Resizable, UInt64Resizable {
	public var uint32: UInt32 { UInt32(value) }
	public var uint64: UInt64 { UInt64(value) }
}
