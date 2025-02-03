//
//  DataLoader.swift
//  practice
//
//  Created by Reekesh Nakarmi on 2/1/25.
//

import Foundation

struct DataLoader {
    static func loadQuestionsData() -> [Questions]? {
        if let path = Bundle.main.path(forResource: "questions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let questionsData = try JSONDecoder().decode(QuestionsData.self, from: data)
                return questionsData.data
            } catch {
                print("Error loading quiz data: \(error)")
            }
        }
        return nil
    }
}
