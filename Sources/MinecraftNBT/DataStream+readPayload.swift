//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/25/23.
//

import DataTools

extension DataStream {
	internal func readPayload(type: NBTTagType) -> (any Tag)? {
		switch type {
			case .byte:
				guard let value = self.read(Int8.self) else {
					return nil
				}
				return ByteValue(value: value)
			case .short:
				guard let value = self.read(Int16.self) else {
					return nil
				}
				return ShortValue(value: value)
			case .int:
				guard let value = self.read(Int32.self) else {
					return nil
				}
				return IntValue(value: value)
			case .long:
				guard let value = self.read(Int64.self) else {
					return nil
				}
				return LongValue(value: value)
			case .float:
				guard let value = self.read(Float32.self) else {
					return nil
				}
				return FloatValue(value: value)
			case .double:
				guard let value = self.read(Float64.self) else {
					return nil
				}
				return DoubleValue(value: value)
				
			case .string:
				guard let value = self.read(String.self) else {
					return nil
				}
				return StringValue(value: value)
				
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
