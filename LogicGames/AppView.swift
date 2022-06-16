//
//  ContentView.swift
//  LogicGames
//
//  Created by MSP on 14.06.2022.
//

import SwiftUI

enum AppState {
  case menu
  case math(level: Int)
}

struct AppView: View {
  @State private var appState: AppState = .menu

  var body: some View {
    switch appState {
    case .menu:
      MenuView(appState: $appState)
        .transition(.opacity)
    case let .math(level):
      MathLearningView.make(
        levelId: level,
        questions: MathGenerator().generateQuestions(for: level),
        appState: $appState
      ).transition(.opacity)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
