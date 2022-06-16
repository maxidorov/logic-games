//
//  LevelWithImageView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/10/21.
//

import SwiftUI

enum Side{
  case left, right
}

struct CurveLevelView: View {
  let level: Level
  let side: Side
  let stickOffset: CGFloat

  @ViewBuilder
  private var backImage: some View {
    getLevelBackImage(
      side: side,
      isCompleted: level.isCompleted
    )
      .makePadding(side: side)
  }

  @ViewBuilder
  private var levelImage: some View {
    level.image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 92)
  }

  @ViewBuilder
  private var content: some View {
    let hStackSpacing: CGFloat = 24
    let imageSidePadding: CGFloat = 24
    let progressSidePadding: CGFloat = 24
    switch side {
    case .left:
      HStack(spacing: hStackSpacing) {
        LevelProgressView(level: level)
          .padding(.vertical, progressSidePadding)

        levelImage
          .padding(.trailing, imageSidePadding)
      }
    case .right:
      HStack(spacing: hStackSpacing) {
        levelImage
          .padding(.leading, imageSidePadding)

        LevelProgressView(level: level)
          .padding(.vertical, progressSidePadding)
      }
    }
  }

  var body: some View {
    ZStack {
      backImage
      content
        .if(level.isCompleted) {
          $0.addStick(offset: stickOffset, side: side)
        }
    }
  }
}

extension View {
  func makePadding(side: Side) -> some View {
    let edge: Edge.Set
    switch side {
    case .left:
      edge = .leading
    case .right:
      edge = .trailing
    }
    return padding(edge, 24)
  }

  func addStick(offset: CGFloat, side: Side) -> some View {
    let alignment: Alignment
    switch side {
    case .left:
      alignment = .topTrailing
    case .right:
      alignment = .topLeading
    }

    return overlay(
      RoundGradientStickView(size: 42).offset(
        x: offset,
        y: -offset
      )
      ,alignment: alignment
    )
  }
}

struct CurveLevelView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CurveLevelView(level: viewModelMock.levels[0], side: .left, stickOffset: 10)
      CurveLevelView(level: viewModelMock.levels[0], side: .right, stickOffset: 10)
    }
      .previewLayout(.fixed(width: 281, height: 146))
  }
}

func getLevelBackImage(side: Side, isCompleted: Bool) -> Image {
  let image: Image
  switch (side, isCompleted) {
  case (.left, false):
    image = Image(.curveLevelBackLeft)
  case (.right, false):
    image = Image(.curveLevelBackRight)
  case (.left, true):
    image = Image(.curveLevelBackCompleteLeft)
  case (.right, true):
    image = Image(.curveLevelBackCompleteRight)
  }
  return image.resizable()
}
