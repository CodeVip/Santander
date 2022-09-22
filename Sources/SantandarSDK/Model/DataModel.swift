//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 04/09/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
    let support: Support
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let name: String
    let year: Int
    let color, pantoneValue: String

    enum CodingKeys: String, CodingKey {
        case id, name, year, color
        case pantoneValue = "pantone_value"
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
