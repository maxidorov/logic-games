//
//  ContentView.swift
//  LogicGames
//
//  Created by MSP on 14.06.2022.
//

import SwiftUI

struct AppView: View {
  private let level = 1

  var body: some View {
    MathLearningView.make(
      viewModel: ObservableViewModel(),
      levelId: level,
      questions: MathGenerator().generateQuestions(for: level))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
