//
//  ClearRectangle.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct EmptyRect: View {
  let size: CGSize

  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: size.width, height: size.height)
  }
}
