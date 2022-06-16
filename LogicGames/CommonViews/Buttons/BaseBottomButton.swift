//
//  BaseButton.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct BaseBottomButton: View {
  let gradientConfiguration: GradientConfiguration
  let title: String
  let action: Action

  private let topColor = Color(hex: 0x3CE8CD)
  private let bottomColor = Color(hex: 0x07C5A7)

  init(
    _ gradientConfiguration: GradientConfiguration,
    title: String,
    action: @escaping Action
  ) {
    self.gradientConfiguration = gradientConfiguration
    self.title = title
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      ZStack {
        GradientView(gradientConfiguration)

        Text(title)
          .boldWhite
      }
    }
    .clipShape(Capsule())
  }
}
