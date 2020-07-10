//
//  File.swift
//  
//
//  Created by Ezekiel on 7/4/20.
//

import Foundation
import DataTools

func readPayload(type: NBTTagType, stream: DataStream) -> Tag {
    switch type {
    case .byte:
        return Value(value: .int8(stream.read(Int8.self)))
    case .short:
        return Value(value: .int16(stream.read(Int16.self)))
    case .int:
        return Value(value: .int32(stream.read(Int32.self)))
    case .long:
        return Value(value: .int64(stream.read(Int64.self)))
    case .float:
        return Value(value: .float32(stream.read(Float32.self)))
    case .double:
        return Value(value: .float64(stream.read(Float64.self)))

    case .string:
        return Value(value: .string(stream.read(String.self)))
        
    case .list:
        return GenericList.make(with: stream)
        
    case .byteArray:
        return ByteArray.make(with: stream)
    case .intArray:
        return IntArray.make(with: stream)
    case .longArray:
        return LongArray.make(with: stream)
        
    case .compound:
        return Compound.make(with: stream)

    case .end:
        return End()
    }
}

// MARK:-

public protocol Tag: DataAccumulatorWritable {
    var type: NBTTagType { get }
}

struct End: Tag {
    let type = NBTTagType.end

    func append(to accumulator: DataAccumulator) {
        self.type.rawValue.append(to: accumulator)
    }
}

// MARK:- Lists

public struct GenericList: Tag, DataStreamReadable {
    public let type = NBTTagType.list

    public var genericType: NBTTagType
    public var elements: [Tag]
    
    public static func make(with stream: DataStream) -> GenericList {
        guard let type = NBTTagType(rawValue: stream.read(Int8.self)) else {
            print("Failed to find type")
            exit(4)
        }

        let length = stream.read(Int32.self)
        
        var elements = [Tag]()
        elements.reserveCapacity(Int(length))
        
        for _ in 0..<length {
            elements.append(readPayload(type: type, stream: stream))
        }
        
        return GenericList(genericType: type, elements: elements)
    }

    public func append(to accumulator: DataAccumulator) {
        self.genericType.rawValue.append(to: accumulator)
        Int32(self.elements.count).append(to: accumulator)

        for tag in self.elements {
            tag.append(to: accumulator)
        }
    }
}

protocol SpecializedArray: Tag, DataStreamReadable {
    associatedtype SType where SType: DataStreamReadable & DataAccumulatorWritable
    
    var elements: [SType] { get set }
    
    init(elements: [SType])
}

public struct ByteArray: SpecializedArray {
    public let type = NBTTagType.byteArray
    public var elements: [Int8]
}

public struct IntArray: SpecializedArray {
    public let type = NBTTagType.intArray
    public var elements: [Int32]
}

public struct LongArray: SpecializedArray {
    public let type = NBTTagType.longArray
    public var elements: [Int64]
}

extension SpecializedArray {
    public static func make(with stream: DataStream) -> Self {
        let length = stream.read(Int32.self)
        
        var storage = [SType]()
        storage.reserveCapacity(Int(length))
        
        for _ in 0..<length {
            storage.append(stream.read(SType.self))
        }
        
        return .init(elements: storage)
    }

    public func append(to accumulator: DataAccumulator) {
        Int32(self.elements.count).append(to: accumulator)
        self.elements.forEach { $0.append(to: accumulator) }
    }
}

// MARK:- Compound

public struct Compound: Tag, DataStreamReadable, DataAccumulatorWritable {
    public struct Pair {
        public let key: String
        public let value: Tag
    }

    public let type = NBTTagType.compound

    public var contents: [Pair]

    public init() {
        self.contents = []
    }
    
    public init(contents: [Pair]) {
        self.contents = contents
    }
    
    subscript(key: String) -> Tag? {
        set {
            self.contents.removeAll { $0.key == key }
            if let newValue = newValue {
                self.contents.append(Pair(key: key, value: newValue))
            }
        }
        get {
            return self.contents.first { $0.key == key }?.value
        }
    }
    
    public static func make(with stream: DataStream) -> Compound {
        var contents = [String: Tag]()
        
        // TODO: make this loop nicer
        while true {
            guard let type = NBTTagType(rawValue: stream.read(Int8.self)) else {
                print("Failed to find type: ")
                break
            }
            
            if type == .end {
                break
            }
            
            let name = stream.read(String.self)
            let payload = readPayload(type: type, stream: stream)
            
            if let _ = payload as? End {
                break
            }
            
            contents[name] = payload
        }
        
        return Compound(contents: contents
                            .map({ Pair(key: $0.key, value: $0.value) })
                            .sorted(by: { $0.key > $1.key }))
    }

    public func append(to accumulator: DataAccumulator) {
        for pair in self.contents {
            let name = pair.key
            let tag = pair.value

            tag.type.rawValue.append(to: accumulator)
            name.append(to: accumulator)
            tag.append(to: accumulator)
        }
        End().append(to: accumulator)
    }
}

// MARK:- Generic

public struct Value: Tag {
    public var type: NBTTagType {
        switch self.value {
        case .int8(_):
            return .byte
        case .int16(_):
            return .short
        case .int32(_):
            return .int
        case .int64(_):
            return .long

        case .float32(_):
            return .float
        case .float64(_):
            return .double

        case .string(_):
            return .string
        }
    }

    public let value: MinecraftValue
    
    public enum MinecraftValue {
        case int8(Int8)
        case int16(Int16)
        case int32(Int32)
        case int64(Int64)
        
        case float32(Float32)
        case float64(Float64)
        
        case string(String)
    }

    public func append(to accumulator: DataAccumulator) {
        switch self.value {
        case .int8(let v):
            v.append(to: accumulator)
        case .int16(let v):
            v.append(to: accumulator)
        case .int32(let v):
            v.append(to: accumulator)
        case .int64(let v):
            v.append(to: accumulator)

        case .float32(let v):
            v.append(to: accumulator)
        case .float64(let v):
            v.append(to: accumulator)

        case .string(let v):
            v.append(to: accumulator)
        }
    }
}
