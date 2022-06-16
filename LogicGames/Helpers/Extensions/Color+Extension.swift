//
//  Color+Extension.swift
//  BrainFitness
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import SwiftUI

extension Color {
  static func normalized(red: CGFloat, green: CGFloat, blue: CGFloat) -> Color {
    Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
  }

  init(hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 08) & 0xff) / 255,
      blue: Double((hex >> 00) & 0xff) / 255,
      opacity: alpha
    )
  }
}
