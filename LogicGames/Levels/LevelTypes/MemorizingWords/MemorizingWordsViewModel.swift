//
//  MemorizingWordsViewModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/23/21.
//

import SwiftUI
import Combine

class MemorizingWordsViewModel: ObservableObject {
  @Published private var words: [Word] = []
  private let database: DatabaseManaging = FirebaseManager()

  @Published var levelId: Int = 0
  @Published var wordsSetForLevelId: [Word] = []
  @Published var wordsFromLevelId: [Word] = []
  @Published var othersWords: [Word] = []

  private var cancellableSet: Set<AnyCancellable> = []

  private var wordsSetPublisher: AnyPublisher<[Word], Never>  {
    Publishers.CombineLatest(
      $wordsFromLevelId.removeDuplicates(),
      $othersWords.removeDuplicates()
    ).map { goods, bads in
      (goods + bads.shuffled()[0..<self.wordsFromLevelId.count]).shuffled()
    }
    .removeDuplicates()
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }

  init() {
    makeWordsPublisher { levelId, word in word.levelId == levelId }
      .assign(to: \.wordsFromLevelId, on: self)
      .store(in: &cancellableSet)

    makeWordsPublisher { levelId, word in word.levelId != levelId }
      .assign(to: \.othersWords, on: self)
      .store(in: &cancellableSet)

    wordsSetPublisher
      .assign(to: \.wordsSetForLevelId, on: self)
      .store(in: &cancellableSet)
  }

  func fetchWords(onError: @escaping Action) {
    database.fetchWords { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(words):
        self.words = words
      case .failure:
        onError()
      }
    }
  }

  func fetchWordsImages() {
    processAsync(
      items: words.filter { $0.levelId == levelId }.map(\.imageName),
      f: database.fetchImage
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(images):
        let filteredIndices = self.words.enumerate().filter {
          $0.element.levelId == self.levelId
        }.map(\.index)
        for (i, image) in zip(filteredIndices, images) {
          modify(&self.words[i]) { $0.image = image }
        }
      case let .failure(error):
        print(error)
      }
    }
  }

  private func makeWordsPublisher(
    filter: @escaping (Int, Word) -> Bool
  ) -> AnyPublisher<[Word], Never> {
    Publishers.CombineLatest(
      $levelId.removeDuplicates(),
      $words.removeDuplicates()
    )
      .map { levelId, words in
        words.filter { filter(levelId, $0) }
      }
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
