//
//  QuizContainerView.swift
//  LogicGames
//
//  Created by MSP on 20.04.2022.
//

import SwiftUI

final class QuizContainerViewModel: ObservableObject {
  enum Stage {
    case initial
    case quiz
    case result
  }

  @Published var stage: Stage = .initial

  @ObservedObject var quizViewModel: QuizViewModel
  @ObservedObject var quizQuestionsViewModel: QuizQuestionsViewModel

  init(
    quizViewModel: QuizViewModel,
    quizQuestionsViewModel: QuizQuestionsViewModel
  ) {
    self.quizViewModel = quizViewModel
    self.quizQuestionsViewModel = quizQuestionsViewModel
  }

  func animate(to stage: Stage) {
    withAnimation {
      self.stage = stage
    }
  }
}

struct QuizContainerView: View {
  let levelId: Int
  @ObservedObject private var viewModel: ObservableViewModel
  @ObservedObject private var containerViewModel: QuizContainerViewModel
  @Binding private var levelTypeState: LevelTypeState
  private let levelType: LevelType = .quiz

  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    quizViewModel: QuizViewModel,
    quizQuestionsViewModel: QuizQuestionsViewModel,
    levelTypeState: Binding<LevelTypeState>
  ) {
    self.levelId = levelId
    self.viewModel = viewModel

    self.containerViewModel = QuizContainerViewModel(
      quizViewModel: quizViewModel,
      quizQuestionsViewModel: quizQuestionsViewModel
    )

    self._levelTypeState = levelTypeState
  }

  var body: some View {
    switch containerViewModel.stage {
    case .initial:
      QuizInitialView(
        levelId: levelId,
        viewModel: viewModel,
        quizViewModel: containerViewModel.quizViewModel,
        levelTypeState: _levelTypeState,
        nextStageAction: { containerViewModel.animate(to: .quiz) }
      )
    case .quiz:
      QuizQuestionsView(
        levelId: levelId,
        quizTitle: containerViewModel.quizViewModel.model.initial.title,
        viewModel: viewModel,
        quizQuestionsViewModel: containerViewModel.quizQuestionsViewModel,
        nextStageAction: { containerViewModel.animate(to: .result) }
      )
    case .result:
      let max = containerViewModel.quizQuestionsViewModel.base.questions.count
      let user = containerViewModel.quizQuestionsViewModel.rightAnswersCount
      let userProgress = CGFloat(user) / CGFloat(max)
      LevelResultView(
        .quiz,
        .image,
        viewModel: viewModel,
        userProgress: userProgress,
        levelPassed: viewModel.isLevelPassed(
          levelId: levelId,
          type: levelType,
          userProgress: userProgress
        ),
        levelId: levelId,
        levelType: levelType,
        bottomButtonAction: {
          withAnimation {
            levelTypeState = .menu
          }
        }
      )
    }
  }
}

struct QuizContainerView_Previews: PreviewProvider {
  static var previews: some View {
    QuizContainerView(
      levelId: 1,
      viewModel: viewModelMock,
      quizViewModel: .makeMock(),
      quizQuestionsViewModel: .init(base: .init(questions: [.init(id: 0, bonusGameId: 0, question: "Question", rightAnswer: "Right answer", fakeAnswers: [], imageName: "")], images: [Image(.level1)])),
      levelTypeState: .constant(.quiz)
    )
  }
}
