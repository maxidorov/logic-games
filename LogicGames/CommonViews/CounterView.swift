//
//  CounterView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct CounterView: View {
  @Binding var currentValue: Int
  let maximumValue: Int

  init(currentValue: Binding<Int>, maximumValue: Int) {
    self._currentValue = currentValue
    self.maximumValue = maximumValue
  }

  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 117, height: 56)
        .foregroundColor(.black.opacity(0.1))
        .cornerRadius(20)

      HStack {
        Text("\(currentValue)")
          .foregroundColor(Color(hex: 0x3CE8CD))
          .fontWeight(.bold)

        Text("/")
          .foregroundColor(.white)
          .fontWeight(.bold)

        Text("\(maximumValue)")
          .foregroundColor(.white)
          .fontWeight(.bold)
      }
      .font(.system(size: 32))
    }
  }
}
