//
//  View+Extension.swift
//  BrainFitness
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import SwiftUI

extension View {
  func border<T: ShapeStyle>(
    _ shapeStyle: T,
    cornerRadius: CGFloat,
    lineWidth: CGFloat
  ) -> some View {
    overlay(
      RoundedRectangle(cornerRadius: cornerRadius)
        .strokeBorder(shapeStyle, lineWidth: lineWidth)
    )
  }

  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  func asButton(action: @escaping Action) -> some View {
    Button(action: action) {
      self
    }
    .buttonStyle(.plain) // MARK need .symbolRenderingMode(.multicolor) for iOS 15?
  }

  func frame(size: CGSize) -> some View {
    frame(
      width: max(size.width, 0),
      height: max(size.height, 0)
    )
  }

  func frame(squareDimension value: CGFloat) -> some View {
    frame(width: value, height: value)
  }

  func hideNavigationBar() -> some View {
    navigationBarHidden(true)
  }

  func embedInNavigationView() -> some View {
    NavigationView {
      hideNavigationBar()
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

  @ViewBuilder
  func center (_ axis: Axis)-> some View {
    switch axis {
    case .horizontal:
      HStack {
        Spacer()
        self
        Spacer()
      }
    case .vertical:
      VStack {
        Spacer()
        self
        Spacer()
      }
    }
  }

  func asAnyView() -> AnyView {
    AnyView(self)
  }

  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
      .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
