//
//  NBTStructure.swift
//  DataTools
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public struct NBTStructure {
	public var tag: Compound
	
	public init(decompressed data: Data) {
		let stream = DataStream(data)
		self.tag = Compound.make(with: stream)
	}
	
	public init(tag: Compound = Compound()) {
		self.tag = tag
	}
	
	public var data: Data {
		let acc = DataAccumulator()
		self.tag.append(to: acc)
		return acc.data
	}

	public func read(_ keypath: [String]) throws -> Tag? {
		return try traverse(keypath).1
	}
		
	public mutating func write(_ value: Tag, to keypath: [String]) throws {
		//"", "Data", "DataPacks", "Enabled", "0"
		var (tags, _) = try traverse(keypath)

		var value = value
		for key in keypath.reversed() {
			let tag = tags.popLast()!
			
			var newValue: Tag
			if var compound = tag as? Compound {
				compound[key] = value
				newValue = compound
			} else if var list = tag as? GenericList {
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
			} else if let list = tag as? any SpecializedArray {
				if let index = Int(key) {
					if 0..<list.elements.count ~= index {
						if var list = list as? ByteArray, let value = value as? ByteValue {
							list.elements.append(value.value)
							newValue = list
						} else if var list = list as? IntArray, let value = value as? IntValue {
							list.elements.append(value.value)
							newValue = list
						} else if var list = list as? LongArray, let value = value as? LongValue {
							list.elements.append(value.value)
							newValue = list
						} else {
							throw KeypathError.invalidValueForList("Value `\(value)` cannot be stored in `\(list)`")
						}
					} else {
						throw KeypathError.outOfBoundsListIndex("List index `\(key)` is out of bounds on `\(list)`")
					}
				} else {
					throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
				}
			} else {
				throw KeypathError.unkeyedValue("Unable to write `\(key)` to non-keyed `\(tag)`")
			}
			
			value = newValue
		}
		
		guard let compound = value as? Compound else {
			throw KeypathError.fatalError("Final value is not compound `\(value)`")
		}

		tag = compound
	}
		
	private func traverse(_ keypath: [String]) throws -> ([Tag], Tag?) {
		if keypath.count == 0 {
			return ([], tag)
		}

		var workingTag: Tag = self.tag
		var accumulator: [Tag] = [workingTag]
		for key in keypath.dropLast(1) {
			if let compound = workingTag as? Compound {
				if let found = compound[key] {
					workingTag = found
				} else {
					throw KeypathError.missingValue("Key `\(key)` does not exist on `\(compound)`")
				}
			} else if let list = workingTag as? GenericList {
				if let index = Int(key) {
					if 0..<list.elements.count ~= index {
						workingTag = list.elements[index]
					} else {
						throw KeypathError.outOfBoundsListIndex("List index `\(key)` is out of bounds on `\(list)`")
					}
				} else {
					throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
				}
			} else if let list = workingTag as? any SpecializedArray {
				if let index = Int(key) {
					 if 0..<list.elements.count ~= index {
						 workingTag = list.nbtValues[index]
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

		if let compound = workingTag as? Compound {
			return (accumulator, compound[key])
		} else if let list = workingTag as? GenericList {
			if let index = Int(key) {
				if 0..<list.elements.count ~= index {
					return (accumulator, list.elements[index])
				} else {
					return (accumulator, nil)
				}
			} else {
				throw KeypathError.invalidListIndex("Unable to access list item `\(key)` on `\(list)`")
			}
		} else if let list = workingTag as? any SpecializedArray {
			if let index = Int(key) {
				return (accumulator, list.nbtValues[index])
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
