//
//  QuizButton.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/11/22.
//

import SwiftUI

struct QuizButton: View {
  let title: String
  let action: Action

  var body: some View {
    ZStack {
      GradientView(.white)

      Text(title)
        .font(.system(size: 20))
        .fontWeight(.bold)
        .minimumScaleFactor(0.1)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    .cornerRadius(30)
    .asButton(action: action)
  }
}

struct QuizButton_Previews: PreviewProvider {
  static var previews: some View {
    QuizButton(title: "Paris") {}
      .previewLayout(.fixed(width: 155, height: 90))
  }
}
