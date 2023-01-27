//
//  SpecializedArrays.swift
//  
//
//  Created by Ezekiel Elin on 1/26/23.
//

import DataTools

protocol SpecializedArray: AnyList {
	associatedtype SType where SType: DataStreamReadable & DataAccumulatorWritable
	
	var elementType: NBTTagType { get }
	var elements: [SType] { get set }
	var nbtValues: [any SpecializedValue] { get }
	
	init(elements: [SType])
}

extension SpecializedArray {
	public static func make(with stream: DataStream) -> Self? {
		guard let length = stream.read(Int32.self) else {
			return nil
		}
		
		var storage = [SType]()
		storage.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			guard let value = stream.read(SType.self) else {
				return nil
			}
			storage.append(value)
		}
		
		return .init(elements: storage)
	}
	
	public func append(to accumulator: DataAccumulator) {
		Int32(self.elements.count).append(to: accumulator)
		self.elements.forEach { $0.append(to: accumulator) }
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[list:"
		for value in self.elements {
			result += "\n\(makeIndent(indentation)) > [\(elementType.description):\(value)]"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}
}

public struct ByteArray: SpecializedArray {
	public let type = NBTTagType.byteArray
	public let elementType = NBTTagType.byte
	public var elements: [Int8]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { ByteValue(value: $0) }
	}
}

public struct IntArray: SpecializedArray {
	public let type = NBTTagType.intArray
	public let elementType = NBTTagType.int
	public var elements: [Int32]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { IntValue(value: $0) }
	}
}

public struct LongArray: SpecializedArray {
	public let type = NBTTagType.longArray
	public let elementType = NBTTagType.long
	public var elements: [Int64]
	public var nbtValues: [any SpecializedValue] {
		return elements.map { LongValue(value: $0) }
	}
}
