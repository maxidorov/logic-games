//
//  QuizMemorizeViewModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/12/22.
//

import Foundation
import SwiftUI

final class QuizQuestionsViewModel: ObservableObject {
  typealias Base = QuizViewModel.Base

  enum Stage {
    case learning
    case asking
    case finished

    var isFinished: Bool {
      switch self {
      case .learning, .asking:
        return false
      case .finished:
        return true
      }
    }

    var subtitle: String {
      switch self {
      case .learning:
        return "Tap to word"
      case .asking, .finished:
        return "Choose the right word"
      }
    }
  }

  @Published var stage: Stage = .learning
  @Published var rightAnswersCount = 0
  @Published private var index = 0
  let base: Base

  var question: BonusGameQuestion {
    guard (0..<base.questions.count).contains(index) else {
      return BonusGameQuestion(id: 0, bonusGameId: 0, question: "", rightAnswer: "", fakeAnswers: [], imageName: "")
    }
    return base.questions[index]
  }

  @ViewBuilder
  var image: some View {
    switch base.images?[index] {
    case let .some(image):
      image.resizable()
    case .none:
      EmptyView()
    }
  }

  init(base: Base) {
    self.base = base
  }

  func next() {
    if index == base.questions.count - 1 {
      switch stage {
      case .learning:
        stage = .asking
        index = 0
      case .asking:
        stage = .finished
      case .finished:
        break
      }
    } else {
      index += 1
    }
  }
}
