//
//  ActivityIndicator.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/19/21.
//

import SwiftUI

public protocol LoadingAnimatable: View {
    var isAnimating: Bool { get }
    var color: Color { get }
    var size: CGSize { get set }
    var strokeLineWidth: CGFloat { get }
}

public struct BarLoadingView: LoadingAnimatable {
  @State private var offset: CGFloat = 0
  public var isAnimating: Bool = true
  public var color: Color = Color(hex: 0x3CE8CD)
  public var size: CGSize = CGSize(width: 200, height: 30)
  public var strokeLineWidth: CGFloat = 3
  public var outlineBarColor: Color = .black.opacity(0.1)

  private var indicatorWidth: CGFloat {
    size.width * 0.3
  }

  private let timer = Timer
    .publish(every: 0, on: .main, in: .common)
    .autoconnect()

  public init(
    isAnimating: Bool = true,
    color: Color = .green,
    size: CGSize = CGSize(width: 200, height: 30),
    strokeLineWidth: CGFloat = 8
  ) {
    self.isAnimating = isAnimating
    self.color = color
    self.size = size
    self.strokeLineWidth = strokeLineWidth
  }

  public var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
      RoundedRectangle(cornerRadius: strokeLineWidth)
        .stroke(outlineBarColor, lineWidth: strokeLineWidth)
        .frame(width: size.width, height: strokeLineWidth)

      GradientView(.bottomButton)
        .cornerRadius(strokeLineWidth)
//        .stroke(color, lineWidth: strokeLineWidth)
        .frame(width: indicatorWidth, height: strokeLineWidth + 8)
        .offset(x: offset, y: 0)
        .animation(Animation.easeInOut(duration: 0.55).repeatForever(autoreverses: true))
        .onReceive(timer) { _ in
          if isAnimating { offset = size.width - indicatorWidth }
        }
    }
  }
}
