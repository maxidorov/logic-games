//
//  QuizMemorizeView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/11/22.
//

import SwiftUI
import Combine

struct QuizQuestionsView: View {
  let levelId: Int
  let quizTitle: String
  @ObservedObject var viewModel: ObservableViewModel
  @ObservedObject var quizQuestionsViewModel: QuizQuestionsViewModel
  private let cancellable: AnyCancellable

  private let levelType: LevelType = .quiz

  @ViewBuilder
  private var circleForImage: some View {
    Circle()
      .foregroundColor(.black.opacity(0.1))
      .frame(squareDimension: screenSize.width * 0.6)
  }

  init(
    levelId: Int,
    quizTitle: String,
    viewModel: ObservableViewModel,
    quizQuestionsViewModel: QuizQuestionsViewModel,
    nextStageAction: @escaping Action
  ) {
    self.levelId = levelId
    self.quizTitle = quizTitle
    self.viewModel = viewModel
    self.quizQuestionsViewModel = quizQuestionsViewModel
    self.cancellable = quizQuestionsViewModel.$stage
      .removeDuplicates()
      .sink { stage in
        guard stage.isFinished else { return }
        nextStageAction()
      }
  }

  var body: some View {
    ZStack {
      GradientView(.quiz)
        .ignoresSafeArea()

      VStack {
        VStack(spacing: 16) {
          Text(quizTitle)
            .font(.system(size: 16))
            .fontWeight(.bold)
            .foregroundColor(.white.opacity(0.5))

          Text(quizQuestionsViewModel.question.question)
            .font(.system(size: 32))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 100)
            .minimumScaleFactor(0.1)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.top)

        Spacer()

        ZStack {
          circleForImage

          quizQuestionsViewModel.image
            .aspectRatio(contentMode: .fit)
            .frame(height: screenSize.width * 0.7)
        }

        Spacer()

        VStack(spacing: 33) {
          Text(quizQuestionsViewModel.stage.subtitle)
            .font(.system(size: 16))
            .fontWeight(.bold)
            .foregroundColor(.white.opacity(0.5))

          switch quizQuestionsViewModel.stage {
          case .learning:
            ZStack {
              Color.black.opacity(0.1)
                .cornerRadius(50)
                .frame(width: 205, height: 140)

              QuizButton(
                title: quizQuestionsViewModel.question.rightAnswer,
                action: quizQuestionsViewModel.next
              )
                .frame(width: 155, height: 90)
            }
          case .asking, .finished:
            QuizAnswersPickerView(
              rightAnswersCount: $quizQuestionsViewModel.rightAnswersCount,
              question: quizQuestionsViewModel.question,
              action: quizQuestionsViewModel.next
            )
              .padding(.horizontal, 25)
          }
        }

        Spacer()
      }
    }
  }
}

struct QuizMemorizeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      QuizQuestionsView(
        levelId: 1,
        quizTitle: "Let's learn capitals",
        viewModel: viewModelMock,
        quizQuestionsViewModel: .init(base: .init(questions: [.init(id: 0, bonusGameId: 0, question: "Question", rightAnswer: "Right answer", fakeAnswers: [], imageName: "")], images: [Image(.level1)])),
        nextStageAction: { }
      )
      
      QuizAnswersPickerView(
        rightAnswersCount: .constant(1),
        question: .init(
          id: 0,
          bonusGameId: 0,
          question: "question",
          rightAnswer: "right",
          fakeAnswers: ["fake", "fake", "fake"],
          imageName: "level1"
        ),
        action: { }
      )
        .previewLayout(.fixed(width: 300, height: 300))
    }
  }
}
