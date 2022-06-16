//
//  ColorsWordsView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/16/22.
//

import SwiftUI

struct ColorsWordsView: View {
  let coloredWords: [ColorsViewModel.ColoredWord]
  let width: CGFloat

  var body: some View {
    let rowsCount = coloredWords.count / 4
    VStack {
      ForEach(0..<rowsCount) { rowIndex in
        HStack {
          ForEach(0..<4) { columnIndex in
            let coloredWord = coloredWords[rowIndex * 4 + columnIndex]
            Text(coloredWord.word)
              .foregroundColor(coloredWord.color)
              .fontWeight(.medium)
              .font(.system(size: 22))
              .minimumScaleFactor(0.5)
              .frame(size: getSize(width: width))
          }
        }
      }
    }
    .background(Color.white)
  }

  private func getSize(width: CGFloat) -> CGSize {
    CGSize(
      width: width / 4,
      height: width * 0.06
    )
  }
}

struct ColorsWordsView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsWordsView(coloredWords: coloredWordsMock + coloredWordsMock, width: 300)
      .previewLayout(PreviewLayout.sizeThatFits)
  }
}

let coloredWordsMock: [ColorsViewModel.ColoredWord] = [
  (word: "Blue", color: .red),
  (word: "Green", color: .yellow),
  (word: "Yellow", color: .green),
  (word: "Brown", color: .purple),
  (word: "Gray", color: .blue),
  (word: "Pink", color: .black),
  (word: "Black", color: .orange),
  (word: "Purple", color: .brown),
  (word: "Gray", color: .blue),
  (word: "Pink", color: .black),
  (word: "Black", color: .orange),
  (word: "Purple", color: .brown),
  (word: "Purple", color: .brown),
]
