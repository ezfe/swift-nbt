import Foundation
import DataTools
import MinecraftNBT

let structure = try NBTStructure(URL(fileURLWithPath: "/Users/ezekielelin/temp_dev/level.dat"))

structure.tag.display(indented: 0)
