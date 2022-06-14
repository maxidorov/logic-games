//
//  VGradientScrollView.swift
//  BrainFitness
//
//  Created by Maxim V. Sidorov on 12/23/21.
//

import SwiftUI

struct VGradientScrollView<Content> : View where Content : View {
  @ViewBuilder private let contentFactory: () -> Content
  private let gradientHeight: CGFloat = 100
  private let gradientConfiguration: GradientConfiguration

  init(
    showsIndicators: Bool = false,
    _ gradientConfiguration: GradientConfiguration,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.gradientConfiguration = gradientConfiguration
    self.contentFactory = content
  }

  var body: some View {
    ZStack() {
      ScrollView(showsIndicators: false) {
        ZStack(alignment: .bottom) {
          contentFactory()
        }

        Rectangle()
          .foregroundColor(.clear)
          .frame(height: gradientHeight)
      }

      VStack {
        GradientView(gradientConfiguration, opacityDirection: .down)
          .frame(height: gradientHeight)

        Spacer()

        GradientView(gradientConfiguration, opacityDirection: .up)
          .frame(height: gradientHeight)
      }
      .allowsHitTesting(false)
      .ignoresSafeArea()
    }
    .padding(.bottom, -gradientHeight / 2)
  }
}
