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
    
    public init(tag: Compound = Compound()) {
        self.tag = tag
    }

    public var data: Data {
        let acc = DataAccumulator()
        self.tag.append(to: acc)
        return acc.data
    }
}
