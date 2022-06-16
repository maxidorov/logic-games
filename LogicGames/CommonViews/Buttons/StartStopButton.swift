//
//  StartStopButton.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct StartStopButton: View {
  @Binding var state: PlayingState
  let onPlay: Action
  let onPause: Action

  private var stateImage: Image {
    switch state {
    case .play:
      return Image(systemName: "play.fill")
    case .pause:
      return Image(systemName: "pause.fill")
    }
  }

  var body: some View {
    Button {
      switch state {
      case .play:
        onPlay()
      case .pause:
        onPause()
      }
    } label: {
      ZStack {
        Rectangle()
          .foregroundColor(.black.opacity(0.2))
          .frame(squareDimension: 56)
          .cornerRadius(20)

        stateImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(squareDimension: 26)
          .foregroundColor(.white)
      }
    }
  }
}


struct StartStopButton_Previews: PreviewProvider {
  static var previews: some View {
    StartStopButton(state: .constant(.pause), onPlay: {}, onPause: {})
    .previewLayout(.fixed(width: 220, height: 220))
  }
}
