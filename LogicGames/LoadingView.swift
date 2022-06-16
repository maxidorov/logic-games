//
//  OnboardingContainerView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/9/21.
//

import SwiftUI

struct LoadingView: View {
  @ObservedObject var viewModel: ObservableViewModel
  var onLoadAction: Action

  @StateObject private var alertManager = AlertManager()

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack(spacing: 80) {
        Image(.LogicGamesLogo)

        BarLoadingView()
      }
    }
    .onAppear {
      viewModel.checkSubscriptionStatus()
      
      let showAlert = {
        alertManager.show(dismiss: .error())
      }

      viewModel.fetchLevels { result in
        switch result {
        case .success:
          viewModel.setInitialProgressIfNeeded { result in
            switch result {
            case .success:
              viewModel.fetchProgress { result in
                switch result {
                case .success:
                  onLoadAction()
                case .failure:
                  showAlert()
                }
              }
            case .failure:
              showAlert()
            }
          }
        case .failure:
          showAlert()
        }
      }
    }
    .uses(alertManager)
  }
}

struct OnboardingContainerView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView(viewModel: viewModelMock, onLoadAction: {})
  }
}
