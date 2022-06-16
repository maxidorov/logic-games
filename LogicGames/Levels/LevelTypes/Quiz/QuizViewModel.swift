//
//  QuizInitialViewModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/9/22.
//

import SwiftUI

final class QuizViewModel: ObservableObject {
  enum ViewModelState {
    case loading
    case ready
  }

  struct Initial {
    let title: String
    let imageName: String
    let subtitle: String
    let image: Image?
  }

  struct Base {
    let questions: [BonusGameQuestion]
    let images: [Image]?
  }

  struct Model {
    let initial: Initial
    let base: Base
  }

  struct Store {
    var initials: [Initial]
    var bases: [Base]
  }

  @Published var state: ViewModelState = .loading
  @Published var imagesLoaded = false
  @Published private var store = Store(initials: [], bases: [])
  private var levelId: Int = 0

  private let database: DatabaseManaging = FirebaseManager()
  private let network: NetworkManaging = NetworkManager()

  var model: Model {
    let index = levelId - 1
    guard (0..<store.initials.count).contains(index) && (0..<store.bases.count).contains(index) else {
      return Model(initial: .init(title: "", imageName: "", subtitle: "", image: nil), base: .init(questions: [], images: nil))
    }

    return Model(
      initial: store.initials[levelId - 1],
      base: store.bases[levelId - 1]
    )
  }

  func load(levelId: Int, onError: @escaping Action) {
    switch state {
    case .loading:
      database.fetchBonusGames { [weak self] result in
        guard let self = self else { return }
        switch result {
        case let .success(bonusGames):
          let bonusGamesIds = bonusGames.map(\.id)
          self.database.fetchBonusGamesQuestions(bonusGamesIds: bonusGamesIds) { result in
            switch result {
            case let .success(questions):
              self.store = Store(
                initials: bonusGames.map {
                  Initial(title: $0.title, imageName: $0.imageName, subtitle: $0.subtitle, image: nil)
                },
                bases: extractQuestionByBonusGamesIds(
                  bonusGamesIds: bonusGamesIds,
                  questions: questions
                )
              )
              self.updateModelFor(levelId: levelId)
              self.fetchImages(priorityLevelId: levelId)
            case .failure:
              onError()
              return
            }
          }
        case .failure:
          onError()
        }
      }
    case .ready:
      updateModelFor(levelId: levelId)
    }
  }

  private func updateModelFor(levelId: Int) {
    self.levelId = levelId
    self.state = .ready
  }

  private func fetchImages(priorityLevelId: Int) {
    var initials: [Initial] = []
    var basesImages: [[Image]] = Array<[Image]>(repeating: [], count: store.bases.count)

    func updateStore() {
      store.initials = initials
      store.bases = basesImages.enumerate().map {
        Base(
          questions: store.bases[$0.index].questions,
          images: $0.element
        )
      }
    }

    var remaining: Int = 2 {
      didSet {
        guard remaining == 0 else { return }
        updateStore()
        imagesLoaded = true
      }
    }

    let initialImageNames = store.initials.map(\.imageName)
    network.fetchImages(names: initialImageNames) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(images):
        initials = zip(self.store.initials, images).map {
          Initial(title: $0.title, imageName: $0.imageName, subtitle: $0.subtitle, image: $1)
        }
        remaining -= 1
      case let .failure(error):
        print(error)
      }
    }

    var localRemaining = store.bases.count {
      didSet {
        guard localRemaining == 0 else { return }
        remaining -= 1
      }
    }

    for (i, base) in store.bases.enumerated() {
      let basesImageNames = base.questions.map(\.imageName)

      network.fetchImages(names: basesImageNames) { result in
        switch result {
        case let .success(images):
          basesImages[i] = images
          localRemaining -= 1
        case let .failure(error):
          print(error)
        }
      }
    }
  }
}

private func extractQuestionByBonusGamesIds(bonusGamesIds: [Int], questions: [BonusGameQuestion]) -> [QuizViewModel.Base] {
  var questionsByLevels: [[BonusGameQuestion]] = []
  bonusGamesIds.forEach { id in
    questionsByLevels.append(questions.filter { $0.bonusGameId == id })
  }
  return questionsByLevels.map {
    QuizViewModel.Base(questions: $0, images: nil)
  }
}

extension QuizViewModel {
  static func makeMock() -> QuizViewModel {
    let vm = QuizViewModel()
    vm.store = .init(
      initials: [.init(title: "Title", imageName: "", subtitle: "Subtitle", image: nil)],
      bases: [.init(questions: [], images: nil)]
    )
    vm.levelId = 1
    return vm
  }
}
