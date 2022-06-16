//
//  OnboardingFirstView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/8/21.
//

import SwiftUI

struct OnboardingFirstView: View {
  @ObservedObject var viewModel: ObservableViewModel
  let bottomButtonAction: Action

  private let title = "Hello! This is a very useful and interesting game in front of you"
  private let subtitle = "It will help you to improve memory, decrease stress and improver your brain activity"
  private let buttonTitle = "Continue"

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack(spacing: 40) {
        Text(title)
          .boldWhite
          .multilineTextAlignment(.center)

        Spacer()

        Image(.onboardingFirstView)

        Spacer()

        Text(subtitle)
          .boldWhite
          .multilineTextAlignment(.center)

        BaseBottomButton(
          .bottomButton,
          title: buttonTitle,
          action: bottomButtonAction
        )
          .frame(height: 70)
          .animation(nil)
      }
      .padding(.top, 40)
      .padding(.horizontal, 18)
      .padding(.bottom)
    }
  }
}

struct OnboardingFirstView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingFirstView(viewModel: viewModelMock, bottomButtonAction: { })
  }
}
