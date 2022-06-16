//
//  OnboardingSecondView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/9/21.
//

import SwiftUI

struct OnboardingSecondView: View {
  @ObservedObject var viewModel: ObservableViewModel
  let bottomButtonAction: Action
  
  private let buttonTitle = "Continue"

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack {
        VStack {
          HStack {
            Image(.onboardingSecondView1)
              .resizable()
              .aspectRatio(1, contentMode: .fit)
              .offset(x: -75, y: 0)

            Text("Do you often write down so as not to forget?")
              .boldWhite
              .multilineTextAlignment(.leading)
              .padding(.leading, -100)
              .padding(.trailing)
          }

          Spacer()

          HStack {
            Text("Is it impressive when someone remembers names, dates and titles?")
              .boldWhite
              .multilineTextAlignment(.trailing)
              .padding(.leading)
              .padding(.trailing, -100)
              .zIndex(1)

            Image(.onboardingSecondView2)
              .resizable()
              .aspectRatio(1, contentMode: .fit)
              .offset(x: 75, y: 0)
              .zIndex(0)
          }

          Spacer()

          HStack {
            Image(.onboardingSecondView3)
              .resizable()
              .aspectRatio(1, contentMode: .fit)
              .offset(x: -75, y: 0)

            Text("Play every day and no longer need to write notes!")
              .boldWhite
              .multilineTextAlignment(.leading)
              .padding(.leading, -100)
              .padding(.trailing)
          }
        }
        .padding(.top, 24)

        BaseBottomButton(
          .bottomButton,
          title: buttonTitle,
          action: bottomButtonAction
        )
          .frame(height: 70)
          .padding(.horizontal)
          .padding(.bottom)
          .animation(nil)
      }
    }
  }
}

struct OnboardingSecondView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingSecondView(viewModel: viewModelMock, bottomButtonAction: { })
  }
}
