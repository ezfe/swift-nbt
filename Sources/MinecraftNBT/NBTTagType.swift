//
//  NBTTagType.swift
//  MinecraftNBT
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public enum NBTTagType: Byte, DataStreamCreatable, CustomStringConvertible {
    public enum TagError: Error {
        case invalidTagType
    }
    
    public static func make(with stream: DataStream) throws -> NBTTagType {
        let byte = stream.next()
        
        guard let type = NBTTagType(rawValue: byte) else {
            throw TagError.invalidTagType
        }
        
        return type
    }
    
    case end = 0
    case byte = 1
    case short = 2
    case int = 3
    case long = 4
    case float = 5
    case double = 6
    case byteArray = 7
    case string = 8
    case list = 9
    case compound = 10
    case intArray = 11
    
    public var description: String {
        switch self {
        case .end:
            return "end"
        case .byte:
            return "byte"
        case .short:
            return "short"
        case .int:
            return "int"
        case .long:
            return "long"
        case .float:
            return "float"
        case .double:
            return "double"
        case .byteArray:
            return "[byte]"
        case .string:
            return "text"
        case .list:
            return "[*]"
        case .compound:
            return "[string:*]"
        case .intArray:
            return "[int]"
        }
    }
}
