//
//  NBTCompound.swift
//  
//
//  Created by Ezekiel Elin on 1/27/23.
//

import Foundation
import DataTools
import OrderedCollections

public struct NBTCompound: Tag, DataStreamReadable, DataAccumulatorWritable {
	public let type = NBTTagType.compound
	public let icon = "archivebox"
	
	public var contents: OrderedDictionary<String, any Tag>
	public var children: OrderedDictionary<String, any Tag>? { contents }
	
	public init(contents: OrderedDictionary<String, any Tag> = [:]) {
		self.contents = contents
	}

	public subscript(key: String) -> (any Tag)? {
		set {
			self.contents[key] = newValue
		}
		get {
			return self.contents[key]
		}
	}
	
	public static func make(with stream: DataStream) -> NBTCompound? {
		var contents = OrderedDictionary<String, any Tag>()
		
		while let typeInt = stream.read(Int8.self), let type = NBTTagType(rawValue: typeInt), type != .end {
			guard let name = stream.read(String.self),
					let payload = stream.readPayload(type: type) else {
				print("Failed to build payload")
				return nil
			}

			contents[name] = payload
		}
		
		return NBTCompound(contents: contents)
	}
	
	public func append(to accumulator: DataAccumulator) {
		for (name, tag) in self.contents {
			tag.type.rawValue.append(to: accumulator)
			name.append(to: accumulator)
			tag.append(to: accumulator)
		}
		NBTTagType.end.rawValue.append(to: accumulator)
	}
	
	public static func ==(lhs: NBTCompound, rhs: NBTCompound) -> Bool {
		guard lhs.contents.count == rhs.contents.count else {
			return false
		}
		for (key, value) in lhs.contents {
			guard value.equal(to: rhs[key]) else {
				return false
			}
		}
		return true
	}

	public func hash(into hasher: inout Hasher) {
		for (key, value) in self.contents {
			hasher.combine(key)
			hasher.combine(value)
		}
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
