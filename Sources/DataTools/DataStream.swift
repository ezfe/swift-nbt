//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/25/23.
//

import Foundation

public class DataStream {
	public private(set) var data: Data
	private var byteNumber: Int
	private var iterator: Data.Iterator
	
	public init(_ bytes: [UInt8]) {
		self.data = Data(bytes)
		self.byteNumber = 0
		self.iterator = self.data.makeIterator()
	}
	
	public init(_ data: Data) {
		self.data = data
		self.byteNumber = 0
		self.iterator = data.makeIterator()
	}
	
	public func read<Type>(_ type: Type.Type) -> Type? where Type: DataStreamReadable {
		return type.make(with: self)
	}
	
	public func next() -> UInt8? {
		byteNumber += 1
		return iterator.next()
	}
}
