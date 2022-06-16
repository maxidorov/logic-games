//
//  LevelProgressView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/10/21.
//

import SwiftUI

struct LevelProgressView: View {
  let level: Level

  var body: some View {
    ZStack {
      GradientView(.white)

      VStack {
        Text("Level \(level.id)")
          .font(.system(size: 20))
          .fontWeight(.bold)

        ProgressView(progress: level.totalProgress)
          .frame(height: 12)
          .padding(.horizontal)
      }
    }
    .cornerRadius(30)
  }
}

struct LevelProgressView_Previews: PreviewProvider {
  static var previews: some View {
    LevelProgressView(level: viewModelMock.levels[0])
      .previewLayout(.fixed(width: 155, height: 90))
  }
}
