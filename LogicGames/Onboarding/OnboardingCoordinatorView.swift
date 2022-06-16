//
//  OnboardingCoordinatorView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/28/22.
//

import SwiftUI

struct OnboardingCoordinatorView: View {
  @ObservedObject var viewModel: ObservableViewModel

  @State private var viewNumber: Int
  @State private var needPresentLoadingView = false

  init(viewNumber: Int, viewModel: ObservableViewModel) {
    self.viewNumber = viewNumber
    self.viewModel = viewModel
  }

  var body: some View {
    let nextViewAction = {
      if viewNumber == 3{
        needPresentLoadingView = true
      } else {
        viewNumber += 1
      }
    }

    switch viewNumber {
    case 0:
      OnboardingFirstView(viewModel: viewModel, bottomButtonAction: nextViewAction)
        .slideAnimationTransition()
    case 1:
      OnboardingSecondView(viewModel: viewModel, bottomButtonAction: nextViewAction)
        .slideAnimationTransition()
    case 2:
      OnboardingThirdView(viewModel: viewModel, bottomButtonAction: nextViewAction)
        .slideAnimationTransition()
    case 3:
      OnboardingFourthView(
        viewModel: viewModel,
        crossActionType: .action(nextViewAction),
        onSubcribeActionType: .crossAction
      )
        .slideAnimationTransition()
        .fullScreenCover(isPresented: $needPresentLoadingView) {
          LoadingViewContainer(viewModel: viewModel)
        }
    default:
      fatalError()
    }
  }
}

extension View {
  func slideAnimationTransition() -> some View {
    self
      .animation(.easeInOut)
      .transition(.backslide)
      .transition(.opacity)
  }
}

extension AnyTransition {
  static var backslide: AnyTransition {
    AnyTransition.asymmetric(
      insertion: .move(edge: .trailing),
      removal: .move(edge: .leading))}
}

struct NewOnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingCoordinatorView(viewNumber: 0, viewModel: viewModelMock)
  }
}
