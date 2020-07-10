import Foundation
import DataTools
import MinecraftNBT

let url = URL(fileURLWithPath: "/Users/ezekielelin/temp_dev/level.dat.decompressed")
let data = try Data(contentsOf: url)

let structure = NBTStructure(decompressed: data)

try structure.data.write(to: URL(fileURLWithPath: "/Users/ezekielelin/temp_dev/level_rewrite.dat.decompressed"))
