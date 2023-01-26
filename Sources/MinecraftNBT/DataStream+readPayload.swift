//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/25/23.
//

import DataTools

extension DataStream {
	internal func readPayload(type: NBTTagType) -> any Tag {
		switch type {
			case .byte:
				return ByteValue(value: self.read(Int8.self))
			case .short:
				return ShortValue(value: self.read(Int16.self))
			case .int:
				return IntValue(value: self.read(Int32.self))
			case .long:
				return LongValue(value: self.read(Int64.self))
			case .float:
				return FloatValue(value: self.read(Float32.self))
			case .double:
				return DoubleValue(value: self.read(Float64.self))
				
			case .string:
				return StringValue(value: self.read(String.self))
				
			case .list:
				return GenericList.make(with: self)
				
			case .byteArray:
				return ByteArray.make(with: self)
			case .intArray:
				return IntArray.make(with: self)
			case .longArray:
				return LongArray.make(with: self)
				
			case .compound:
				return Compound.make(with: self)
				
			case .end:
				return End()
		}
	}

}
