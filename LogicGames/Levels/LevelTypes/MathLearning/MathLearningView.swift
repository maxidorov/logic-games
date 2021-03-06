//
//  MathLearningView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import SwiftUI

struct MathLearningView: View {
  static func make(viewModel: ObservableViewModel, levelId: Int, questions: [Math.Question]) -> MathLearningView {
    self.init(
      viewModel: viewModel,
      levelId: levelId,
      questions: questions,
      question: questions[0],
      questionIndex: 0)
  }

  @ObservedObject var viewModel: ObservableViewModel
  let levelId: Int
  @State var questions: [Math.Question]
  @State var question: Math.Question?

  @State var questionIndex: Int {
    didSet {
      question = questions[questionIndex]
    }
  }

  private var currentCounterValue: Int {
    questionIndex + 1
  }

  private let buttonSpacing: CGFloat = 15

  private var buttonSide: CGFloat {
    (screenSize.width - 3 * buttonSpacing) / 2
  }

  @Environment(\.presentationMode)
  private var presentationModeBinding: Binding<PresentationMode>

  var body: some View {
    ZStack {
      GradientView(.mathLearning)
        .ignoresSafeArea()

      VStack {
        HStack {
          Text("Choose correct solution")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 150)

          Spacer()

          CounterView(
            currentValue: .constant(questionIndex + 1),
            maximumValue: questions.count
          )
        }

        Spacer()

        QuestionsFeed($questions, $questionIndex)

        Spacer()

        let answers = questions[questionIndex].allAnswers.shuffled(if: questionIndex != 0)
        
        AnswerButtonsView(
          spacing: buttonSpacing,
          buttonSide: buttonSide,
          answers: answers,
          correctAnswer: questions[questionIndex].rightAnswer
        ) { userAnswer in
          guard questionIndex != questions.count else { return }
          questions[questionIndex].userAnswer = userAnswer
          if questionIndex != questions.count - 1 {
            questionIndex += 1
          } else {
            question = nil
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical)
    }
    .embedInNavigationView()
    .hideNavigationBar()
    .fullScreenCover(isPresented: .constant(question == nil)) {
      MathLearningAnswersView(
        viewModel: viewModel,
        levelId: levelId,
        questions: questions,
        bottomButtonAction: {
          question = questions.last!
          presentationModeBinding.wrappedValue.dismiss()
        }
      )
    }
  }
}

private struct QuestionsFeed: View {
  @Binding var questions: [Math.Question]
  @Binding var questionNumber: Int

  private var text1: String {
    if questionNumber - 1 < 0 {
      return ""
    }
    return questions[questionNumber - 1].description
  }

  private var text2: String {
    questions[questionNumber].description
  }

  private var text3: String {
    if questionNumber >= questions.count - 1 {
      return ""
    }
    return questions[questionNumber + 1].description
  }

  init(
    _ questions: Binding<[Math.Question]>,
    _ questionNumber: Binding<Int>
  ) {
    self._questions = questions
    self._questionNumber = questionNumber
  }

  var body: some View {
    VStack(spacing: 20) {
      Text(text1)
        .foregroundColor(.white.opacity(0.5))
        .font(.system(size: 36))
        .frame(height: 40)

      Text(text2)
        .foregroundColor(.white)
        .font(.system(size: 52))
        .fontWeight(.bold)
        .frame(height: 50)

      Text(text3)
        .foregroundColor(.white.opacity(0.5))
        .font(.system(size: 36))
        .frame(height: 40)
    }
  }
}

struct MathLearningView_Previews: PreviewProvider {
  static var previews: some View {
    let questions = MathGenerator().generateQuestions(for: 1)
    Group {
      MathLearningView.make(
        viewModel: viewModelMock,
        levelId: 1,
        questions: MathGenerator().generateQuestions(for: 1)
      )

//      AnswerButton(number: 20, side: 100, action: { })
//        .previewLayout(.fixed(width: 120, height: 120))

      QuestionsFeed(.constant(questions), .constant(questions.count - 1))
        .previewLayout(.fixed(width: 250, height: 300))
        .background(Color.gray)
    }
  }
}
