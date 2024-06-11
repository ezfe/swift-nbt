# Minecraft NBT Reader/Writer for Swift

This package provides a read/write process for Minecraft NBT data structures.

It also has preliminary (not fully tested!) support for using "NBTEncoder" and "NBTDecoder" to decode/encode NBT these structures into Swift classes/structs.

## Quick Start

### Load Data

The data should be the uncompressed stream in `Data` type.

```swift
// Data is the decompressed data of the NBT file
guard var structure = NBTStructure(decompressed: data) else {
    print("Failed to read data")
    exit(0)
}
```

For compressed data, only the `GZip` format can be used.

```swift
// Data is the compressed data of the NBT file
guard var structure = NBTStructure(compressed: data) else {
    print("Failed to read data")
    exit(0)
}
```

The `structure` tag provides:

- A `tag` property which is the compound root tag of the NBT. You can use this tag to manually traverse the NBT structure.
- `read` and `write` functions that both take an array of strings (text or numerical values for indexes and compound tags, respectively) and either a value to write, or return the value found.

### Read

There are two ways to read data.

#### Simple Read

``` swift
try structure.read(["", "Data", "ServerBrands", "0"])
```

#### Layer-by-layer Read

``` swift
// Get compound of NBT file
var compound = structure.tag

// Read data from compound
var keys = compound.contents.keys
var someIntValue = compound["intValue"]
var someStringValue = compound["stringValue"]

// Read data from list
var list = compound["listValue"] as! NBTList
var someValue = list.elements[0]
```
## Note

Level.dat (and others) may have a blank key as the first tag in the structure (seen above in the read command).
