import Foundation
import DataTools
import MinecraftNBT

let url = URL(filePath: "/Users/ezekielelin/Library/Application Support/minecraft/saves/New World/level copy")
let data = try Data(contentsOf: url)

var structure = NBTStructure(decompressed: data)

//print(structure.tag.description(indentation: 0))

print(try structure.read("", "Data", "DataPacks", "Enabled") ?? "nil")

try structure.write(StringValue(value: "newpack1"), to: "", "Data", "DataPacks", "Enabled", "1")
try structure.write(StringValue(value: "newpack2"), to: "", "Data", "DataPacks", "Enabled", "2")
try structure.write(StringValue(value: "newpack3"), to: "", "Data", "DataPacks", "Enabled", "3")

print(try structure.read("", "Data", "DataPacks", "Enabled") ?? "nil")

//try structure.data.write(to: URL(fileURLWithPath: "/Users/ezekielelin/Library/Application Support/minecraft/saves/New World/level copy_new"))
