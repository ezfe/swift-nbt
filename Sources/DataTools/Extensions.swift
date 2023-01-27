//
//  Extensions.swift
//  DataTools
//
//  Created by Ezekiel Elin on 4/18/18.
//

import Foundation


extension UInt8: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> UInt8? {
		return stream.next()
	}
	
	public func append(to accumulator: DataAccumulator) {
		accumulator.append(data: Data([self]))
	}
}

extension UInt16: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> UInt16? {
		guard let most = stream.next(), let least = stream.next() else {
			return nil
		}
		return (UInt16(most) << 8) + UInt16(least)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension UInt32: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> UInt32? {
		guard let a = stream.next(),
				let b = stream.next(),
				let c = stream.next(),
				let d = stream.next() else {
			return nil
		}
		
		let arr = [a, b, c, d]
		let data = Data(arr)
		
		return UInt32(bigEndian: data.withUnsafeBytes { $0.load(as: self) })
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension UInt64: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> UInt64? {
		guard let a = stream.next(),
				let b = stream.next(),
				let c = stream.next(),
				let d = stream.next(),
				let e = stream.next(),
				let f = stream.next(),
				let g = stream.next(),
				let h = stream.next() else {
			return nil
		}
		
		let arr = [a, b, c, d, e, f, g, h]
		let data = Data(arr)
		return UInt64(bigEndian: data.withUnsafeBytes { $0.load(as: self) })
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension Int8: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Int8? {
		guard let bits = stream.read(UInt8.self) else {
			return nil
		}
		return Int8(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension Int16: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Int16? {
		guard let bits = stream.read(UInt16.self) else {
			return nil
		}
		return Int16(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension Int32: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Int32? {
		guard let bits = stream.read(UInt32.self) else {
			return nil
		}
		return Int32(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension Int64: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Int64? {
		guard let bits = stream.read(UInt64.self) else {
			return nil
		}
		return Int64(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self.bigEndian) { ptr in
			accumulator.append(data: Data(ptr))
		}
	}
}

extension Float32: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Float32? {
		guard let bits = stream.read(UInt32.self) else {
			return nil
		}
		return Float32(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self) { ptr in
			let data = Data(ptr.reversed())
			accumulator.append(data: data)
		}
	}
}

extension Float64: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> Float64? {
		guard let bits = stream.read(UInt64.self) else {
			return nil
		}
		return Float64(bitPattern: bits)
	}
	
	public func append(to accumulator: DataAccumulator) {
		withUnsafeBytes(of: self) { ptr in
			let data = Data(ptr.reversed())
			accumulator.append(data: data)
		}
	}
}

extension String: DataStreamReadable, DataAccumulatorWritable {
	public static func make(with stream: DataStream) -> String? {
		guard let length = stream.read(UInt16.self) else {
			return nil
		}
		
		var accumulate = [UInt8]()
		for _ in 0..<length {
			guard let byte = stream.read(UInt8.self) else {
				return nil
			}
			accumulate.append(byte)
		}
		
		let data = Data(accumulate)
		return String(data: data, encoding: .utf8)!
	}
	
	public func append(to accumulator: DataAccumulator) {
		let data = self.data(using: .utf8)!
		let length = data.count
		
		Int16(length).append(to: accumulator)
		accumulator.append(data: data)
	}
}
