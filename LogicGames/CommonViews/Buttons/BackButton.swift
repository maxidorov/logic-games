//
//  BackButton.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct BackButton: View {
  enum Config {
    case environment(Binding<PresentationMode>)
    case action(Action)

    func callAsFunction() {
      switch self {
      case let .environment(mode):
        mode.wrappedValue.dismiss()
      case let .action(action):
        action()
      }
    }
  }

  let config: Config

  init(_ config: Config) {
    self.config = config
  }

  var body: some View {
    Button(action: { config() }) {
      ZStack {
        Rectangle()
          .foregroundColor(.black.opacity(0.2))
          .frame(squareDimension: 56)
          .cornerRadius(20)

        Image(.stickBack)
      }
    }
  }
}
