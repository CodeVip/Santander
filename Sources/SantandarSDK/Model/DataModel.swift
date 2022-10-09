//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 04/09/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let success: Bool
    let data: DataCard
    let errorCode: Int
    let message: String
}

// MARK: - DataClass
struct DataCard: Codable {
    let id, status: Int
}

