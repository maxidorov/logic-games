//
//  DataModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/14/21.
//

import CoreGraphics
import SwiftUI

struct UserData {
  let levels: [Level]
}

struct Level {
  let id: Int
  let image: Image
  var types: [LevelType] {
    [
      .memorizingWords,
      .mathLearning,
      .quiz,
      .colors
    ]
  }

  var progressByType = Dictionary(uniqueKeysWithValues: LevelType.allCases.map {
    ($0, MinAndUserProgress(min: 0.8, user: 0))
  })

  var totalProgress: CGFloat {
    CGFloat(numberOfCompleted) / CGFloat(progressByType.count)
  }

  var isCompleted: Bool {
    progressByType.map(\.value).allSatisfy { $0.user >= $0.min }
  }

  var numberOfCompleted: Int {
    progressByType.map(\.value).filter { $0.user >= $0.min }.count
  }

  var subtitle: String {
    switch numberOfCompleted {
    case 0:
      return "Start a new level!"
    case (1..<types.count):
      return "\(numberOfCompleted) of \(types.count) completed to close level"
    case types.count:
      return "Level passed!"
    default:
      return ""
    }
  }
}

let viewModelMock = ObservableViewModel(
  levels: [
    Level(id: 1, image: Image(.level1)),
    Level(id: 2, image: Image(.level2)),
    Level(id: 3, image: Image(.level3)),
    Level(id: 4, image: Image(.level4))
  ]
)
