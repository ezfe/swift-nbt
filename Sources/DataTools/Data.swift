//
//  Data.swift
//  MinecraftAnvil
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation

public typealias Byte = UInt8
extension Data {
    func bytes() -> [Byte] {
        var byteArray = Array<Byte>(repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
    
    func bytes(in range: Range<Data.Index>) -> [Byte] {
        return self.subdata(in: range).bytes()
    }
    
    func byte(at index: Data.Index) -> Byte {
        return self.bytes(in: index..<(index+1))[0]
    }
}

public class DataStream {
    public private(set) var data: Data
    private var byteNumber: Int
    private var iterator: Data.Iterator
    
    public init(_ data: Data) {
        self.data = data
        self.byteNumber = 0
        self.iterator = data.makeIterator()
    }
    
    public func read<Type>(_ type: Type.Type) throws -> Type where Type: DataStreamCreatable {
        return try type.make(with: self)
    }
    
    public func next() -> Byte {
        byteNumber += 1
        return iterator.next() ?? 0
    }
}

public protocol DataStreamLoadable {
    func load(from stream: DataStream) throws
}

public protocol DataStreamCreatable {
    static func make(with stream: DataStream) throws -> Self
}

