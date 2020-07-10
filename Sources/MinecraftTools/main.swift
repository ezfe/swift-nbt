import Foundation
import DataTools
import MinecraftNBT

//let url = URL(fileURLWithPath: "/Users/ezekiel/github-repositories/level.unzipped")
//let data = try Data(contentsOf: url)
//
//let structure = NBTStructure(decompressed: data)
//print(structure)

let ui16: UInt16 = 5

print(ui16)

let acc = DataAccumulator()
ui16.append(to: acc)

let data = acc.data
print(data)

let stream = DataStream(data)
let newui16 = UInt16.make(with: stream)

print(newui16)
