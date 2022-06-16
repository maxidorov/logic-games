//
//  MemorizingWordsCard.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/17/21.
//

import SwiftUI

struct MemorizingWordsCardView: View {
  enum ArrowSide {
    case left, right
  }

  @ObservedObject private var wordsViewModel: MemorizingWordsViewModel
  @Binding private var selectedIndex: Int
  @Binding private var speechOn: Bool

  private let arrowSide: CGFloat = 60
  private let arrowBackgroundColor = Color(hex: 0x2C6FA5)
  private let textHeight: CGFloat = 40
  private let imageHorizontalPadding: CGFloat = 20
  private let soundIconSide: CGFloat = 48

  private var backgroundView: some View {
    Color.white
      .cornerRadius(30)
      .padding(.horizontal, arrowSide / 2)
  }

  private var imageHolder: some View {
    let view: AnyView
    if let image = wordsViewModel.wordsFromLevelId[selectedIndex].image {
      view = AnyView(image.resizable())
    } else {
      view = AnyView(SwiftUI.ProgressView().foregroundColor(.gray))
    }
    return view
      .aspectRatio(1, contentMode: .fit)
      .padding(.horizontal, arrowSide + imageHorizontalPadding)
  }

  private var selectedWordName: String {
    wordsViewModel.wordsFromLevelId[selectedIndex].name
  }

  init(
    wordsViewModel: MemorizingWordsViewModel,
    selectedIndex: Binding<Int>,
    speechOn: Binding<Bool>
  ) {
    self.wordsViewModel = wordsViewModel
    self._selectedIndex = selectedIndex
    self._speechOn = speechOn
  }

  var body: some View {
    ZStack {
      backgroundView

      HStack {
        makeCircle(.left)
          .asButton{
            selectedIndex = max(0, selectedIndex - 1)
          }
        Spacer()
        makeCircle(.right)
          .asButton {
            selectedIndex = min(wordsViewModel.wordsFromLevelId.count - 1, selectedIndex + 1)
          }
      }

      VStack {
        HStack(spacing: 20) {

          EmptyRect(size: CGSize(square: soundIconSide))

          Text(selectedWordName)
            .font(.system(size: 32))
            .fontWeight(.bold)
            .frame(height: textHeight)
            .minimumScaleFactor(0.5)

          ZStack {
            Rectangle()
              .frame(squareDimension: soundIconSide)
              .foregroundColor(Color(hex: 0x2C47A5).opacity(0.1))
              .cornerRadius(10)

            Image(.soundOn)
              .asButton {
                Speaker.speak(selectedWordName)
              }
          }
        }

        Spacer()

        imageHolder

        Spacer()

        Text("\(selectedIndex + 1) / \(wordsViewModel.wordsFromLevelId.count)")
          .font(.system(size: 16))
          .fontWeight(.bold)
          .frame(height: textHeight)
      }
      .padding(.vertical, 20)
    }
    .onAppear(perform: {
      if speechOn {
        Speaker.speak(selectedWordName)
      }
    })
    .onChange(of: selectedIndex) { _ in
      if speechOn {
        Speaker.speak(selectedWordName)
      }
    }
  }

  private func makeCircle(_ side: ArrowSide) -> some View {
    ZStack {
      Circle()
        .foregroundColor(arrowBackgroundColor)
        .frame(squareDimension: arrowSide)
        .border(Color.white, cornerRadius: arrowSide / 2, lineWidth: 4)

      let offsetX: CGFloat = 3
      switch side {
      case .left:
        Image(.arrowLeft)
          .offset(x: -offsetX, y: 0)
      case .right:
        Image(.arrowRight)
          .offset(x: offsetX, y: 0)
      }
    }
  }
}

struct MemorizingWordsCard_Previews: PreviewProvider {
  static var previews: some View {
    MemorizingWordsCardView(
      wordsViewModel: MemorizingWordsViewModel(),
      selectedIndex: .constant(0),
      speechOn: .constant(false)
    )
      .previewLayout(.fixed(width: 300, height: 350))
      .background(Color.gray)
  }
}
