//
//  NBTReferencingEncoder.swift
//  
//
//  Created by Ezekiel Elin on 1/24/23.
//

import Foundation

class _NBTReferencingEncoder: _NBTEncoder {
	let encoder: _NBTEncoder
	
	init(referencing encoder: _NBTEncoder, with codingPath: [CodingKey]) {
		self.encoder = encoder
		super.init(with: codingPath)
	}
	
	override func storage() -> _NBTEncodingStorage {
		return encoder.storage()
	}
}
