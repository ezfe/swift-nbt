import Foundation
import DataTools
import MinecraftNBT

let url = URL(fileURLWithPath: "/Users/ezekiel/github-repositories/level.unzipped")
let data = try Data(contentsOf: url)

let structure = try NBTStructure(decompressed: data)
print(structure)
//structure.tag.display(indented: 0)
