//
//  NBTGenericList.swift
//  
//
//  Created by Ezekiel Elin on 1/26/23.
//

import DataTools
import OrderedCollections

public struct NBTList: Tag {
	public var type: NBTTagType {
		switch self.mode {
			case .genericList(_):
				return .list
			case .byteList:
				return .byteList
			case .intList:
				return .intList
			case .longList:
				return .longList
		}
	}
	public var icon = "list.bullet.clipboard"
	
	public var mode: ListMode
	public var elements: [any Tag]
	public var children: OrderedDictionary<String, any Tag>? {
		var results = OrderedDictionary<String, any Tag>()
		for (index, element) in elements.enumerated() {
			results[String(index)] = element
		}
		return results
	}
	
	init(genericType: NBTTagType, elements: [any Tag]) {
		self.mode = .genericList(genericType)
		self.elements = elements
	}
	
	public init?(bytes: [NBTByte]?) {
		guard let bytes else { return nil }
		self.init(bytes: bytes)
	}
	
	public init(bytes: [NBTByte]) {
		self.mode = .byteList
		self.elements = bytes
	}
	
	public init?(ints: [NBTInt]?) {
		guard let ints else { return nil }
		self.init(ints: ints)
	}
	
	public init(ints: [NBTInt]) {
		self.mode = .intList
		self.elements = ints
	}
	
	public init?(longs: [NBTLong]?) {
		guard let longs else { return nil }
		self.init(longs: longs)
	}
	
	public init(longs: [NBTLong]) {
		self.mode = .longList
		self.elements = longs
	}
	
	public static func makeGenericList(with stream: DataStream) -> NBTList? {
		guard let typeInt = stream.read(Int8.self),
				let type = NBTTagType(rawValue: typeInt) else {
			return nil
		}
		
		guard let length = stream.read(Int32.self) else {
			return nil
		}
		
		var elements = [any Tag]()
		elements.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			guard let value = stream.readPayload(type: type) else {
				print("Failed to read type `\(type)`")
				return nil
			}
			elements.append(value)
		}
		
		return NBTList(genericType: type, elements: elements)
	}
	
	public static func makeByteList(with stream: DataStream) -> NBTList? {
		return NBTList(bytes: makeTypedList(with: stream))
	}
	
	public static func makeIntList(with stream: DataStream) -> NBTList? {
		return NBTList(ints: makeTypedList(with: stream))
	}
	
	public static func makeLongList(with stream: DataStream) -> NBTList? {
		return NBTList(longs: makeTypedList(with: stream))
	}

	private static func makeTypedList<Element: NBTLeafValue>(with stream: DataStream) -> [Element]? {
		guard let length = stream.read(Int32.self) else {
			return nil
		}
		
		var elements = [Element]()
		elements.reserveCapacity(Int(length))
		
		for _ in 0..<length {
			guard let value = stream.read(Element.self) else {
				print("Failed to read type `\(Element.self)`")
				return nil
			}
			elements.append(value)
		}

		return elements
	}
	
	public func append(to accumulator: DataAccumulator) {
		if case .genericList(let type) = self.mode {
			type.rawValue.append(to: accumulator)
		}

		Int32(self.elements.count).append(to: accumulator)
		
		for tag in self.elements {
			// TODO: Some way to force typing?
			tag.append(to: accumulator)
		}
	}
	
	public static func ==(lhs: NBTList, rhs: NBTList) -> Bool {
		guard lhs.mode == rhs.mode else {
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
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.mode)
		for tag in self.elements {
			hasher.combine(tag)
		}
	}
	
	public func description(indentation: UInt) -> String {
		var result = "[list<\(self.mode)>:"
		for tag in self.elements {
			result += "\n\(makeIndent(indentation)) > \(tag.description(indentation: indentation + 1))"
		}
		result += "\n\(makeIndent(indentation))]"
		return result
	}
	
	public enum ListMode: Equatable, Hashable {
		case genericList(NBTTagType)
		case byteList
		case intList
		case longList
	}
}
