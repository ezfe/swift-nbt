//
//  NBT.swift
//  MinecraftAnvil
//
//  Created by Ezekiel Elin on 4/17/18.
//

import Foundation
import DataTools

internal func makeTag(from data: DataStream,
                      of forceType: NBTTagType? = nil,
                      named forceName: String? = nil) throws -> NBTTag {
    
    let type: NBTTagType = try forceType ?? data.read(NBTTagType.self)

    if type == .end {
        return NBTEndTag()
    }
    
    let name: String = try forceName ?? data.read(String.self)

    var tag: NBTTag
    switch type {
    case .byte:
        tag = NBTByteTag()
    case .short:
        tag = NBTShortTag()
    case .int:
        tag = NBTIntTag()
    case .long:
        tag = NBTLongTag()
    case .float:
        tag = NBTFloatTag()
    case .double:
        tag = NBTDoubleTag()
    case .string:
        tag = NBTStringTag()
    case .list:
        tag = NBTListTag()
    case .compound:
        tag = NBTCompoundTag()
    default:
        print("Encountered type: \(type)")
        exit(1)
    }
    
    tag.name = name
    try tag.load(from: data)
    
    return tag
}

public protocol NBTTag: DataStreamLoadable, CustomStringConvertible {
    var type: NBTTagType { get }
    var name: String { get set }
    
    var valueString: String { get }
    
    func display(indented indentation: Int)
}

public extension NBTTag {
    var description: String {
        return "\(name):\(type)"
    }
}

public protocol NBTContainerTag {
    var count: Int { get }
}

public final class NBTEndTag: NBTTag {
    public let type: NBTTagType = .end
    public var name: String = ""
    
    public var valueString: String {
        return "(no value)"
    }
    
    public func load(from stream: DataStream) {
        exit(2)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[end]")
    }
}

public final class NBTByteTag: NBTTag {
    public let type: NBTTagType = .byte
    public var name: String
    
    public var value: Byte
    
    public var valueString: String {
        return value.description
    }
    
    public init(name: String = "", value: Byte = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Byte.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTShortTag: NBTTag {
    public let type: NBTTagType = .short
    public var name: String
    
    public var value: Int16
    
    public var valueString: String {
        return value.description
    }
    
    init(name: String = "", value: Int16 = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Int16.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTIntTag: NBTTag {
    public let type: NBTTagType = .int
    public var name: String
    
    public var value: Int32
    
    public var valueString: String {
        return value.description
    }
    
    init(name: String = "", value: Int32 = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Int32.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTLongTag: NBTTag {
    public let type: NBTTagType = .long
    public var name: String
    
    public var value: Int64
    
    public var valueString: String {
        return value.description
    }
    
    init(name: String = "", value: Int64 = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Int64.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTFloatTag: NBTTag {
    public let type: NBTTagType = .float
    public var name: String
    
    public var value: Float
    
    public var valueString: String {
        return value.description
    }
    
    init(name: String = "", value: Float = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Float.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTDoubleTag: NBTTag {
    public let type: NBTTagType = .double
    public var name: String
    
    public var value: Double
    
    public var valueString: String {
        return value.description
    }
    
    init(name: String = "", value: Double = 0) {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(Double.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTByteListTag: NBTTag, NBTContainerTag {
    public let type: NBTTagType = .byteArray
    public var name: String
    
    public var contents: [Byte]
    
    public var valueString: String {
        return "(\(self.contents.count) items)"
    }
    
    public var count: Int { return self.contents.count }
    
    init(name: String = "", contents: [Byte] = []) {
        self.name = name
        self.contents = [Byte]()
    }
    
    public func load(from stream: DataStream) throws {
        let length = try stream.read(Int32.self)
        contents.removeAll()
        contents.reserveCapacity(Int(length))
        
        for _ in 0..<length {
            try contents.append(stream.read(Byte.self))
        }
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):")
        for byte in contents {
            print(String(repeating: "\t", count: indentation + 1), terminator: "")
            print(byte)
        }
    }
}


public final class NBTStringTag: NBTTag {
    public let type: NBTTagType = .string
    public var name: String
    
    public var value: String
    
    public var valueString: String {
        return value
    }
    
    init(name: String = "", value: String = "") {
        self.name = name
        self.value = value
    }
    
    public func load(from stream: DataStream) throws {
        self.value = try stream.read(String.self)
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):\(value)]")
    }
}

public final class NBTListTag: NBTTag, NBTContainerTag {
    public let type: NBTTagType = .list
    public var name: String
    
    public var contents: [NBTTag]
    
    public var valueString: String {
        return "(\(self.contents.count) items)"
    }
    
    public var count: Int { return self.contents.count }
    
    init(name: String = "", contents: [NBTTag] = []) {
        self.name = name
        self.contents = [NBTTag]()
    }
    
    public func load(from stream: DataStream) throws {
        let type = try stream.read(NBTTagType.self)
        let length = try stream.read(Int32.self)
        contents.removeAll()
        contents.reserveCapacity(Int(length))
        
        for _ in 0..<length {
            let tag = try! makeTag(from: stream, of: type, named: "")
            contents.append(tag)
        }
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):")
        for tag in contents {
            tag.display(indented: indentation + 1)
        }
    }
}


public final class NBTCompoundTag: NBTTag, NBTContainerTag {
    public let type: NBTTagType = .compound
    public var name: String
    
    public var tags: [String: NBTTag]
    
    public var valueString: String {
        return "(\(self.tags.count) pairs)"
    }
    
    public var count: Int { return self.tags.count }
    
    init(name: String = "", tags: [String: NBTTag] = [:]) {
        self.name = name
        self.tags = [String: NBTTag]()
    }
    
    public func load(from stream: DataStream) {
        tags.removeAll()
        var tag: NBTTag = try! makeTag(from: stream)
        while tag.type != .end {
            tags[tag.name] = tag
            tag = try! makeTag(from: stream)
        }
    }
    
    public func display(indented indentation: Int) {
        print(String(repeating: "\t", count: indentation), terminator: "")
        print("[\(name)/\(type):")
        for (_, tag) in tags {
            tag.display(indented: indentation + 1)
        }
    }
}
