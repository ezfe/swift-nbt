import Foundation
import Gzip
import DataTools
import MinecraftNBT

let structure = try NBTStructure(URL(fileURLWithPath: "/Users/ezekielelin/Library/Application Support/minecraft/game-folder/saves/Survival (1_14)/level.dat"))

structure.tag.display(indented: 0)
