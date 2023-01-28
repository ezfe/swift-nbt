//
//  DataStream.swift
//  DataTools
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation

/// A stream of data  intended to be consumed byte-by-byte
public class DataStream {
	/// The source data being read
	public private(set) var data: Data
	/// The iterator that tracks which byte is next
	private var iterator: Data.Iterator
	
	/// Create a ``DataStream`` from an array of bytes
	/// - Parameters bytes: A list of bytes stored as `UInt8`
	public init(_ bytes: [UInt8]) {
		self.data = Data(bytes)
		self.iterator = self.data.makeIterator()
	}
	
	/// Create a ``DataStream`` from `Data`
	/// - Parameter data: The stream `Data`
	public init(_ data: Data) {
		self.data = data
		self.iterator = data.makeIterator()
	}
	
	/// Read a compatible type from the ``DataStream``
	///
	/// Any type that implements ``DataStreamReadable`` can be read from the `DataStream`. Conformance is provided
	/// for basic types like `String`, `Int`, etc. More complex types can provide their own conformance.
	///
	/// - Parameter type: The type to try and read from the ``DataStream``
	/// - Returns: A copy of the type, if successfully read - otherwise `nil`
	public func read<Type>(_ type: Type.Type) -> Type? where Type: DataStreamReadable {
		return type.make(with: self)
	}
	
	
	/// Read the next byte
	/// - Returns: The next byte, if another one exists - otherwise `nil`
	public func next() -> UInt8? {
		return iterator.next()
	}
}

/// A type that can 	 itself from a data stream
public protocol DataStreamReadable {
	static func make(with stream: DataStream) -> Self?
}
