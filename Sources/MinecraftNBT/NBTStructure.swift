//
//  NBTStructure.swift
//  DataTools
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public class NBTStructure {
    public let tag: NBTTag
    
    public init(decompressed data: Data) throws {
        let stream = DataStream(data)
        self.tag = try makeTag(from: stream)
    }
}
