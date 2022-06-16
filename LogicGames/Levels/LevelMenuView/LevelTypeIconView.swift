//
//  LevelTypeIconView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import SwiftUI

struct LevelTypeIconView: View {
  let type: LevelType
  let borderFilled: Bool
  
  private let size: CGFloat = 60

  init(_ type: LevelType, borderFilled: Bool) {
    self.type = type
    self.borderFilled = borderFilled
  }

  var body: some View {
    ZStack {
      type.gradientView
      type.image
    }
    .clipShape(Circle())
    .border(
      Color.white.opacity(borderFilled ? 1 : 0.3),
      cornerRadius: size / 2,
      lineWidth: 4
    )
  }
}

struct LevelTypeIconView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ForEach(LevelType.allCases, id: \.rawValue) { type in
        LevelTypeIconView(type, borderFilled: true)
      }
    }
    .previewLayout(.fixed(width: 60, height: 60))
  }
}
