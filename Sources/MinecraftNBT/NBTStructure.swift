//
//  NBTStructure.swift
//  DataTools
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public class NBTStructure {
    public let tag: Compound
    
    public init(decompressed data: Data) throws {
        let stream = DataStream(data)
        self.tag = Compound.make(with: stream)
    }
}
