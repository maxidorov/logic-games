//
//  LevelType.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import Foundation
import SwiftUI

enum LevelType: String, CaseIterable {
  case memorizingWords
  case mathLearning
  case quiz
  case colors

  var title: String {
    switch self {
    case .memorizingWords:
      return "Memorizing words"
    case .mathLearning:
      return "Math Learning"
    case .quiz:
      return "Quiz"
    case .colors:
      return "Colors"
    }
  }

  var levelTypeState: LevelTypeState {
    switch self {
    case .memorizingWords:
      return .memorizingWords
    case .mathLearning:
      return .mathLearning
    case .quiz:
      return .quiz
    case .colors:
      return .colors
    }
  }

  var databasePath: String {
    // MARK: make sure ignore title localization!
    title.lowercased().replacingOccurrences(of: " ", with: "_")
  }

  func getSubtitle(for levelId: Int) -> String {
    switch self {
    case .memorizingWords:
      return "20 words"
    case .mathLearning:
      let count = MathGenerator().getNumberOfQuestions(for: levelId)
      return "\(count) exercised"
    case .quiz:
      return "Let's learn Capitals"
    case .colors:
      return "Name the colors out loud"
    }
  }

  @ViewBuilder
  var image: some View {
    switch self {
    case .memorizingWords:
      Image(.levelTypeMemorizingWords)
    case .mathLearning:
      Image(.levelTypeMathLearning)
    case .quiz:
      Image(.levelTypeQuiz)
    case .colors:
      Image(.levelTypeColors)
    }
  }

  var gradientView: GradientView {
    GradientView(gradientConfiguration)
  }

  static func makeDatabasePathMappingDict() -> [String: Self] {
    Dictionary(uniqueKeysWithValues: Self.allCases.map { ($0.databasePath, $0) })
  }

  private var gradientConfiguration: GradientConfiguration {
    switch self {
    case .memorizingWords:
      return .memorizingWordsLevelType
    case .mathLearning:
      return .mathLearningLevelType
    case .quiz:
      return .quizLevelType
    case .colors:
      return .colorsLevelType
    }
  }
}
