//
//  GenericList.swift
//  
//
//  Created by Ezekiel Elin on 1/26/23.
//

import DataTools

public struct GenericList: AnyList {
	public let type = NBTTagType.list
	
	public var genericType: NBTTagType
	public var elements: [any Tag]
	
	init(genericType: NBTTagType, elements: [any Tag]) {
		self.genericType = genericType
		self.elements = elements
	}
	
	public static func make(with stream: DataStream) -> GenericList? {
		guard let type = stream.read(Int8.self),
				let type = NBTTagType(rawValue: type) else {
			return nil
		}
		
		guard let length = stream.read(Int32.self) else {
			return nil
		}
		
		var elements = [any Tag]()
		elements.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			guard let value = stream.readPayload(type: type) else {
				return nil
			}
			elements.append(value)
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
	
	public static func ==(lhs: GenericList, rhs: GenericList) -> Bool {
		guard lhs.genericType == rhs.genericType else {
			return false
		}

		guard lhs.elements.count == rhs.elements.count else {
			return false
		}
		
		for (lel, rel) in zip(lhs.elements, rhs.elements) {
			guard lel.equal(to: rel) else {
				return false
			}
		}
		return true
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[list:"
		for tag in self.elements {
			result += "\n\(makeIndent(indentation)) > \(tag.description(indentation: indentation + 1))"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}
}
