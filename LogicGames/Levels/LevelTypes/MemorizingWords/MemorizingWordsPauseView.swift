//
//  MemorizingWordsPauseView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/4/22.
//

import SwiftUI

struct MemorizingWordsPauseView: View {
  let resumeAction: Action

  private let circleBorderWidth: CGFloat = 34

  private var circleSize: CGSize {
    CGSize(square: screenSize.width * 0.6)
  }

  private var circleRadius: CGFloat {
    circleSize.width / 2
  }

  @ViewBuilder
  private var circleView: some View {
    Color.white.opacity(0.2)
      .frame(size: circleSize)
      .cornerRadius(circleRadius)
      .border(
        Color.white.opacity(0.5),
        cornerRadius: circleRadius,
        lineWidth: circleBorderWidth
      )
  }

  var body: some View {
    ZStack {
      GradientView(.memorizingWords)
        .ignoresSafeArea()

      VStack(spacing: 32) {
        Spacer()

        ZStack {
          circleView

          Text("🕑")
            .font(.system(size: 100))
            .minimumScaleFactor(0.1)
        }

        Text("Game paused")
          .font(.system(size: 32))
          .foregroundColor(.white)
          .fontWeight(.bold)

        Spacer()

        BaseBottomButton(.bottomButton, title: "Resume", action: resumeAction)
        .frame(height: 70)
        .padding([.horizontal, .bottom])
      }
    }
  }
}

struct MemorizingWordsPauseView_Previews: PreviewProvider {
  static var previews: some View {
    MemorizingWordsPauseView(resumeAction: {})
  }
}
