//
//  MemorizingWordsAnswers.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/26/21.
//

import SwiftUI

struct MemorizingWordsAnswers: View {
  private let levelId: Int
  private let levelType: LevelType = .memorizingWords
  @ObservedObject private var viewModel: ObservableViewModel
  @ObservedObject private var wordsViewModel: MemorizingWordsViewModel
  @Binding private var canShowResultView: Bool
  private let bottomButtonAction: Action
  @State private var remainingClicksCount: Int

  @State private var resultViewPresented = false

  @State private var correctIndices = Set<Int>()
  @State private var incorrectIndices = Set<Int>()

  private let correctColor = Color(hex: 0x07C5A7)
  private let incorrectColor = Color(hex: 0xEA6058)

  private let gradientConfiguration: GradientConfiguration = .memorizingWordsResult
  private let bottomButtonTitle = "Done"

  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    wordsViewModel: MemorizingWordsViewModel,
    canShowResultView: Binding<Bool>,
    bottomButtonAction: @escaping Action
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.wordsViewModel = wordsViewModel
    self.remainingClicksCount = wordsViewModel.wordsFromLevelId.count
    self._canShowResultView = canShowResultView
    self.bottomButtonAction = bottomButtonAction
  }

  @ViewBuilder
  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Сhose correct words")
          .foregroundColor(.white)
          .font(.system(size: 20))
          .fontWeight(.bold)
          .minimumScaleFactor(0.5)

        Text("\(remainingClicksCount) clicks left")
          .foregroundColor(.white.opacity(0.5))
          .font(.system(size: 16))
          .minimumScaleFactor(0.5)
      }

      Spacer()

      CounterView(
        currentValue: .constant(correctIndices.count),
        maximumValue: wordsViewModel.wordsFromLevelId.count
      )
    }
    .padding(.horizontal, 20)
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      GradientView(gradientConfiguration)
        .ignoresSafeArea()

      VStack {
        VGradientScrollView(gradientConfiguration) {
          VStack {
            headerView

            TagsView(
              data: wordsViewModel.wordsSetForLevelId.enumerateHashable(),
              spacing: 10,
              alignment: .leading
            ) { item in
              Text(item.element.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(10)
                .background(backgroundColor(for: item.index))
                .foregroundColor(foregroundColor(for: item.index))
                .clipShape(Capsule())
                .asButton {
                  if wordsViewModel.wordsFromLevelId.contains(item.element) {
                    correctIndices.insert(item.index)
                  } else if wordsViewModel.othersWords.contains(item.element) {
                    incorrectIndices.insert(item.index)
                  }
                  remainingClicksCount -= 1
                  if remainingClicksCount == 0 {
                    resultViewPresented = true
                  }
                }
            }
            .padding(.horizontal, 10)
          }
        }
        .padding(.bottom)

        BaseBottomButton(.memorizingWordsBottomButtonBlue, title: bottomButtonTitle) {
          resultViewPresented = true
        }
        .frame(height: 70)
        .padding([.bottom, .horizontal])
      }
    }
    .hideNavigationBar()
    .fullScreenCover(isPresented: .constant(resultViewPresented && canShowResultView)) {
      let max = wordsViewModel.wordsFromLevelId.count
      let user = correctIndices.count
      let userProgress =  CGFloat(user) / CGFloat(max)
      LevelResultView(
        gradientConfiguration,
        .numeric(
          user: user,
          max: max
        ),
        viewModel: viewModel,
        userProgress: userProgress,
        levelPassed: viewModel.isLevelPassed(
          levelId: levelId,
          type: levelType,
          userProgress: userProgress
        ),
        levelId: levelId,
        levelType: levelType,
        bottomButtonAction: bottomButtonAction
      )
    }
  }

  private func backgroundColor(for index: Int) -> Color {
    if correctIndices.contains(index) {
      return correctColor
    }
    if incorrectIndices.contains(index) {
      return incorrectColor
    }
    return .white
  }

  private func foregroundColor(for index: Int) -> Color {
    correctIndices.contains(index) || incorrectIndices.contains(index)
      ? .white
      : .black
  }
}

struct MemorizingWordsAnswers_Previews: PreviewProvider {
  static var previews: some View {
    MemorizingWordsAnswers(
      levelId: 1,
      viewModel: viewModelMock,
      wordsViewModel: MemorizingWordsViewModel(),
      canShowResultView: .constant(true),
      bottomButtonAction: {}
    )
  }
}
