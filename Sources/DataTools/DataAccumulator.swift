//
//  DataAccumulator.swift
//  DataTools
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation

/// Accumulate new blobs of data into a single container
public class DataAccumulator {
	public private(set) var data: Data
	
	public init() {
		self.data = Data()
	}
	
	/// Append new data to this ``DataAccumulator``
	/// - Parameters:
	///   - new: Data to add to the container
	public func append(data new: Data) {
		self.data.append(new)
	}
}

/// Provides a method to append data to an accumulator
public protocol DataAccumulatorWritable {
	/// Append data to the ``DataAccumulator`` representing this object
	func append(to accumulator: DataAccumulator)
}
