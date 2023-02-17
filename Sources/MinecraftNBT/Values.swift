//
//  File.swift
//  
//
//  Created by Ezekiel on 7/4/20.
//

import Foundation
import DataTools
import OrderedCollections

// MARK:-

public protocol Tag: DataAccumulatorWritable, CustomStringConvertible, Equatable, Hashable {
	var type: NBTTagType { get }
	var icon: String { get }
	var children: OrderedDictionary<String, any Tag>? { get }
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
				fatalError("Found unexpected tag type `end`, which is not allowed")
			case .byte:
				return (self as? NBTByte) == (otherTag as? NBTByte)
			case .short:
				return (self as? NBTShort) == (otherTag as? NBTShort)
			case .int:
				return (self as? NBTInt) == (otherTag as? NBTInt)
			case .long:
				return (self as? NBTLong) == (otherTag as? NBTLong)
			case .float:
				return (self as? NBTFloat) == (otherTag as? NBTFloat)
			case .double:
				return (self as? NBTDouble) == (otherTag as? NBTDouble)
			case .string:
				return (self as? NBTString) == (otherTag as? NBTString)
			case .list, .byteList, .intList, .longList:
				return (self as? NBTList) == (otherTag as? NBTList)
			case .compound:
				return (self as? NBTCompound) == (otherTag as? NBTCompound)
		}
	}
	
	public func hash(into hasher: inout Hasher) {
		switch self.type {
			case .end:
				fatalError("Found unexpected tag type `end`, which is not allowed")
			case .byte:
				(self as? NBTByte)?.hash(into: &hasher)
			case .short:
				(self as? NBTShort)?.hash(into: &hasher)
			case .int:
				(self as? NBTInt)?.hash(into: &hasher)
			case .long:
				(self as? NBTLong)?.hash(into: &hasher)
			case .float:
				(self as? NBTFloat)?.hash(into: &hasher)
			case .double:
				(self as? NBTDouble)?.hash(into: &hasher)
			case .string:
				(self as? NBTString)?.hash(into: &hasher)
			case .list, .byteList, .intList, .longList:
				(self as? NBTList)?.hash(into: &hasher)
			case .compound:
				(self as? NBTCompound)?.hash(into: &hasher)
		}
	}
	
	public var description: String {
		return self.description(indentation: 0)
	}
}

public func equal(_ lhs: (any Tag)?, _ rhs: (any Tag)?) -> Bool {
	if let lhs, let rhs {
		return lhs.equal(to: rhs)
	} else {
		return lhs == nil && rhs == nil
	}
}
