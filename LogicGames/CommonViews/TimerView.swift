//
//  TimerView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI
import Combine

enum TimerState {
  case notStarted, running, paused

  var playingState: PlayingState {
    switch self {
    case .running:
      return .pause
    case .paused, .notStarted:
      return .play
    }
  }
}

class TimerManager: ObservableObject {
  @Published var secondsElapsed: Int
  @Published var timeIsUp: Bool
  @Published var state: TimerState = .notStarted
  private var timer = Timer()

  init(secondsElapsed: Int) {
    self.secondsElapsed = secondsElapsed
    self.timeIsUp = secondsElapsed <= 0
  }

  func start() {
    assert(state == .notStarted)
    
    state = .running
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      switch self.state {
      case .notStarted, .paused:
        break
      case .running:
        if self.secondsElapsed <= 0 {
          timer.invalidate()
          self.timeIsUp = true
          return
        }
        self.secondsElapsed -= 1
      }
    }
  }

  func pause() {
    state = .paused
  }

  func resume() {
    state = .running
  }

  func forceTimeout() {
    timeIsUp = true
    timer.invalidate()
  }
}

struct TimerView: View {
  var secondsElapsed: Int

  var body: some View {
    HStack(spacing: 11) {
      Image(.timer)

      Text(secondsElapsed.secondsTimeFormat)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .font(.system(size: 32))
    }
  }
}

extension Int {
  var secondsTimeFormat: String {
    let m = self / 60
    let s = self % 60
    let sString = s < 10 ? "0\(s)" : "\(s)"
    return "\(m) : \(sString)"
  }
}
