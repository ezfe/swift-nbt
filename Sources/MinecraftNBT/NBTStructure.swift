//
//  NBTStructure.swift
//  DataTools
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools
import Gzip

public struct NBTStructure {
	public var tag: NBTCompound
	
	public init?(decompressed data: Data) {
		let stream = DataStream(data)
		guard let tag = NBTCompound.make(with: stream) else {
			return nil
		}
		self.tag = tag
	}
	
	public init?(compressed data: Data) {
		guard data.isGzipped, let decompressed = try? data.gunzipped() else {
			return nil
		}
		self.init(decompressed: decompressed)
	}
	
	public init(tag: NBTCompound = NBTCompound()) {
		self.tag = tag
	}
	
	public var data: Data {
		let acc = DataAccumulator()
		self.tag.append(to: acc)
		return acc.data
	}

	public func read(_ keypath: [String]) throws -> (any NBTTag)? {
		return try traverse(keypath).1
	}
		
	public mutating func write(_ value: any NBTTag, to keypath: [String]) throws {
		//"", "Data", "DataPacks", "Enabled", "0"
		var (tags, _) = try traverse(keypath)

		var value = value
		for key in keypath.reversed() {
			let tag = tags.popLast()!
			
			var newValue: any NBTTag
			if var compound = tag as? NBTCompound {
				compound[key] = value
				newValue = compound
			} else if var list = tag as? NBTList {
				if let index = Int(key) {
					if 0..<list.elements.count ~= index {
						list.elements[index] = value
					} else if index == list.elements.count {
						list.elements.append(value)
					} else {
						throw KeypathError.outOfBoundsListIndex("List index `\(key)` is out of bounds on `\(list)`")
					}
				} else {
					throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
				}
				newValue = list
			} else {
				throw KeypathError.unkeyedValue("Unable to write `\(key)` to non-keyed `\(tag)`")
			}
			
			value = newValue
		}
		
		guard let compound = value as? NBTCompound else {
			throw KeypathError.fatalError("Final value is not compound `\(value)`")
		}

		tag = compound
	}
		
	private func traverse(_ keypath: [String]) throws -> ([any NBTTag], (any NBTTag)?) {
		if keypath.count == 0 {
			return ([], tag)
		}

		var workingTag: any NBTTag = self.tag
		var accumulator: [any NBTTag] = [workingTag]
		for key in keypath.dropLast(1) {
			if let compound = workingTag as? NBTCompound {
				if let found = compound[key] {
					workingTag = found
				} else {
					throw KeypathError.missingValue("Key `\(key)` does not exist on `\(compound)`")
				}
			} else if let list = workingTag as? NBTList {
				if let index = Int(key) {
					if 0..<list.elements.count ~= index {
						workingTag = list.elements[index]
					} else {
						throw KeypathError.outOfBoundsListIndex("List index `\(key)` is out of bounds on `\(list)`")
					}
				} else {
					throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
				}
			} else {
				throw KeypathError.unkeyedValue("Unable to read `\(key)` from non-keyed `\(tag)`")
			}

			accumulator.append(workingTag)
		}

		guard let key = keypath.last else {
			return (accumulator, nil)
		}

		if let compound = workingTag as? NBTCompound {
			return (accumulator, compound[key])
		} else if let list = workingTag as? NBTList {
			if let index = Int(key) {
				if 0..<list.elements.count ~= index {
					return (accumulator, list.elements[index])
				} else {
					return (accumulator, nil)
				}
			} else {
				throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
			}
		} else {
			throw KeypathError.unkeyedValue("Unable to read `\(key)` from non-keyed `\(tag)`")
		}
	}
	
	enum KeypathError: Error {
		case unkeyedValue(String)
		case missingValue(String)
		case invalidListIndex(String)
		case outOfBoundsListIndex(String)
		case invalidValueForList(String)
		case fatalError(String)
	}
}
