import Foundation
import DataTools
import MinecraftNBT
import NBTStructures

let url = URL(fileURLWithPath: "/Users/ezekielelin/Library/Application Support/minecraft/saves/New World/level copy")
let data = try Data(contentsOf: url)

var structure = NBTStructure(decompressed: data)
print(structure.tag.description)

let decoder = NBTDecoder()
let decoded = try decoder.decode(LevelDat.self, from: structure)
print(decoded)

//try structure.data.write(to: URL(fileURLWithPath: "/Users/ezekielelin/Library/Application Support/minecraft/saves/New World/level copy_new"))
