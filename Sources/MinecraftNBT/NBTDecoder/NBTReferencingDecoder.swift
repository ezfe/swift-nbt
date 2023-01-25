//
//  NBTReferencingDecoder.swift
//  
//
//  Created by Ezekiel Elin on 1/24/23.
//

import Foundation

class _NBTReferencingDecoder: _NBTDecoder {
	let decoder: _NBTDecoder
	
	init(referencing decoder: _NBTDecoder, with codingPath: [CodingKey]) {
		self.decoder = decoder
		// placeholder structure not used
		super.init(nbt: NBTStructure(), with: codingPath)
	}
	
	override func storage() -> _NBTDecodingStorage {
		return decoder.storage()
	}
}
