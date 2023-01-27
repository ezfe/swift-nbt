//
//  AnyList.swift
//  
//
//  Created by Ezekiel Elin on 1/26/23.
//

import DataTools

public protocol AnyList: Tag, DataStreamReadable {
	associatedtype Element
	var elements: [Element] { get }
}
