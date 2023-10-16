//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/25/23.
//

import DataTools

extension DataStream {
	internal func readPayload(type: NBTTagType) -> (any NBTTag)? {
		switch type {
			case .end:
				fatalError("Attempted to read tag type `end`, which is not allowed")
			case .byte:
				return self.read(Int8.self)
			case .short:
				return self.read(Int16.self)
			case .int:
				return self.read(Int32.self)
			case .long:
				return self.read(Int64.self)
			case .float:
				return self.read(Float32.self)
			case .double:
				return self.read(Float64.self)
				
			case .string:
				return self.read(String.self)
				
			case .list:
				return NBTList.makeGenericList(with: self)
				
			case .byteList:
				return NBTList.makeByteList(with: self)
			case .intList:
				return NBTList.makeIntList(with: self)
			case .longList:
				return NBTList.makeLongList(with: self)
				
			case .compound:
				return NBTCompound.make(with: self)
		}
	}

}
