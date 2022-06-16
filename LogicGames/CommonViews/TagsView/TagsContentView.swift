//
//  FlexibleView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/26/21.
//

import SwiftUI

struct TagsContentView: View {
  @ObservedObject private var wordsViewModel: MemorizingWordsViewModel
  private var isTransparent: Bool
  @Binding private var slideShowModeEnabled: Bool
  @Binding private var wordSelectedIndex: Int?

  init(
    wordsViewModel: MemorizingWordsViewModel,
    isTransparent: Bool,
    slideShowModeEnabled: Binding<Bool>,
    wordSelectedIndex: Binding<Int?>
  ) {
    self.wordsViewModel = wordsViewModel
    self.isTransparent = isTransparent
    self._slideShowModeEnabled = slideShowModeEnabled
    self._wordSelectedIndex = wordSelectedIndex
  }

  var body: some View {
    TagsView(
      data: wordsViewModel.wordsFromLevelId.enumerateHashable(),
      spacing: 10,
      alignment: .leading
    ) { item in
      Text(verbatim: item.element.name)
        .font(.system(size: 20))
        .fontWeight(.bold)
        .padding(10)
        .background(Color.white.opacity(isTransparent ? 0.3 : 1))
        .foregroundColor(.black.opacity(isTransparent ? 0.3 : 1))
        .clipShape(Capsule())
        .asButton {
          if wordSelectedIndex == item.index {
            wordSelectedIndex = nil
            slideShowModeEnabled = false
          } else {
            wordSelectedIndex = item.index
            slideShowModeEnabled = true
          }
        }
    }
    .padding(.horizontal, 10)
  }
}
