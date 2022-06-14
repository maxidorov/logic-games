//
//  MathGenerator.swift
//  BrainFitness
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import CoreGraphics

enum Math {
  enum Operation: CaseIterable {
    case plus
    case minus
    case divide
    case mult

    var description: String {
      switch self {
      case .plus:
        return "+"
      case .minus:
        return "-"
      case .divide:
        return "÷"
      case .mult:
        return "×"
      }
    }

    func callAsFunction(_ a: Int, _ b: Int) -> Int {
      switch self {
      case .plus:
        return a + b
      case .minus:
        return a - b
      case .mult:
        return a * b
      case .divide:
        return a / b
      }
    }
  }

  struct Example: Hashable {
    let a: Int
    let b: Int
    let op: Operation
  }

  struct Question: Hashable {
    let example: Example
    let rightAnswer: Int
    let badAnswers: [Int]
    var wasAsked = false
    var userAnswer: Int?

    var descriptionWithoutAnswer: String {
      "\(example.a) \(example.op.description) \(example.b) ="
    }

    var description: String {
      "\(descriptionWithoutAnswer) \(userAnswer.map { "\($0)" } ?? "?")"
    }

    var passed: Bool {
      userAnswer == rightAnswer
    }

    var allAnswers: [Int] {
      [rightAnswer] + badAnswers
    }
  }
}

let questionMock = Math.Question(
  example: Math.Example(a: 99, b: 99, op: .mult),
  rightAnswer: 9801,
  badAnswers: [4, 15, 13]
)

final class MathGenerator {
  func getNumberOfQuestions(for levelId: Int) -> Int {
    let (operations, count) = getOperationsAndCount(for: levelId)
    return operations.count * count
  }

  func generateQuestions(for levelId: Int) -> [Math.Question] {
    let range: ClosedRange<Int>
    switch levelId {
    case 1, 2:
      range = (1...9)
    case 3, 4:
      range = (1...19)
    case 5, 6:
      range = (1...19)
    case (7...):
      range = (1...29)
    default:
      fatalError()
    }

    let (operations, count) = getOperationsAndCount(for: levelId)
    return generateQuestions(
      range: range,
      operations: operations,
      onEachOperationCount: count
    )
  }

  private func getOperationsAndCount(for levelId: Int) -> ([Math.Operation], Int) {
    let operations: [Math.Operation]
    let onEachOperationCount: Int

    switch levelId {
    case 1:
      operations = [.plus, .minus]
      onEachOperationCount = 10
    case 2:
      operations = [.plus, .minus]
      onEachOperationCount = 15
    case 3:
      operations = [.plus, .minus]
      onEachOperationCount = 20
    case 4:
      operations = [.plus, .minus, .mult]
      onEachOperationCount = 10
    case 5:
      operations = [.plus, .minus, .mult]
      onEachOperationCount = 15
    case 6:
      operations = [.plus, .minus, .mult, .divide]
      onEachOperationCount = 10
    case (7...):
      operations = [.plus, .minus, .mult, .divide]
      onEachOperationCount = 15
    default:
      fatalError()
    }

    return (operations, onEachOperationCount)
  }

  private func generateQuestions(
    range: ClosedRange<Int>,
    operations: [Math.Operation],
    onEachOperationCount count: Int
  ) -> [Math.Question] {
    var questions = [Math.Question]()
    for operation in operations {
      for _ in (0..<count) {
        questions.append(
          generateQuestion(
            range: range,
            operation: operation
          )
        )
      }
    }
    return questions
  }

  private func generateQuestion(
    range: ClosedRange<Int>,
    operation: Math.Operation
  ) -> Math.Question {
    let a: Int
    let b: Int

    switch operation {
    case .plus, .mult:
      a = range.rand
      b = range.rand
    case .minus:
      a = (2...range.upperBound).rand
      b = (range.lowerBound...(a - 1)).rand
    case .divide:
      a = range.suffix(range.count / 2).rand
      b = a.simpleDividers.rand
    }

    return makeQuestion(a, b, operation)
  }

  private func makeQuestion(_ a: Int, _ b: Int, _ op: Math.Operation) -> Math.Question {
    let rightAns = op(a, b)
    return Math.Question(
      example: .init(
        a: a,
        b: b,
        op: op
      ),
      rightAnswer: rightAns,
      badAnswers: generateBadAnswers(a, b, rightAns),
      wasAsked: false,
      userAnswer: nil
    )
  }

  private func generateBadAnswers(_ a: Int, _ b: Int, _ rightAns: Int) -> [Int] {
    var res = [Int]()
    while res.count != 3 {
      let badAns = rightAns + (1...(max(a, b) + 3)).rand * [-1, 1].rand
      if !res.contains(badAns) && badAns > 0 {
        res.append(badAns)
      }
    }
    return res
  }
}

private extension Int {
  var simpleDividers: [Int] {
    var ans = [Int]()
    var x = self
    for i in 2...Int(Double(x).squareRoot() + 1) {
      while x % i == 0 {
        ans.append(i)
        x /= i
      }
    }
    if x != 1  {
      ans.append(x)
    }
    return ans
  }
}

private extension Collection where Element: Comparable {
  var rand: Element {
    randomElement()!
  }
}
