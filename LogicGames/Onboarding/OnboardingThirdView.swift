//
//  OnboardingThirdView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/9/21.
//

import SwiftUI

struct OnboardingThirdView: View {
  @ObservedObject var viewModel: ObservableViewModel
  let bottomButtonAction: Action
  
  private let title = "It is very important to save your brain trainings progress"
  private let subtitle = "Just sign in to the app using safest way without passwords"
  private let buttonTitle = "Sign in with Apple"
  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack(spacing: 40) {
        Text(title)
          .boldWhite
          .multilineTextAlignment(.center)

        Spacer()

        Image(.onboardingThirdView)

        Spacer()

        Text(subtitle)
          .boldWhite
          .multilineTextAlignment(.center)
        
        SignInWithAppleToFirebase({ response in
          switch response {
          case .success:
            bottomButtonAction()
          case .error:
            // TODO: error handling
            break
          }
        })
          .frame(height: 70)
          .clipShape(Capsule())
          .animation(nil)
      }
      .padding(.top, 40)
      .padding(.horizontal, 18)
      .padding(.bottom)
    }
  }
}

struct OnboardingThirdView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingThirdView(viewModel: viewModelMock, bottomButtonAction: { })
  }
}
