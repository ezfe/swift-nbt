//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 1/25/23.
//

import Foundation

public typealias LevelDat = [String: LDTopLevel]

public struct LDTopLevel: Codable {
	public let data: LDData
	
	enum CodingKeys: String, CodingKey {
		case data = "Data"
	}
}

public struct LDData: Codable {
	public let version: Int32
	public let thundering: Bool
	public let thunderTime: Int32
	public let raining: Bool
	public let rainTime: Int32
	public let initialized: Bool
	public let hardcore: Bool
	public let clearWeatherTime: Int32
	public let allowCommands: Bool
	public let worldGenSettings: LDWorldGenSettings
	
	enum CodingKeys: String, CodingKey {
		case version, thundering, thunderTime, raining, rainTime, initialized, hardcore, clearWeatherTime, allowCommands
		case worldGenSettings = "WorldGenSettings"
	}
	
	public struct LDWorldGenSettings: Codable {
		public let seed: Int64
		public let generateFeatures: Bool
		public let dimensions: [String: LDDimension]
		public let bonusChest: Bool
		
		enum CodingKeys: String, CodingKey {
			case seed, dimensions
			case generateFeatures = "generate_features"
			case bonusChest = "bonus_chest"
		}
		
		public struct LDDimension: Codable {
			public let type: String
			public let generator: LDGenerator
			
			public struct LDGenerator: Codable {
				public let type: String
				public let settings: String
				public let seed: Int64
				public let biomeSource: LDBiomeSource
				
				enum CodingKeys: String, CodingKey {
					case type, settings, seed
					case biomeSource = "biome_source"
				}
				
				public struct LDBiomeSource: Codable {
					public let type: String
					public let preset: String?
					public let seed: Int64?
				}
			}
		}
	}
}
