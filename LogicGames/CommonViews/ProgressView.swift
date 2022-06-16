//
//  ProgressView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/10/21.
//

import SwiftUI

struct ProgressView: View {
  private let progress: CGFloat
  private let gradientConfiguration: GradientConfiguration

  init(
    progress: CGFloat,
    gradientConfiguration: GradientConfiguration = .progressView
  ) {
    self.progress = progress
    self.gradientConfiguration = gradientConfiguration
  }

  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(.black.opacity(0.1))

        GradientView(gradientConfiguration)
          .frame(size: makeSize(from: geo))
      }
      .cornerRadius(geo.size.height / 2)
    }
  }

  func makeSize(from geo: GeometryProxy) -> CGSize {
    CGSize(
      width: geo.size.width * progress,
      height: geo.size.height
    )
  }
}

struct ProgressView_Previews: PreviewProvider {
  static var previews: some View {
    ProgressView(progress: 0.5)
      .previewLayout(.fixed(width: 100, height: 12))
  }
}

