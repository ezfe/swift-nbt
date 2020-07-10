//
//  Extensions.swift
//  DataTools
//
//  Created by Ezekiel Elin on 4/18/18.
//

import Foundation


extension UInt8: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> UInt8 {
        return stream.next()
    }

    public func append(to accumulator: DataAccumulator) {
        accumulator.append(data: Data([self]))
    }
}

extension UInt16: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> UInt16 {
        let most = stream.next()
        let least = stream.next()
        return (UInt16(most) << 8) + UInt16(least)
    }

    public func append(to accumulator: DataAccumulator) {
        withUnsafeBytes(of: self.bigEndian) { ptr in
            accumulator.append(data: Data(ptr))
        }
    }
}

extension UInt32: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> UInt32 {
        let a = stream.next()
        let b = stream.next()
        let c = stream.next()
        let d = stream.next()
        
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

extension UInt64: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> UInt64 {
        let a = stream.next()
        let b = stream.next()
        let c = stream.next()
        let d = stream.next()
        let e = stream.next()
        let f = stream.next()
        let g = stream.next()
        let h = stream.next()
        
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

extension Int8: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> Int8 {
        let bits = stream.read(UInt8.self)
        return Int8(bitPattern: bits)
    }

    public func append(to accumulator: DataAccumulator) {
        withUnsafeBytes(of: self.bigEndian) { ptr in
            accumulator.append(data: Data(ptr))
        }
    }
}

extension Int16: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> Int16 {
        let bits = stream.read(UInt16.self)
        return Int16(bitPattern: bits)
    }

    public func append(to accumulator: DataAccumulator) {
        withUnsafeBytes(of: self.bigEndian) { ptr in
            accumulator.append(data: Data(ptr))
        }
    }
}

extension Int32: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> Int32 {
        let bits = stream.read(UInt32.self)
        return Int32(bitPattern: bits)
    }

    public func append(to accumulator: DataAccumulator) {
        withUnsafeBytes(of: self.bigEndian) { ptr in
            accumulator.append(data: Data(ptr))
        }
    }
}

extension Int64: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> Int64 {
        let bits = stream.read(UInt64.self)
        return Int64(bitPattern: bits)
    }

    public func append(to accumulator: DataAccumulator) {
        withUnsafeBytes(of: self.bigEndian) { ptr in
            accumulator.append(data: Data(ptr))
        }
    }
}

extension Float32: DataStreamReadable {
    public static func make(with stream: DataStream) -> Float32 {
        let bits = stream.read(UInt32.self)
        return Float32(bitPattern: bits)
    }
}

extension Float64: DataStreamReadable {
    public static func make(with stream: DataStream) -> Float64 {
        let bits = stream.read(UInt64.self)
        return Float64(bitPattern: bits)
    }
}

extension String: DataStreamReadable, DataStreamWritable {
    public static func make(with stream: DataStream) -> String {
        let length = stream.read(UInt16.self)

        var accumulate = [UInt8]()
        for _ in 0..<length {
            accumulate.append(stream.read(UInt8.self))
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
