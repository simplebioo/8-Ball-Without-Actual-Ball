//
//  Model.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 12.01.2022.
//

import Foundation

struct AnswerModel: Codable {
    let magic: Magic
}

struct Magic: Codable {
    let answer: String
}
