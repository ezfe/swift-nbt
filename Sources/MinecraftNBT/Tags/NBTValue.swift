//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/27/23.
//

import DataTools
import OrderedCollections

public protocol NBTLeafValue: NBTTag, DataStreamReadable, CustomStringConvertible {
	
}

extension NBTLeafValue {
	public var children: OrderedDictionary<String, any NBTTag>? { nil }
	public func description(indentation: UInt = 0) -> String {
		return "[\(type):\(self)]"
	}
}

// MARK: Type Aliases

public typealias NBTByte = Int8
public typealias NBTShort = Int16
public typealias NBTInt = Int32
public typealias NBTLong = Int64

public typealias NBTFloat = Float32
public typealias NBTDouble = Float64

public typealias NBTString = String

// MARK: Conformance

extension NBTByte: NBTLeafValue {
	public var type: NBTTagType { .byte }
	public var icon: String { "number" }
}
extension NBTShort: NBTLeafValue {
	public var type: NBTTagType { .short }
	public var icon: String { "number" }
}
extension NBTInt: NBTLeafValue {
	public var type: NBTTagType { .int }
	public var icon: String { "number" }
}
extension NBTLong: NBTLeafValue {
	public var type: NBTTagType { .long }
	public var icon: String { "number" }
}

extension NBTFloat: NBTLeafValue {
	public var type: NBTTagType { .float }
	public var icon: String { "number" }
}
extension NBTDouble: NBTLeafValue {
	public var type: NBTTagType { .double }
	public var icon: String { "number" }
}

extension NBTString: NBTLeafValue {
	public var type: NBTTagType { .string }
	public var icon: String { "textformat" }
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

extension NBTByte: Int8Resizable, Int16Resizable, Int32Resizable, Int64Resizable {
	public var int8: Int8 { self }
	public var int16: Int16 { Int16(self) }
	public var int32: Int32 { Int32(self) }
	public var int64: Int64 { Int64(self) }
}
extension NBTByte: UInt8Resizable, UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint8: UInt8 { UInt8(self) }
	public var uint16: UInt16 { UInt16(self) }
	public var uint32: UInt32 { UInt32(self) }
	public var uint64: UInt64 { UInt64(self) }
}

extension NBTShort: Int16Resizable, Int32Resizable, Int64Resizable {
	public var int16: Int16 { self }
	public var int32: Int32 { Int32(self) }
	public var int64: Int64 { Int64(self) }
}
extension NBTShort: UInt8Resizable, UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint8: UInt8 { UInt8(self) }
	public var uint16: UInt16 { UInt16(self) }
	public var uint32: UInt32 { UInt32(self) }
	public var uint64: UInt64 { UInt64(self) }
}

extension NBTInt: Int32Resizable, Int64Resizable {
	public var int32: Int32 { self }
	public var int64: Int64 { Int64(self) }
}
extension NBTInt: UInt16Resizable, UInt32Resizable, UInt64Resizable {
	public var uint16: UInt16 { UInt16(self) }
	public var uint32: UInt32 { UInt32(self) }
	public var uint64: UInt64 { UInt64(self) }
}

extension NBTLong: Int64Resizable {
	public var int64: Int64 { self }
}
extension NBTLong: UInt32Resizable, UInt64Resizable {
	public var uint32: UInt32 { UInt32(self) }
	public var uint64: UInt64 { UInt64(self) }
}
