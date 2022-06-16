//
//  QuizAnswersPickerView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/12/22.
//

import SwiftUI

private var pressEnabled = true

struct QuizAnswersPickerView: View {
  @Binding var rightAnswersCount: Int
  var question: BonusGameQuestion
  let action: Action
  
  var body: some View {
    let shuffledAnswers = makeShuffledAnswers()
    HStack(spacing: 20) {
      VStack(spacing: 17) {
        makeAnswerButton(title: shuffledAnswers[0])
        makeAnswerButton(title: shuffledAnswers[1])
      }
      
      VStack(spacing: 17) {
        makeAnswerButton(title: shuffledAnswers[2])
        makeAnswerButton(title: shuffledAnswers[3])
      }
    }
  }
  
  private func makeAnswerButton(title: String) -> AnswerButton {
    AnswerButton(
      title: title,
      rightAnswer: question.rightAnswer,
      nextQuestionAction: {
        if title == question.rightAnswer {
          rightAnswersCount += 1
        }
        action()
      }
    )
  }
  
  func makeShuffledAnswers() -> [String] {
    ([question.rightAnswer] + question.fakeAnswers).shuffled()
  }
}

private struct AnswerButton: View {
  enum ColorState {
    case correct, incorrect, plain
    
    var rectangleGradient: GradientConfiguration {
      switch self {
      case .correct:
        return .correctGreen
      case .incorrect:
        return .incorrectRed
      case .plain:
        return .white
      }
    }
    
    var titleColor: Color {
      switch self {
      case .correct, .incorrect:
        return .white
      case .plain:
        return .black
      }
    }
  }
  
  var title: String
  var rightAnswer: String
  var nextQuestionAction: Action
  
  @State var colorState: ColorState = .plain
  
  var body: some View {
    ZStack {
      GradientView(colorState.rectangleGradient)
        .cornerRadius(30)
      
      Text(title)
        .foregroundColor(colorState.titleColor)
        .font(.system(size: 20))
        .fontWeight(.medium)
        .minimumScaleFactor(0.1)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    .asButton {
      guard pressEnabled else { return }
      pressEnabled = false
      
      colorState = (title == rightAnswer) ? .correct : .incorrect
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
        nextQuestionAction()
        colorState = .plain
        pressEnabled = true
      }
    }
  }
}

struct QuizAnswersPickerView_Previews: PreviewProvider {
  static var previews: some View {
    QuizAnswersPickerView(
      rightAnswersCount: .constant(0),
      question: .init(
        id: 0,
        bonusGameId: 0,
        question: "Question?",
        rightAnswer: "1",
        fakeAnswers: ["2", "3", "4"],
        imageName: ""
      ),
      action: { }
    )
  }
}
