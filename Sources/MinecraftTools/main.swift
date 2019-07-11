import Foundation
//import Gzip
import DataTools
import MinecraftNBT

let structure = try NBTStructure(URL(fileURLWithPath: "/Users/ezekielelin/temp_dev/level.dat.decompressed"))

structure.tag.display(indented: 0)
