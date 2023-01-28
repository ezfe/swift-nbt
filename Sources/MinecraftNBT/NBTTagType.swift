//
//  NBTTagType.swift
//  MinecraftNBT
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public enum NBTTagType: Int8, CustomStringConvertible {
	case end = 0
	case byte = 1
	case short = 2
	case int = 3
	case long = 4
	case float = 5
	case double = 6
	case byteList = 7
	case intList = 11
	case longList = 12
	case string = 8
	case list = 9
	case compound = 10
	
	public var description: String {
		switch self {
			case .end:
				return "[end]"
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
			case .byteList:
				return "[byte]"
			case .intList:
				return "[int]"
			case .longList:
				return "[long]"
			case .string:
				return "text"
			case .list:
				return "[*]"
			case .compound:
				return "[string:*]"
		}
	}
}
