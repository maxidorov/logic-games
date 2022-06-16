//
//  ColorsViewModel.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/16/22.
//

import SwiftUI
import Combine

final class ColorsViewModel: ObservableObject {
  typealias ColoredWord = (word: String, color: Color)
  
  enum Stage {
    case initial, speaking, result
  }
  
  @Published var stage: Stage = .initial
  
  @Published var audioEngineAvailable = false
  @Published var recognizedText = ""
  @Published var progress: CGFloat = 0
  @Published var correctCount = 0
  var totalCount: Int { coloredWords.count }
  var coloredWords: [ColoredWord] = []
  
  private let audioEngine = AudioEngine()
  private var cancellables: Set<AnyCancellable> = []
  private let colors: [Color] = [.blue, .green, .yellow, .brown, .gray, .pink, .black, .purple, .red, .purple, .cyan, .orange]

  init() {
    audioEngine.$available
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .assign(to: \.audioEngineAvailable, on: self)
      .store(in: &cancellables)
    
    audioEngine.$recognizedText
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .assign(to: \.recognizedText, on: self)
      .store(in: &cancellables)
    
    $recognizedText
      .removeDuplicates()
      .map { text in
        guard text != self.audioEngine.previewText else { return 0 }
        let coloredWordsCount = self.coloredWords.count
        guard coloredWordsCount != 0 else { return 0 }
        let recognizedWordsCount = text.components(separatedBy: " ").count
        return CGFloat(recognizedWordsCount) / CGFloat(coloredWordsCount)
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .assign(to: \.progress, on: self)
      .store(in: &cancellables)
    
    $progress.sink {
      if $0 == 1 {
        DispatchQueue.main.async {
          withAnimation {
            self.stage = .result
          }
        }
      }
    }.store(in: &cancellables)
    
    $recognizedText
      .removeDuplicates()
      .map {
        let correct = $0.orderedIntersections(with: self.coloredWords.map(\.color.description))
        print("CORRECT:", correct)
        return correct
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .assign(to: \.correctCount, on: self)
      .store(in: &cancellables)
  }
  
  func requestAuthorization() {
    audioEngine.requestAuthorization { [weak self] success in
      if success {
        try? self?.audioEngine.startRecording()
      }
    }
  }
  
  func stopRecording() {
    audioEngine.stopRecording()
  }

  func generateColoredWord(levelId: Int) -> [ColoredWord] {
    guard !audioEngine.isRunning || coloredWords.count != levelId * 4 else {
      return coloredWords
    }
    
    coloredWords = (1...levelId * 4).map { _ in getRandomColoredWord() }
    return coloredWords
  }

  private func getRandomColoredWord() -> ColoredWord {
    let twoColors = colors.shuffled().prefix(2)
    return ColoredWord(word: twoColors[0].description.capitalized, twoColors[1])
  }
}

extension String {
  func orderedIntersections(with array: Array<String>) -> Int {
    let sa = split(separator: " ").map { $0.lowercased() }
    var result = 0
    for index in 0..<Swift.min(sa.count, array.count) {
      result += (array[index] == sa[index]) ? 1 : 0
    }
    return result
  }
}
