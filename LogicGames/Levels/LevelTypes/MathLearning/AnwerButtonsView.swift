//
//  AnswerButtonsView.swift
//  LogicGames
//
//  Created by MSP on 20.02.2022.
//

import SwiftUI

private var pressEnabled = true

struct AnswerButtonsView: View {
  let spacing: CGFloat
  let buttonSide: CGFloat
  let answers: [Int]
  let correctAnswer: Int
  let nextQuestionAction: (Int) -> Void
  
  @State var colorized = false
  
  var body: some View {
    VStack(spacing: spacing) {
      HStack(spacing: spacing) {
        makeAnswerButton(answers[0])
        makeAnswerButton(answers[1])
      }

      HStack(spacing: spacing) {
        makeAnswerButton(answers[2])
        makeAnswerButton(answers[3])
      }
    }
  }
  
  private func makeAnswerButton(_ number: Int) -> AnswerButton {
    AnswerButton(
      number: number,
      correctAnswer: correctAnswer,
      side: buttonSide,
      nextAnswerAction: {
        nextQuestionAction(number)
      }
    )
  }
}

private struct AnswerButton: View {
  enum ColorState {
    case correct, incorrect, plain
    
    var rectangeColor: Color {
      switch self {
      case .correct:
          return .green
      case .incorrect:
          return .red
      case .plain:
          return .white
      }
    }
    
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
    
    var numberColor: Color {
      switch self {
      case .correct, .incorrect:
        return .white
      case .plain:
        return .black
      }
    }
  }
  let number: Int
  let correctAnswer: Int
  let side: CGFloat
  let nextAnswerAction: Action
  
  @State var colorized = false
  @State var colorState: ColorState = .plain
  
  var rectange: some View {
    GradientView(colorState.rectangleGradient)
      .frame(width: side, height: side)
      .cornerRadius(30)
      
  }
  
  var numberLabel: some View {
    Text("\(number)")
      .font(.system(size: 42))
      .fontWeight(.bold)
      .foregroundColor(colorState.numberColor)
  }

  var body: some View {
    ZStack {
      rectange
      numberLabel
    }
    .asButton {
      guard pressEnabled else { return }
      pressEnabled = false
      
      colorState = (number == correctAnswer) ? .correct : .incorrect

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
        nextAnswerAction()
        colorState = .plain
        pressEnabled = true
      }
    }
  }
}

struct AnwerButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    AnswerButtonsView(spacing: 10, buttonSide: 200, answers: [1, 2, 3, 4], correctAnswer: 1, nextQuestionAction: { _ in })
      .previewLayout(.sizeThatFits)
  }
}
