# Minecraft NBT Reader/Writer for Swift

This package provides a read/write process for Minecraft NBT data structures.

It also has preliminary (not fully tested!) support for using "NBTEncoder" and "NBTDecoder" to decode/encode NBT these structures into Swift classes/structs.

At this time, you must de-compress the NBT yourself. Once you have the decompressed NBT data, you can create an NBTStructure with that data:

```swift
guard var structure = NBTStructure(decompressed: data) else {
	print("Failed to read data")
	exit(0)
}
```

The `structure` tag provides:

- A `tag` property which is the compound root tag of the NBT. You can use this tag to manually traverse the NBT structure.
- `read` and `write` functions that both take an array of strings (text or numerical values for indexes and compound tags, respectively) and either a value to write, or return the value found.

Sample read:

```swift 
try structure.read(["", "Data", "ServerBrands", "0"])
```

Note: Level.dat (and others) may have a blank key as the first tag in the structure (seen above in the read command).
