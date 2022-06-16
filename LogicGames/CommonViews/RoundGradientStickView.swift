//
//  StickView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/11/21.
//

import SwiftUI

struct RoundGradientStickView: View {
  let size: CGFloat

  var body: some View {
    ZStack {
      GradientView(.bottomButton)
      Image(.stick)
    }
    .frame(width: size, height: size)
    .clipShape(Circle())
  }
}

struct RoundGradientStickView_Previews: PreviewProvider {
  static var previews: some View {
    let size: CGFloat = 42
    RoundGradientStickView(size: size)
      .previewLayout(.fixed(width: size, height: size))
  }
}
