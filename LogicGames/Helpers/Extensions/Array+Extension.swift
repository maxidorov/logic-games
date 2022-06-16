//
//  Array+Extension.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/14/21.
//

typealias EnumeratedElement<T> = (index: Int, element: T)

struct EnumeratedHashableElement<T: Hashable>: Hashable {
  let index: Int
  let element: T
}

extension Array {
  func enumerate() -> [EnumeratedElement<Element>] {
    enumerated().map {
      EnumeratedElement<Element>(index: $0.offset, element: $0.element)
    }
  }

  func shuffled(if condition: Bool) -> Self {
    condition ? shuffled() : self
  }
}

extension Array where Element: Hashable {
  func enumerateHashable() -> [EnumeratedHashableElement<Element>] {
    enumerated().map {
      EnumeratedHashableElement<Element>(index: $0.offset, element: $0.element)
    }
  }
}
