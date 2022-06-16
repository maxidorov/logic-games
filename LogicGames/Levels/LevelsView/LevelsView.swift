//
//  LevelsView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/10/21.
//

import SwiftUI

struct LevelsView: View {
  @ObservedObject var viewModel: ObservableViewModel
  @ObservedObject var memorizingWordsViewModel: MemorizingWordsViewModel
  @ObservedObject var quizViewModel: QuizViewModel
  @ObservedObject var colorsViewModel: ColorsViewModel

  private let levelViewSize: CGSize = {
    let width = screenSize.width * 0.75
    return CGSize(width: width, height: width / 2)
  }()

  private let stickOffset: CGFloat = 10
  
  private var logoutNavigationLink: some View {
    NavigationLink(destination: LogoutView(viewModel: viewModel), label: {
      Image(systemName: "gearshape")
        .resizable()
    })
    .buttonStyle(.plain)
    .foregroundColor(.white)
  }
  
  @ViewBuilder
  private var topPanel: some View {
    let size: CGFloat = 30
    HStack {
      Color.clear.frame(squareDimension: size)
      Spacer()
      LogicGamesLogo()
      Spacer()
      VStack {
        logoutNavigationLink.frame(squareDimension: size)
        Spacer()
      }
    }
    .padding(.horizontal, 36)
    .padding(.vertical)
  }

  init(viewModel: ObservableViewModel) {
    self.viewModel = viewModel
    self.memorizingWordsViewModel = MemorizingWordsViewModel()
    self.quizViewModel = QuizViewModel()
    self.colorsViewModel = ColorsViewModel()
  }

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        topPanel

        ForEach(viewModel.levels.enumerate(), id: \.index) { enumeratedLevel in
          let level = enumeratedLevel.element
          let levelId = enumeratedLevel.index + 1
          let openLevelMenu = levelOpenLevelMenu(levelId: levelId)
          let isDarkened = levelIsDarkened(levelId: levelId)
          let isTappable = levelIsTappable(levelId: levelId)
          NavigationLink(
            destination: LevelMenuContainerView(
              isActive: openLevelMenu,
              levelId: levelId,
              viewModel: viewModel,
              memorizingWordsViewModel: memorizingWordsViewModel,
              quizViewModel: quizViewModel,
              colorsViewModel: colorsViewModel
            )
          ) {
            let side: Side = (enumeratedLevel.index % 2 == 0) ? .left : .right
            CurveLevelView(
              level: level,
              side: side,
              stickOffset: stickOffset
            )
              .opacity(isDarkened ? 0.5 : 1)
              .frame(size: levelViewSize)
              .padding(.bottom)
              .padding(.horizontal, stickOffset)
          }
          .disabled(!isTappable)
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
    .embedInNavigationView()
    .hideNavigationBar()
    .onAppear(perform: viewModel.checkSubscriptionStatus)
  }

  private func levelIsTappable(levelId: Int) -> Bool {
    viewModel.hasActiveSubscription ? (levelId <= viewModel.lastOpenLevelId) : true
  }

  private func levelOpenLevelMenu(levelId: Int) -> Bool {
    levelId <= (viewModel.hasActiveSubscription ? viewModel.lastOpenLevelId : SubscriptionConfig.freeLevelsCount)
  }
  
  private func levelIsDarkened(levelId: Int) -> Bool {
    levelId > (viewModel.hasActiveSubscription ? viewModel.lastOpenLevelId : SubscriptionConfig.freeLevelsCount + 1)
  }
}

struct LevelsView_Previews: PreviewProvider {
  static var previews: some View {
    LevelsView(viewModel: viewModelMock)
  }
}
