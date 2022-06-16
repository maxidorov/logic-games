//
//  ActionTimer.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/5/22.
//

import Foundation
import SwiftUI

final class ActionTimer {
  var action: Action?

  private let timeInterval: TimeInterval
  private var timer: Timer

  init(timeInterval: TimeInterval) {
    self.timeInterval = timeInterval
    self.action = nil
    self.timer = Timer()
  }

  func start() {
    timer = Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: true,
      block: { _ in
        self.action?()
      }
    )
  }

  func invalidate() {
    timer.invalidate()
  }
}

