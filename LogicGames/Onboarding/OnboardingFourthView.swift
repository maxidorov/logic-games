//
//  OnboardingFourthView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/9/21.
//

import SwiftUI

struct OnboardingFourthView: View {
  enum CrossActionType {
    case action(Action)
    case dismiss
  }
  
  enum OnSubcribeActionType {
    case crossAction
    case action(Action)
  }

  @ObservedObject var viewModel: ObservableViewModel
  let crossActionType: CrossActionType
  let onSubcribeActionType: OnSubcribeActionType

  @StateObject private var alertManager = AlertManager()
  @StateObject private var subscriptionManager = SubscriptionManager()

  @Environment(\.presentationMode)
  var presentationModeBinding: Binding<PresentationMode>

  private let title = "Buy PRO"
  private let subtitle = "Get unlimited access to tasks for every day. Boost your brain!"
  private let buttonTitle = "Continue with PRO "
  private let whiteWithOpacity = Color.white.opacity(0.5)

  @State private var trialPeriodDescription = ""
  @State private var priceDescription = ""

  private var crossAction: Action {
    switch crossActionType {
    case .action(let action):
      return action
    case .dismiss:
      return { presentationModeBinding.wrappedValue.dismiss() }
    }
  }
  
  private var onSubcribeAction: Action {
    switch onSubcribeActionType {
    case .crossAction:
      return crossAction
    case let .action(action):
      return action
    }
  }

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack(spacing: 40) {
        HStack {
          Button {
            crossAction()
          } label: {
            Image(systemName: "xmark")
              .resizable()
              .frame(width: 19, height: 19)
              .tint(whiteWithOpacity)
          }

          Spacer()
        }

        VStack(spacing: 20) {
          Text(title)
            .boldWhite
            .font(.title)

          Text(subtitle)
            .foregroundColor(whiteWithOpacity)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
        }

        Spacer()

        Image(.onboardingFourthView)

        Spacer()

        VStack(spacing: 16) {
          Text(trialPeriodDescription)
            .boldWhite
            .frame(alignment: .center)

          Text(priceDescription)
            .foregroundColor(whiteWithOpacity)
            .fontWeight(.bold)
            .frame(alignment: .center)
        }
        .opacity(subscriptionManager.paywallLoaded ? 1 : 0)

        if !subscriptionManager.paywallLoaded {
          SwiftUI.ProgressView()
        }

        VStack(spacing: 9) {
          BaseBottomButton(
            .bottomButton,
            title: buttonTitle,
            action: {
              subscriptionManager.makePurchase { result in
                switch result {
                case .success:
                  onSubcribeAction()
                case .failure:
                  alertManager.show(dismiss: .error())
                }
              }
            }
          )
            .frame(height: 70)
            .opacity(subscriptionManager.paywallLoaded ? 1 : 0.2)
            .disabled(!subscriptionManager.paywallLoaded)
            .animation(nil)
          
          PrivacyPolicyFooter()
            .frame(height: 17)
        }
      }
      .padding(.horizontal, 18)
      .padding(.top)
    }
    .onAppear {
      subscriptionManager.getSubscriptionProductInfo { result in
        switch result {
        case let .success(info):
          trialPeriodDescription = "Try \(info.trialPeriod) FREE"
          priceDescription = "Then " + info.readableDescription
        case .failure:
          alertManager.show(dismiss: .error())
        }
      }
    }
    .uses(alertManager)
  }
}

struct OnboardingFourthView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingFourthView(viewModel: viewModelMock, crossActionType: .dismiss, onSubcribeActionType: .crossAction)
  }
}
