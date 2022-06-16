//
//  GradientView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/10/21.
//

import SwiftUI

enum OpacityDirection {
  case up
  case down
}

struct GradientView: View {
  private let configuration: GradientConfiguration
  private let opacityDirection: OpacityDirection?

  init(
    _ configuration: GradientConfiguration,
    opacityDirection: OpacityDirection? = nil
  ) {
    self.configuration = configuration
    self.opacityDirection = opacityDirection
  }

  var body: some View {
    makeLinearGradient(makeColors(configuration, opacityDirection: opacityDirection))
  }
}

enum GradientConfiguration: Int, CaseIterable {
  case onboarding
  case white
  case progressView
  case bottomButton

  case memorizingWordsLevelType
  case mathLearningLevelType
  case quizLevelType
  case colorsLevelType

  case mathLearning
  case mathLearningAnswers

  case memorizingWords
  case memorizingWordsBottomButtonBlue
  case memorizingWordsBottomButtonOrange
  case memorizingWordsResult

  case quiz

  case colors
  case colorsMicro
  case colorsProgress
  
  case correctGreen
  case incorrectRed
}

private func makeColors(
  _ gradientConfiguration: GradientConfiguration,
  opacityDirection: OpacityDirection?
) -> [Color] {
  let hexs: [UInt]
  switch gradientConfiguration {
  case .onboarding:
    hexs = [0x2C47A6, 0x6831C8, 0xBC78EC]
  case .white:
    hexs = [0xFFFFFF, 0xE5E5E5]
  case .progressView:
    hexs = [0x3CE8CD, 0x07C5A7]
  case .bottomButton:
    hexs = [0x3CE8CD, 0x07C5A7]
  case .memorizingWordsLevelType:
    hexs = [0x2C96A5, 0x2C48A5]
  case .mathLearningLevelType:
    hexs = [0xE56D80, 0x8B4DF7]
  case .quizLevelType:
    hexs = [0xFEAB2F, 0x96317E]
  case .colorsLevelType:
    hexs = [0x89BB36, 0x01535D]
  case .mathLearning:
    hexs = [0xE56D7F, 0x8A4DF8]
  case .mathLearningAnswers:
    hexs = [0x5BCDA4, 0xA3DD5B]
  case .memorizingWords:
    hexs = [0x2C96A5, 0x2C47A5]
  case .memorizingWordsBottomButtonBlue:
    hexs = [0x00BCFF, 0x0093FD]
  case .memorizingWordsBottomButtonOrange:
    hexs = [0xFFA553, 0xE27431]
  case .memorizingWordsResult:
    hexs = [0x893AB9, 0x2C2392]
  case .quiz:
    hexs = [0xFEAB2F, 0x952F7E]
  case .colors:
    hexs = [0x8ABB36, 0x00525E]
  case .colorsMicro:
    hexs = [0x3CE8CD, 0x3CE8CD]
  case .colorsProgress:
    hexs = [0xC8FF6D, 0xBFFF56, 0x9BD08E]
  case .correctGreen:
    hexs = [0x3CE8CD, 0x07C5A7]
  case .incorrectRed:
    hexs = [0xF16E65, 0xDC453A]
  }
  
  var colors = hexs.map { Color(hex: $0) }

  if let opacityDirection = opacityDirection {
    let n = colors.count
    switch opacityDirection {
    case .up:
      colors[0] = colors[n - 1].opacity(0)
    case .down:
      colors[n - 1] = colors[0].opacity(0)
    }
  }

  return colors
}

private func makeLinearGradient(_ colors: [Color]) -> LinearGradient {
  LinearGradient(
    stops: zip(colors, linspace(from: 0, through: 1, in: colors.count)).map {
      .init(color: $0.0, location: $0.1)
    },
    startPoint: .top,
    endPoint: .bottom
  )
}

private func linspace<T>(
  from start: T,
  through end: T,
  in samples: Int
) -> StrideThrough<T> where T: FloatingPoint, T == T.Stride {
  stride(from: start, through: end, by: (end - start) / T(samples))
}


struct GradientView_Previews: PreviewProvider {
  static var previews: some View {
    Group{
      ForEach(GradientConfiguration.allCases, id: \.rawValue) { config in
        GradientView(config)
      }
    }
    .previewLayout(.fixed(width: 50, height: 50))
  }
}
