//
//  Network.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/18/21.
//

import SwiftUI

protocol NetworkManaging {
  func fetchImages(names: [String], completion: @escaping NetworkBlock<[Image]>)
  func fetchLevels(completion: @escaping NetworkBlock<[Level]>)
}

final class NetworkManager {
  private let database: DatabaseManaging

  init() {
    self.database = FirebaseManager()
  }
}


extension NetworkManager: NetworkManaging {
  func fetchImages(names: [String], completion: @escaping NetworkBlock<[Image]>) {
    processAsync(items: names, f: database.fetchImage, completion: completion)
  }

  func fetchLevels(completion: @escaping NetworkBlock<[Level]>) {
    database.fetch(type: [LevelDecodable?].self, path: "levels") { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(levels):
        let levels = levels.compactMap { $0 }
        self.fetchImages(names: levels.map(\.imageName)) { imagesResult in
          switch imagesResult {
          case let .success(images):
            let levels = zip(levels, images).map { level, image in
              Level(id: level.id, image: image)
            }
            completion(.success(levels))
          case let .failure(error):
            completion(.failure(error))
          }
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
