//
//  SlideshowView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct SlideshowView: View {
  let size: CGFloat
  @Binding var slideshowModeEnabled: Bool

  var body: some View {
    ZStack {
      GradientView(slideshowModeEnabled ? .memorizingWordsBottomButtonOrange : .memorizingWordsBottomButtonBlue)
      
      Image(systemName: slideshowModeEnabled ? "xmark" : "play.rectangle.fill")
        .resizable()
        .renderingMode(.template)
        .foregroundColor(.white)
        .aspectRatio(contentMode: .fit)
        .frame(width: size * 0.5)
    }
    .frame(width: size, height: size)
    .cornerRadius(20)
  }
}

struct SlideshowView_Previews: PreviewProvider {
  static var previews: some View {
    let size: CGFloat = 56
    SlideshowView(size: size, slideshowModeEnabled: .constant(false))
      .previewLayout(.fixed(width: size, height: size))
  }
}
