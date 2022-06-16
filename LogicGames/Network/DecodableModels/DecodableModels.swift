//
//  DecodableModels.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/19/21.
//

import Foundation
import CoreGraphics
import SwiftUI


struct LevelDecodable: Identifiable, Decodable {
  let id: Int
  let number: Int
  let imageName: String

  enum CodingKeys: String, CodingKey {
    case id
    case number
    case imageName = "image_name"
  }
}

struct MinAndUserProgress: Decodable {
  var min: CGFloat
  var user: CGFloat

  enum CodingKeys: String, CodingKey {
    case min = "min_percentage"
    case user = "user_percentage"
  }

  init(min: CGFloat, user: CGFloat) {
    self.min = min
    self.user = user
  }

  init?(_ dict: [String: Double]) {
    guard let min = dict["min_percentage"], let user = dict["user_percentage"] else {
      return nil
    }

    self.init(min: min, user: user)
  }

  var passed: Bool {
    user >= min
  }
}

struct WordDecodable: Equatable, Decodable {
  var levelId: Int
  var languageId: Int
  var name: String
  var imageName: String

  enum CodingKeys: String, CodingKey {
    case levelId = "level_id"
    case languageId = "language_id"
    case imageName = "image_name"
    case name = "name"
  }
}

struct Word: Equatable {
  var levelId: Int
  var languageId: Int
  var name: String
  var imageName: String
  var image: Image?

  init(_ wordDecodable: WordDecodable) {
    self.levelId = wordDecodable.levelId
    self.languageId = wordDecodable.languageId
    self.name = wordDecodable.name
    self.imageName = wordDecodable.imageName
  }
}

extension Word: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(levelId)
    hasher.combine(languageId)
    hasher.combine(name)
    hasher.combine(imageName)
  }
}

struct BonusGame: Decodable {
  let id: Int
  let levelId: Int
  let languageId: Int
  let title: String
  let subtitle: String
  let imageName: String

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case levelId = "level_id"
    case languageId = "language_id"
    case title = "title"
    case subtitle = "subtitle"
    case imageName = "image_name_title"
  }
}

struct BonusGameQuestion: Decodable {
  let id: Int
  let bonusGameId: Int
  let question: String
  let rightAnswer: String
  let fakeAnswers: [String]
  let imageName: String

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case bonusGameId = "bonus_game_id"
    case question = "question"
    case rightAnswer = "right_answer"
    case fakeAnswers = "fake_answers"
    case imageName = "image_name_question"
  }
}
