//
//  LogicGamesApp.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/8/21.
//

import SwiftUI
import Firebase
import ApphudSDK

@main
struct LogicGamesApp: App {
  @AppStorage("isFirstLaunch") private var isFirstLaunch = true

  private let viewModel: ObservableViewModel
  private var needShowOnboarding = true

  init() {
    FirebaseApp.configure()
    Apphud.start(apiKey: "app_iBpUrXorjLgMaqDNM3h5tBZUXBKZnD")
    
    viewModel = ObservableViewModel()
    needShowOnboarding = isFirstLaunch
    isFirstLaunch = false
  }

  @ViewBuilder
  private var startView: some View {
    if needShowOnboarding {
      OnboardingCoordinatorView(viewNumber: 0, viewModel: viewModel)
        .allowAutoDismiss(false)
    } else {
      if Auth.auth().currentUser == nil {
        OnboardingCoordinatorView(viewNumber: 2, viewModel: viewModel)
      } else {
        LoadingViewContainer(viewModel: viewModel)
      }
    }
  }

  var body: some Scene {
    WindowGroup {
      startView
    }
  }
}
