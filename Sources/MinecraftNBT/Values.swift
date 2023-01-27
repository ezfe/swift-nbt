//
//  File.swift
//  
//
//  Created by Ezekiel on 7/4/20.
//

import Foundation
import DataTools

// MARK:-

public protocol Tag: DataAccumulatorWritable, CustomStringConvertible, Equatable {
	var type: NBTTagType { get }
	
	func description(indentation: UInt) -> String
}

extension Tag {
	internal func makeIndent(_ quantity: UInt) -> String {
		return String(repeating: " ", count: 3 * Int(quantity))
	}
	
	public func equal(to otherTag: (any Tag)?) -> Bool {
		guard let otherTag else {
			return false
		}

		guard self.type == otherTag.type else {
			return false
		}
		
		switch self.type {
			case .end:
				return (self as? End) == (otherTag as? End)
			case .byte:
				return (self as? ByteValue) == (otherTag as? ByteValue)
			case .short:
				return (self as? ShortValue) == (otherTag as? ShortValue)
			case .int:
				return (self as? IntValue) == (otherTag as? IntValue)
			case .long:
				return (self as? LongValue) == (otherTag as? LongValue)
			case .float:
				return (self as? FloatValue) == (otherTag as? FloatValue)
			case .double:
				return (self as? DoubleValue) == (otherTag as? DoubleValue)
			case .byteArray:
				return (self as? ByteArray) == (otherTag as? ByteArray)
			case .intArray:
				return (self as? IntArray) == (otherTag as? IntArray)
			case .longArray:
				return (self as? LongArray) == (otherTag as? LongArray)
			case .string:
				return (self as? StringValue) == (otherTag as? StringValue)
			case .list:
				return (self as? GenericList) == (otherTag as? GenericList)
			case .compound:
				return (self as? Compound) == (otherTag as? Compound)
		}
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
		return "[end]"
	}
}

// MARK:- Compound

public struct Compound: Tag, DataStreamReadable, DataAccumulatorWritable {
	public struct Pair: Equatable {
		public let key: String
		public let value: any Tag
		
		public static func ==(lhs: Pair, rhs: Pair) -> Bool {
			guard lhs.key == rhs.key else {
				return false
			}
			return lhs.value.equal(to: rhs.value)
		}
	}
	
	public let type = NBTTagType.compound
	
	public var contents: [Pair]
	
	public init() {
		self.contents = []
	}
	
	public init(contents: [Pair]) {
		self.contents = contents
	}
	
	public subscript(key: String) -> (any Tag)? {
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
	
	public static func make(with stream: DataStream) -> Compound? {
		var contents = [String: any Tag]()
		
		// TODO: make this loop nicer
		while true {
			guard let type = stream.read(Int8.self),
					let type = NBTTagType(rawValue: type) else {
				print("Failed to find type: ")
				break
			}
			
			if type == .end {
				break
			}
			
			guard let name = stream.read(String.self) else {
				return nil
			}
			let payload = stream.readPayload(type: type)
			
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
		var result = "[dict:"
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

public func equal(_ lhs: (any Tag)?, _ rhs: (any Tag)?) -> Bool {
	if let lhs, let rhs {
		return lhs.equal(to: rhs)
	} else {
		return lhs == nil && rhs == nil
	}
}
