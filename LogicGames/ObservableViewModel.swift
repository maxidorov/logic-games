//
//  ObservableDataModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/18/21.
//

import SwiftUI
import Combine

class ObservableViewModel: ObservableObject {
  @Published var levels: [Level] = []
  @Published var hasActiveSubscription = false
  @Published var lastOpenLevelId = SubscriptionConfig.freeLevelsCount

  private var cancellables = Set<AnyCancellable>()

  init(levels: [Level] = []) {
    self.levels = levels

    $levels
      .map { ($0.firstIndex(where: { !$0.isCompleted }) ?? 0) + 1 }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .assign(to: \.lastOpenLevelId, on: self)
      .store(in: &cancellables)
  }

  private let database: DatabaseManaging = FirebaseManager()
  private let network: NetworkManaging = NetworkManager()
  private let subscriptionManager = SubscriptionManager()

  func fetchLevels(completion: @escaping ErrorBlock) {
    network.fetchLevels { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(levelsCount):
        self.levels = levelsCount
        completion(.success(()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func checkSubscriptionStatus() {
#warning("TODO: remove it, subscription turned off only for first release")
    //hasActiveSubscription = subscriptionManager.hasActiveSubscription()
    hasActiveSubscription = true
  }

  func setInitialProgressIfNeeded(completion: @escaping ErrorBlock) {
    database.setInitialProgressIfNeeded(levelsCount: levels.count) { result in
      switch result {
      case .success:
        completion(.success(()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func saveProgress(value: Double, for type: LevelType, levelId: Int, completion: @escaping ErrorBlock) {
    guard value > levels[levelId - 1].progressByType[type]?.user ?? 0 else {
      return completion(.success(()))
    }

    levels[levelId - 1].progressByType[type]?.user = value
    database.saveProgress(value: value, for: type, levelId: levelId) { result in
      switch result {
      case .success:
        completion(.success(()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func fetchProgress(completion: @escaping ErrorBlock) {
    database.fetchProgress { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(dict):
        dict.forEach { pair in
          self.levels[pair.key - 1].progressByType = pair.value
        }
        completion(.success(()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func isLevelPassed(levelId: Int, type: LevelType, userProgress: CGFloat) -> Bool {
    userProgress >= levels[levelId - 1].progressByType[type]!.min
  }
}
