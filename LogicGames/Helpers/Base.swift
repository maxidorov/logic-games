//
//  Base.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/8/21.
//

import UIKit

typealias Action = () -> Void
typealias ErrorBlock = (Result<Void, Error>) -> Void

let screenSize = UIScreen.main.bounds.size

enum PlayingState {
  case play
  case pause

  var isPlaying: Bool {
    switch self {
    case .play:
      return true
    case .pause:
      return false
    }
  }
}

func processAsync<A, B>(
  items: [A],
  f: (A, @escaping NetworkBlock<B>) -> Void,
  completion: @escaping NetworkBlock<[B]>
) {
  let queue = DispatchQueue(label: "sync")
  var remainingTasks = items.count
  var output = [B?](repeating: nil, count: remainingTasks)

  for (index, item) in items.enumerate() {
    f(item) { result in
      switch result {
      case let .success(processed):
        let isComplete = queue.sync { () -> Bool in
          output[index] = processed
          remainingTasks -= 1
          return remainingTasks == 0
        }
        if isComplete {
          return completion(.success(output.compactMap { $0 }))
        }
      case let .failure(error):
        return completion(.failure(error))
      }
    }
  }
}

func modify<T>(
  _ x: inout T,
  _ f: (inout T) -> Void
) {
  f(&x)
}
