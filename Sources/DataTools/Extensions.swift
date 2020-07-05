//
//  Extensions.swift
//  DataTools
//
//  Created by Ezekiel Elin on 4/18/18.
//

import Foundation


extension UInt8: DataStreamCreatable {
    public static func make(with stream: DataStream) -> UInt8 {
        return stream.next()
    }
}

extension UInt16: DataStreamCreatable {
    public static func make(with stream: DataStream) -> UInt16 {
        let most = stream.next()
        let least = stream.next()
        return (UInt16(most) << 8) + UInt16(least)
    }
}

extension UInt32: DataStreamCreatable {
    public static func make(with stream: DataStream) -> UInt32 {
        let a = stream.next()
        let b = stream.next()
        let c = stream.next()
        let d = stream.next()
        
        let arr = [a, b, c, d]
        let data = Data(arr)
        
        return UInt32(bigEndian: data.withUnsafeBytes { $0.load(as: self) })
    }
}

extension UInt64: DataStreamCreatable {
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
}

extension Int8: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Int8 {
        let bits = stream.read(UInt8.self)
        return Int8(bitPattern: bits)
    }
}

extension Int16: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Int16 {
        let bits = stream.read(UInt16.self)
        return Int16(bitPattern: bits)
    }
}

extension Int32: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Int32 {
        let bits = stream.read(UInt32.self)
        return Int32(bitPattern: bits)
    }
}

extension Int64: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Int64 {
        let bits = stream.read(UInt64.self)
        return Int64(bitPattern: bits)
    }
}

extension Float32: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Float32 {
        let bits = stream.read(UInt32.self)
        return Float32(bitPattern: bits)
    }
}

extension Float64: DataStreamCreatable {
    public static func make(with stream: DataStream) -> Float64 {
        let bits = stream.read(UInt64.self)
        return Float64(bitPattern: bits)
    }
}

extension String: DataStreamCreatable {
    public static func make(with stream: DataStream) -> String {
        let length = stream.read(UInt16.self)
        
        var accumulate = [Character]()
        var carryOverByte: UInt8? = nil
        for _ in 0..<length {
            let byte = stream.next()
            
            if let a = carryOverByte {
                let combinedByte = ((a & 0x1F) << 6) | (byte & 0x3F)
                let scalar = UnicodeScalar(combinedByte)
                accumulate.append(Character(scalar))
                
                carryOverByte = nil
                continue
            }
            
            if (byte >> 7) & 0b1 == 0 {
                let scalar = UnicodeScalar(byte)
                accumulate.append(Character(scalar))
            } else if (byte >> 5) & 0b111 == 0b110 {
                carryOverByte = byte
            }
        }
        
        let string = String(accumulate)
        return string
    }
}
