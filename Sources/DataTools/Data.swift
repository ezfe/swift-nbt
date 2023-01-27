//
//  Data.swift
//  MinecraftAnvil
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation

public class DataAccumulator {
	public private(set) var data: Data
	
	public init() {
		self.data = Data()
	}
	
	public func append(data new: Data) {
		self.data.append(new)
	}
}

public protocol DataStreamReadable {
	static func make(with stream: DataStream) -> Self?
}

public protocol DataAccumulatorWritable {
	func append(to accumulator: DataAccumulator)
}
