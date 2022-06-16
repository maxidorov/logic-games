//
//  LevelTypeView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/12/21.
//

import SwiftUI

struct LevelTypeView: View {
  let levelId: Int
  let type: LevelType
  let isPassed: Bool

  private let levelTypeViewRadius: CGFloat = 30

  private var levelTypeDiameter: CGFloat {
    levelTypeViewRadius * 2
  }

  private let stickViewSize: CGFloat = 50

  private let uncompletedColor = Color(hex: 0x07C5A7)

  init(levelId: Int, type: LevelType, isPassed: Bool) {
    self.levelId = levelId
    self.type = type
    self.isPassed = isPassed
  }

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(
          isPassed ? uncompletedColor.opacity(0.1) : .white
        )
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(levelTypeViewRadius)
        .border(
          uncompletedColor.opacity(isPassed ? 0.3 : 0),
          cornerRadius: levelTypeViewRadius,
          lineWidth: 2
        )
        .padding(.top, levelTypeViewRadius)
        .padding(.bottom, stickViewSize / 2)

      VStack {
        LevelTypeIconView(type, borderFilled: !isPassed)
          .frame(width: levelTypeDiameter, height: levelTypeDiameter)

        Spacer()

        VStack(spacing: 16) {
          Text(type.title)
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(isPassed ? .white : .black)

          Text(type.getSubtitle(for: levelId))
            .foregroundColor(
              (isPassed ? Color.white : Color.black).opacity(0.3)
            )
        }

        Spacer()

        RoundGradientStickView(size: stickViewSize)
          .frame(width: stickViewSize, height: stickViewSize)
          .border(
            Color.white,
            cornerRadius: stickViewSize / 2,
            lineWidth: 4
          )
          .opacity(isPassed ? 1 : 0)
      }
    }
  }
}

struct LevelTypeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LevelTypeView(levelId: 1, type: .memorizingWords, isPassed: false)
      LevelTypeView(levelId: 2, type: .quiz, isPassed: true)
    }
    .previewLayout(.fixed(width: 220, height: 220))

  }
}

func makeLevelTypeNavigationLink<Destination: View>(
  to destination: Destination,
  level: Level,
  levelType: LevelType
) -> some View {
  NavigationLink(destination: { destination }) {
    LevelTypeView(
      levelId: level.id,
      type: levelType,
      isPassed: level.progressByType[levelType]!.passed
    )
  }
}
