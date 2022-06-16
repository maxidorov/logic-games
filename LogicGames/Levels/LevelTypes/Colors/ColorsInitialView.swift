//
//  ColorsInitailView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/15/22.
//

import SwiftUI

struct ColorsInitialView: View {
  let levelId: Int
  @ObservedObject private var viewModel: ObservableViewModel
  @ObservedObject private var colorsViewModel: ColorsViewModel
  private let backButtonAction: Action
  private let nextStageAction: Action

  @ViewBuilder
  private var backButton: some View {
    BackButton(.action(backButtonAction))
  }

  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    colorsViewModel: ColorsViewModel,
    backButtonAction: @escaping Action,
    nextStageAction: @escaping Action
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.colorsViewModel = colorsViewModel
    self.backButtonAction = backButtonAction
    self.nextStageAction = nextStageAction
  }

  var body: some View {
    ZStack {
      GradientView(.colors)
        .ignoresSafeArea()

      VStack(spacing: 4) {
        HStack {
          backButton
            .padding([.leading, .top])
          Spacer()
        }

        Image(.headVoice)
          .padding(.vertical, 40)

        Text("Name the colors")
          .font(.system(size: 32))
          .fontWeight(.bold)
          .foregroundColor(.white)
          .minimumScaleFactor(0.1)

        HStack {
          Text("Red")
            .foregroundColor(.cyan)
            .fontWeight(.bold)

          Text("Green")
            .foregroundColor(.yellow)
            .fontWeight(.bold)

          Text("Black")
            .foregroundColor(.red)
            .fontWeight(.bold)
        }
        .font(.system(size: 32))
        .minimumScaleFactor(0.1)
        .opacity(0.85)
        .padding(.bottom, 20)

        Text("Read the colors aloud. It is important to name the color of the text, do not concentrate on what is written.")
          .font(.system(size: 18))
          .fontWeight(.medium)
          .foregroundColor(.white.opacity(0.5))
          .padding(.horizontal, 20)
          .multilineTextAlignment(.center)
          .padding(.bottom, 30)

        ZStack {
          GradientView(.colorsMicro)
            .frame(squareDimension: 130)
            .clipShape(Circle())

          Image(.micro)
        }
        .padding(.bottom, 30)
        .asButton(action: nextStageAction)

        Text("Tap on microphone to start")
          .font(.system(size: 18))
          .fontWeight(.medium)
          .foregroundColor(.white.opacity(0.5))
          .minimumScaleFactor(0.1)

        Spacer()
      }
    }
    .hideNavigationBar()
  }
}

struct ColorsInitailView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsInitialView(
      levelId: 1,
      viewModel: viewModelMock,
      colorsViewModel: ColorsViewModel(),
      backButtonAction: { },
      nextStageAction: { }
    )
  }
}
