//
//  Data.swift
//  MinecraftAnvil
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation

public class DataStream {
    public private(set) var data: Data
    private var byteNumber: Int
    private var iterator: Data.Iterator
    
    public init(_ data: Data) {
        self.data = data
        self.byteNumber = 0
        self.iterator = data.makeIterator()
    }
    
    public func read<Type>(_ type: Type.Type) -> Type where Type: DataStreamCreatable {
        return type.make(with: self)
    }
    
    public func next() -> UInt8 {
        byteNumber += 1
        return iterator.next() ?? 0
    }
}

public protocol DataStreamCreatable {
    static func make(with stream: DataStream) -> Self
}

