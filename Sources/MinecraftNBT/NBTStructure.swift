//
//  NBTStructure.swift
//  DataTools
//
//  Created by Ezekiel Elin on 5/5/19.
//

import Foundation
import DataTools

public struct NBTStructure {
    public var tag: Compound
    
    public init(decompressed data: Data) {
        let stream = DataStream(data)
        self.tag = Compound.make(with: stream)
    }
    
    public init() {
        self.tag = Compound()
    }
}
