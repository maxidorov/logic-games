//
//  MenuView.swift
//  LogicGames
//
//  Created by MSP on 14.06.2022.
//

import SwiftUI

struct MenuView: View {
  @Binding var appState: AppState

  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()

      VStack(spacing: 32) {
        ForEach(Difficulty.allCases) { difficulty in
          DifficultyLevelView(difficulty: difficulty)
            .asButton {
              withAnimation {
                appState = .math(level: difficulty.level)
              }
            }
        }
      }
    }
  }
}

enum Difficulty: String, CaseIterable, Identifiable {
  case easy, medium, hard

  var id: String {
    rawValue
  }

  var color: Color {
    switch self {
    case .easy:
        return .green
    case .medium:
        return .yellow
    case .hard:
        return .red
    }
  }

  var level: Int {
    switch self {
    case .easy:
      return 1
    case .medium:
      return 3
    case .hard:
      return 7
    }
  }
}

private struct DifficultyLevelView: View {
  let difficulty: Difficulty

  var body: some View {
    Text(difficulty.rawValue.capitalized)
      .foregroundColor(.white)
      .font(.system(size: 24))
      .fontWeight(.bold)
      .padding()
      .background(difficulty.color.opacity(0.3))
      .border(
        difficulty.color.opacity(0.7),
        cornerRadius: 16,
        lineWidth: 4
      )
      .cornerRadius(16)
  }
}
