//
//  ColorsContainerView.swift
//  LogicGames
//
//  Created by MSP on 17.02.2022.
//

import SwiftUI
import Combine

struct ColorsContainerView: View {
  let levelId: Int
  @ObservedObject private var viewModel: ObservableViewModel
  @ObservedObject private var colorsViewModel: ColorsViewModel
  @Binding private var levelTypeState: LevelTypeState
  private let levelType: LevelType = .colors
  private var cancellables: Set<AnyCancellable> = []
  
  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    colorsViewModel: ColorsViewModel,
    levelTypeState: Binding<LevelTypeState>
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.colorsViewModel = colorsViewModel
    self._levelTypeState = levelTypeState
  }
  
  var body: some View {
    switch colorsViewModel.stage {
    case .initial:
      ColorsInitialView(
        levelId: levelId,
        viewModel: viewModel,
        colorsViewModel: colorsViewModel,
        backButtonAction: openLevelsMenu,
        nextStageAction: { animate(to: .speaking) }
      ).transition(.opacity)
    case .speaking:
      ColorsSpeakingView(
        levelId: levelId,
        viewModel: viewModel,
        colorsViewModel: colorsViewModel,
        nextStageAction: { animate(to: .result) }
      ).transition(.opacity)
    case .result:
      let user = colorsViewModel.correctCount
      let max = colorsViewModel.coloredWords.count
      let userProgress = CGFloat(user) / CGFloat(max)
      LevelResultView(
        .colorsLevelType,
        .numeric(user: user, max: max),
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
          animate(to: .initial) // dummy fix
          colorsViewModel.stopRecording()
          openLevelsMenu()
        }
      ).transition(.opacity)
    }
  }
  
  private func animate(to stage: ColorsViewModel.Stage) {
    withAnimation {
      colorsViewModel.stage = stage
    }
  }

  private func openLevelsMenu() {
    withAnimation {
      levelTypeState = .menu
    }
  }
}

struct ColorsContainerView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsContainerView(
      levelId: 1,
      viewModel: viewModelMock,
      colorsViewModel: ColorsViewModel(),
      levelTypeState: .constant(.menu)
    )
  }
}
