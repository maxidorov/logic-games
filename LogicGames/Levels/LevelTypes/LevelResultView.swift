//
//  LevelResultView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/23/21.
//

import SwiftUI

struct LevelResultView: View {
  enum ResultType {
    case numeric(user: Int, max: Int)
    case image
  }

  private let gradientConfiguration: GradientConfiguration
  private let resultType: ResultType
  @ObservedObject private var viewModel: ObservableViewModel
  private let userProgress: CGFloat
  private let levelPassed: Bool
  private let levelId: Int
  private let levelType: LevelType
  private let bottomButtonAction: Action
  private let circleBorderWidth: CGFloat = 34

  init(
    _ gradientConfiguration: GradientConfiguration,
    _ resultType: ResultType,
    viewModel: ObservableViewModel,
    userProgress: CGFloat,
    levelPassed: Bool,
    levelId: Int,
    levelType: LevelType,
    bottomButtonAction: @escaping Action
  ) {
    self.gradientConfiguration = gradientConfiguration
    self.resultType = resultType
    self.viewModel = viewModel
    self.userProgress = userProgress
    self.levelPassed = levelPassed
    self.levelId = levelId
    self.levelType = levelType
    self.bottomButtonAction = bottomButtonAction
  }

  private var confettiImage: some View {
    Image(.confetti)
      .resizable()
      .frame(size: CGSize(square: screenSize.width * 1.5))
      .aspectRatio(1, contentMode: .fit)
  }

  private var circleSize: CGSize {
    CGSize(square: screenSize.width * 0.6)
  }

  private var circleRadius: CGFloat {
    circleSize.width / 2
  }

  @ViewBuilder
  private var circleView: some View {
    Color.black.opacity(0.1)
      .frame(size: circleSize)
      .cornerRadius(circleRadius)
      .border(
        Color.white.opacity(0.5),
        cornerRadius: circleRadius,
        lineWidth: circleBorderWidth
      )
  }

  @ViewBuilder
  private var inCircleView: some View {
    switch resultType {
    case let .numeric(user, max):
      HStack {
        makeText("\(user)", highlighted: true)
        makeText("/")
        makeText("\(max)")
      }
    case .image:
      Image(levelPassed ? .resultViewLevelPassed : .resultViewLevelFailed)
    }
  }

  private var underCircleView: some View {
    let title: String
    let subtitle: String
    let tryAgain = "Try again"
    switch resultType {
    case .numeric:
      title = levelPassed ? "Cool result!" : tryAgain
      subtitle = "" // FIXME: ?
    case .image:
      title = levelPassed ? "You’ve completed the game!" : tryAgain
      subtitle = "" // FIXME: ?
    }

    return VStack(spacing: 8) {
      Text(title)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .font(.system(size: 32))
        .minimumScaleFactor(0.1)
        .multilineTextAlignment(.center)

      Text(subtitle)
        .foregroundColor(.white.opacity(0.5))
        .font(.system(size: 21))
        .multilineTextAlignment(.center)
    }
  }

  var body: some View {
    ZStack(alignment: .top) {
      GradientView(gradientConfiguration)
        .ignoresSafeArea()

      confettiImage
        .ignoresSafeArea()

      VStack(spacing: 24) {

        Spacer()
        Rectangle()
          .foregroundColor(.clear)
          .frame(height: 100)

        ZStack {
          circleView
          inCircleView
            .frame(size: circleSize.crop(by: circleBorderWidth + 8))
        }

        underCircleView
          .frame(height: 100)

        Spacer()
      }
    }
    .overlay(alignment: .bottom) {
      BaseBottomButton(
        .bottomButton,
        title: "Continue",
        action: bottomButtonAction
      )
      .frame(width: screenSize.width - 20, height: 70)
      .padding([.horizontal, .bottom])
    }
    .hideNavigationBar()
    .onAppear {
      viewModel.saveProgress(
        value: userProgress,
        for: levelType,
        levelId: levelId
      ) { result in
          print(result)
        }
    }
  }

  private func makeText(
    _ title: String,
    highlighted: Bool = false
  ) -> some View {
    Text(title)
      .fontWeight(.bold)
      .font(.system(size: 31))
      .foregroundColor(
        highlighted ? Color(hex: 0x3CE8CD) : Color.white
      )
      .minimumScaleFactor(0.1)
  }
}

struct LevelResultView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LevelResultView(
        .memorizingWordsResult,
        .numeric(user: 10, max: 20),
        viewModel: viewModelMock,
        userProgress: 0.5,
        levelPassed: false,
        levelId: 1,
        levelType: .memorizingWords,
        bottomButtonAction: {}
      )

      LevelResultView(
        .memorizingWordsResult,
        .image,
        viewModel: viewModelMock,
        userProgress: 0.0,
        levelPassed: true,
        levelId: 1,
        levelType: .memorizingWords,
        bottomButtonAction: {}
      )
    }
  }
}

extension CGSize {
  func crop(by inset: CGFloat) -> CGSize {
    CGSize(
      width: width - inset,
      height: height - inset
    )
  }
}
