//
//  LogicGamesLogo.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct LogicGamesLogo: View {
  var body: some View {
    Image(.LogicGamesLogo)
      .resizable()
      .frame(width: 100, height: 120)
      .aspectRatio(0.83, contentMode: .fit)
      .padding(.vertical)
  }
}
