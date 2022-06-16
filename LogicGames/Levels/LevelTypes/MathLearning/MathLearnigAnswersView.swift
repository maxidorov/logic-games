//
//  MathLearnigAnswersView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/14/21.
//

import SwiftUI

struct MathLearningAnswersView: View {
  @ObservedObject var viewModel: ObservableViewModel
  let levelId: Int
  let questions: [Math.Question]
  let bottomButtonAction: Action

  private let title = "Answers"
  private let buttonTitle = "Continue"
  private let gradientConfiguration: GradientConfiguration = .mathLearningAnswers
  
  @StateObject private var alertManager = AlertManager()

  var body: some View {
    ZStack() {
      GradientView(.mathLearningAnswers)
        .ignoresSafeArea()

      VStack(spacing: 0) {
        VGradientScrollView(gradientConfiguration) {
          VStack {
            Text(title)
              .font(.system(size: 28))
              .foregroundColor(.white)
              .fontWeight(.bold)
              .padding(.top)

            let itemWidth: CGFloat = 120
            LazyVGrid(
              columns: [GridItem(.adaptive(minimum: itemWidth - 20, maximum: itemWidth))],
              alignment: .center,
              spacing: 23
            ) {
              ForEach(questions.enumerate(), id: \.index) { enumeratedQuestion in
                MathLearningAnswerItemView(question: enumeratedQuestion.element)
              }
            }
          }
          .padding(.horizontal, 14)
        }

        BaseBottomButton(.bottomButton, title: buttonTitle, action: bottomButtonAction)
          .frame(height: 70)
          .padding(.horizontal, 20)
          .padding(.bottom)
      }
    }
    .onAppear {
      viewModel.saveProgress(
        value: countCorrectPercentage(questions),
        for: .mathLearning,
        levelId: levelId
      ) { result in
        switch result {
        case .success:
          break
        case .failure:
          alertManager.show(dismiss: .error())
        }
      }
    }
    .uses(alertManager)
  }

  func countCorrectPercentage(_ questions: [Math.Question]) -> Double {
    let rightAnswers = questions.filter { $0.userAnswer == $0.rightAnswer }.count
    let totalAnswers = questions.count
    return Double(rightAnswers) / Double(totalAnswers)
  }
}

struct MathLearningAnswerItemView: View {
  let question: Math.Question

  var body: some View {
    HStack {
      Spacer()

      Text(question.descriptionWithoutAnswer)
        .foregroundColor(.white)
        .font(.system(size: 20))
        .lineLimit(1)
        .minimumScaleFactor(0.01)

      ZStack {
        Rectangle()
          .foregroundColor(
            question.passed ? Color.black.opacity(0.1) : Color(hex: 0xFF6392)
          )
          .frame(width: 40, height: 40)
          .cornerRadius(6)

        Text("\(question.userAnswer ?? -1)")
          .foregroundColor(.white)
          .font(.system(size: 20))
      }
    }
  }
}

struct MathLearnigAnswersView_Previews: PreviewProvider {
  static var previews: some View {
    let questions = Array<Math.Question>(
      repeating: questionMock,
      count: 100
    )

    Group {
      MathLearningAnswersView(
        viewModel: viewModelMock,
        levelId: 1,
        questions: questions,
        bottomButtonAction: {}
      )

      MathLearningAnswerItemView(question: questionMock)
        .background(Color.cyan)
        .previewLayout(.fixed(width: 130, height: 40))
    }
  }
}
