//
//  SpeechSoundSwitcher.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct SpeechSoundSwitcherView: View {
  @Binding var speechOn: Bool

  var body: some View {
    ZStack {
      Color.black.opacity(0.1)

      VStack {
        Toggle(isOn: _speechOn) {
            Text("With speech sound")
            .font(.system(size: 14))
            .fontWeight(.bold)
            .foregroundColor(.white)
        }
        .padding()
        .toggleStyle(SwitchToggleStyle(tint: .blue))
      }
    }
    .frame(height: 50)
    .clipShape(Capsule())
  }
}

struct SpeechSoundSwitcherView_Previews: PreviewProvider {
  static var previews: some View {
    SpeechSoundSwitcherView(speechOn: .constant(true))
  }
}
