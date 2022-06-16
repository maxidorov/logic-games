//
//  LevelMenuView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/12/21.
//

import SwiftUI

enum LevelTypeState {
  case menu
  case memorizingWords
  case mathLearning
  case quiz
  case colors
}

struct LevelMenuView: View {
  @ObservedObject var viewModel: ObservableViewModel
  @ObservedObject var memorizingWordsViewModel: MemorizingWordsViewModel
  @ObservedObject var quizViewModel: QuizViewModel
  @ObservedObject var colorsViewModel: ColorsViewModel
  @Binding private var levelTypeState: LevelTypeState
  private let levelId: Int
  private let level: Level
  private let levelViews: [LevelType: AnyView]
  
  @StateObject private var alertManager = AlertManager()

  @Environment(\.presentationMode)
  private var presentationModeBinding: Binding<PresentationMode>

  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    memorizingWordsViewModel: MemorizingWordsViewModel,
    quizViewModel: QuizViewModel,
    colorsViewModel: ColorsViewModel,
    levelTypeState: Binding<LevelTypeState>
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.memorizingWordsViewModel = memorizingWordsViewModel
    self.quizViewModel = quizViewModel
    self.colorsViewModel = colorsViewModel
    self.level = viewModel.levels[levelId - 1]
    self._levelTypeState = levelTypeState
    self.levelViews = makeLevelViews(
      level: level,
      viewModel: viewModel,
      wordsViewModel: memorizingWordsViewModel,
      quizViewModel: quizViewModel,
      colorsViewModel: colorsViewModel,
      levelTypeState: levelTypeState
    )
  }

  var body: some View {
    switch levelTypeState {
    case .menu:
      ZStack(alignment: .bottomTrailing) {
        GradientView(.onboarding)
          .ignoresSafeArea()

        level.image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 230)
          .offset(x: 60, y: 100)

        ScrollView(showsIndicators: false) {
          VStack(spacing: 34) {

            HStack {
              BackButton(.environment(presentationModeBinding))

              Spacer()

              HStack {
                VStack(spacing: 10) {
                  Text("Level \(level.id)")
                    .foregroundColor(.white)
                    .font(.system(size: 28))
                    .fontWeight(.bold)

                  ProgressView(progress: level.totalProgress)
                    .frame(width: 100)
                }
              }

              Spacer()

              EmptyRect(size: CGSize(square: 56))
            }
            .padding(.horizontal, 20)
            .padding(.top)

            Text(level.subtitle)
              .foregroundColor(.white.opacity(0.5))
              .font(.system(size: 20))
              .fontWeight(.bold)
          }
          .padding(.bottom, 30)

          VStack(spacing: 28) {
            let spacing: CGFloat = 15
            HStack(spacing: spacing) {
              makeLevelTypeButton(for: .memorizingWords)
              makeLevelTypeButton(for: .mathLearning)
            }
            HStack(spacing: spacing) {
              makeLevelTypeButton(for: .quiz)
              makeLevelTypeButton(for: .colors)
            }
          }
          .padding(.horizontal, 20)
        }
      }
      .transition(.opacity)
      .hideNavigationBar()
      .onAppear {
        memorizingWordsViewModel.fetchWords(onError: {
          alertManager.show(dismiss: .error())
        })
      }
      .uses(alertManager)
    case .memorizingWords:
      levelViews[.memorizingWords]!
        .transition(.opacity)
    case .mathLearning:
      levelViews[.mathLearning]!
        .transition(.opacity)
    case .quiz:
      levelViews[.quiz]!
        .transition(.opacity)
    case .colors:
      levelViews[.colors]!
        .transition(.opacity)
    }
  }

  private func makeLevelTypeButton(for type: LevelType) -> some View {
    LevelTypeView(
      levelId: level.id,
      type: type,
      isPassed: level.progressByType[type]!.passed
    ).asButton {
      withAnimation {
        levelTypeState = type.levelTypeState
      }
    }
  }
}

private func makeLevelViews(
  level: Level,
  viewModel: ObservableViewModel,
  wordsViewModel: MemorizingWordsViewModel,
  quizViewModel: QuizViewModel,
  colorsViewModel: ColorsViewModel,
  levelTypeState: Binding<LevelTypeState>
) -> [LevelType: AnyView] {
  var links: [LevelType: AnyView] = [:]

  for type in LevelType.allCases {
    switch type {
    case .memorizingWords:
      links[type] = MemorizingWordsView(
        levelId: level.id,
        viewModel: viewModel,
        wordsViewModel: wordsViewModel
      ).asAnyView()

    case .mathLearning:
      let questions = MathGenerator().generateQuestions(for: level.id)
      links[type] = MathLearningView.make(
        viewModel: viewModel,
        levelId: level.id,
        questions: questions.shuffled()
      ).asAnyView()

    case .quiz:
      links[type] = QuizContainerView(
        levelId: level.id,
        viewModel: viewModel,
        quizViewModel: quizViewModel,
        quizQuestionsViewModel: QuizQuestionsViewModel(base: quizViewModel.model.base),
        levelTypeState: levelTypeState
      ).asAnyView()

    case .colors:
      links[type] = ColorsContainerView(
        levelId: level.id,
        viewModel: viewModel,
        colorsViewModel: colorsViewModel,
        levelTypeState: levelTypeState
      ).asAnyView()
    }
  }

  return links
}

struct LevelMenuView_Previews: PreviewProvider {
  static var previews: some View {
    LevelMenuView(
      levelId: 1,
      viewModel: viewModelMock,
      memorizingWordsViewModel: MemorizingWordsViewModel(),
      quizViewModel: QuizViewModel(),
      colorsViewModel: ColorsViewModel(),
      levelTypeState: .constant(.menu)
    )
  }
}
