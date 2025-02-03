//
//  Model.swift
//  practice
//
//  Created by Reekesh Nakarmi on 2/1/25.
//

import Foundation

struct Questions: Codable {
    let question: String
    let options: [String]
    let isMultiSelect: Bool
}

struct QuestionsData: Codable {
    let data: [Questions]
}
