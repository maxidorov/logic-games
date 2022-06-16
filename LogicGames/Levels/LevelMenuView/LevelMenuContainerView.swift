//
//  LevelMenuContainerView.swift
//  LogicGames
//
//  Created by MSP on 06.03.2022.
//

import SwiftUI

struct LevelMenuContainerView: View {
  private let isActive: Bool
  private let levelId: Int
  private var viewModel: ObservableViewModel
  private let memorizingWordsViewModel: MemorizingWordsViewModel
  private let quizViewModel: QuizViewModel
  private let colorsViewModel: ColorsViewModel
  private var subscriptionManager: SubscriptionManager

  @State private var hasActiveSubcription: Bool
  @State private var levelTypeState: LevelTypeState = .menu
  
  init(
    isActive: Bool,
    levelId: Int,
    viewModel: ObservableViewModel,
    memorizingWordsViewModel: MemorizingWordsViewModel,
    quizViewModel: QuizViewModel,
    colorsViewModel: ColorsViewModel
  ) {
    self.isActive = isActive
    self.levelId = levelId
    self.viewModel = viewModel
    self.memorizingWordsViewModel = memorizingWordsViewModel
    self.quizViewModel = quizViewModel
    self.colorsViewModel = colorsViewModel
    self.subscriptionManager = SubscriptionManager()
    self.hasActiveSubcription = subscriptionManager.hasActiveSubscription()
  }
  
  var body: some View {
    if isActive || hasActiveSubcription {
      LevelMenuView(
        levelId: levelId,
        viewModel: viewModel,
        memorizingWordsViewModel: memorizingWordsViewModel,
        quizViewModel: quizViewModel,
        colorsViewModel: colorsViewModel,
        levelTypeState: $levelTypeState
      )
        .hideNavigationBar()
        .transition(.opacity)
    } else {
      OnboardingFourthView(
        viewModel: viewModel,
        crossActionType: .dismiss,
        onSubcribeActionType: .action({
          withAnimation {
            self.hasActiveSubcription = subscriptionManager.hasActiveSubscription()
          }
        })
      )
        .hideNavigationBar()
        .transition(.opacity)
    }
  }
} 
