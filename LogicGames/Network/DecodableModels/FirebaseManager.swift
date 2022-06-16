//
//  FirebaseManager.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CodableFirebase
import SwiftUI

enum NetworkingError: Error {
  case decoding
  case storageGetData
  case dataToImageConverting
  case userDoesNotExist
  case unableWriteToDB
}

typealias NetworkResult<T> = Result<T, NetworkingError>
typealias NetworkBlock<T> = (NetworkResult<T>) -> Void

protocol DatabaseManaging {
  func fetch<T: Decodable>(type: T.Type, path: String, completion: @escaping NetworkBlock<T>)
  func fetchImage(name: String, completion: @escaping NetworkBlock<Image>)
  func setInitialProgressIfNeeded(levelsCount: Int, completion: @escaping NetworkBlock<Void>)
  func saveProgress(value: Double, for type: LevelType, levelId: Int, completion: @escaping NetworkBlock<Void>)
  func fetchProgress(levelId: Int, completion: @escaping NetworkBlock<[LevelType: MinAndUserProgress]>)
  func fetchProgress(completion: @escaping NetworkBlock<[Int: [LevelType: MinAndUserProgress]]>)
  func fetchWords(completion: @escaping NetworkBlock<[Word]>)
  func fetchBonusGames(completion: @escaping NetworkBlock<[BonusGame]>)
  func fetchBonusGamesQuestions(bonusGamesIds: [Int], completion: @escaping NetworkBlock<[BonusGameQuestion]>)
}

final class FirebaseManager {
  private let dbRef = Database.database().reference()
  private let storage = Storage.storage()
  private let imageMaxSize: Int64 = 1 * 1024 * 1024
}

extension FirebaseManager: DatabaseManaging {
  func fetch<T>(type: T.Type, path: String, completion: @escaping NetworkBlock<T>) where T : Decodable {
    dbRef.child(path).observe(.value) { snapshot in
      guard let model = snapshot.decode(T.self) else {
        return completion(.failure(.decoding))
      }
      return completion(.success(model))
    }
  }

  func fetchImage(name: String, completion: @escaping NetworkBlock<Image>) {
    storage.reference(withPath: "images/\(name)").getData(maxSize: imageMaxSize) { data, error in
      guard error == nil else {
        return completion(.failure(.storageGetData))
      }

      guard let data = data, let uiImage = UIImage(data: data) else {
        return completion(.failure(.dataToImageConverting))
      }

      return completion(.success(Image(uiImage: uiImage)))
    }
  }

  func setInitialProgressIfNeeded(levelsCount: Int, completion: @escaping NetworkBlock<Void>) {
    guard let userID = Auth.auth().currentUser?.uid else {
      return completion(.failure(.userDoesNotExist))
    }

    let progressRef = Database.database().reference().child(DBPath.progress)
    progressRef.observe(.value) { snapshot in
      guard !snapshot.hasChild(userID) else {
        return completion(.success(()))
      }

      let initialProgressDict = self.makeInitialProgressDict(levelsCount)
      progressRef.child(userID).setValue(initialProgressDict) { error, _ in
        if error != nil {
          return completion(.failure(.unableWriteToDB))
        }
        completion(.success(()))
      }
    }
  }

  func saveProgress(value: Double, for type: LevelType, levelId: Int, completion: @escaping NetworkBlock<Void>) {
    guard let userID = Auth.auth().currentUser?.uid else {
      return completion(.failure(.userDoesNotExist))
    }

    let userProgressRef = Database.database().reference()
      .child(DBPath.progress)
      .child(userID)
      .child("\(levelId)")
      .child(type.databasePath)
      .child(DBPath.userPercentage)

    userProgressRef.setValue(value) { error, _ in
      if error != nil {
        return completion(.failure(.unableWriteToDB))
      }
      completion(.success(()))
    }
  }

  func fetchProgress(levelId: Int, completion: @escaping NetworkBlock<[LevelType: MinAndUserProgress]>) {
    guard let userID = Auth.auth().currentUser?.uid else {
      return completion(.failure(.userDoesNotExist))
    }

    let userProgressRef = Database.database().reference()
      .child(DBPath.progress)
      .child(userID)
      .child("\(levelId)")

    userProgressRef.observe(.value) { [weak self] snapshot in
      guard let self = self else { return }
      completion(self.decodeUserProgress(snapshot: snapshot))
    }
  }

  func fetchProgress(completion: @escaping NetworkBlock<[Int: [LevelType: MinAndUserProgress]]>) {
    guard let userID = Auth.auth().currentUser?.uid else {
      return completion(.failure(.userDoesNotExist))
    }

    let userProgressRef = Database.database().reference()
      .child(DBPath.progress)
      .child(userID)

    userProgressRef.observe(.value) { [weak self] snapshot in
      guard let self = self else { return }
      let snapshots = snapshot.children.allObjects.compactMap { $0 as? DataSnapshot }
      let dict = Dictionary<Int, [LevelType: MinAndUserProgress]>(
        uniqueKeysWithValues: snapshots.enumerate().compactMap {
          let decodedSnapshot = self.decodeUserProgress(snapshot: $0.element)
          switch decodedSnapshot {
          case let .success(dict):
            return ($0.index + 1, dict)
          case .failure:
            return nil
          }
        }
      )
      return completion(.success(dict))
    }
  }

  func fetchWords(completion: @escaping NetworkBlock<[Word]>) {
    let wordsRef = Database.database().reference().child(DBPath.words)
    wordsRef.observe(.value) { snapshot in
      let snapshots = snapshot.children.allObjects.compactMap {
        $0 as? DataSnapshot
      }
      let words = snapshots.compactMap { $0.decode(WordDecodable.self) }
      let filteredByLanguageId = words.filter {
        #warning("HARDCODE: only english words")
        return $0.languageId == 2
      }.map(Word.init)
      return completion(.success(filteredByLanguageId))
    }
  }

  func fetchBonusGames(completion: @escaping NetworkBlock<[BonusGame]>) {
    let bonusGameRef = Database.database().reference().child(DBPath.bonusGames)
    bonusGameRef.observe(.value) { snapshot in
      let snapshots = snapshot.children.allObjects.compactMap {
        $0 as? DataSnapshot
      }
      #warning("HARDCODE: only english words")
      let bonusGames = snapshots
        .compactMap { $0.decode(BonusGame.self) }
        .filter { $0.languageId == 2}

      return completion(.success(bonusGames))
    }
  }

  func fetchBonusGamesQuestions(bonusGamesIds: [Int], completion: @escaping NetworkBlock<[BonusGameQuestion]>) {
    let bonusGamesQuestionsRef = Database.database().reference().child(DBPath.bonusGamesQuestions)
    bonusGamesQuestionsRef.observe(.value) { snapshot in
      let snapshots = snapshot.children.allObjects.compactMap {
        $0 as? DataSnapshot
      }
      let bonusGamesQuestions = snapshots
        .compactMap { $0.decode(BonusGameQuestion.self) }
        .filter { bonusGamesIds.contains($0.bonusGameId) }
      return completion(.success(bonusGamesQuestions))
    }
  }
}

extension FirebaseManager {
  private func makeInitialProgressDict(_ levelsCount: Int) -> [String: [String: [String: Double]]] {
    Dictionary(
      uniqueKeysWithValues: (1...levelsCount).map { levelNumber in
        (
          "\(levelNumber)",
          Dictionary(
            uniqueKeysWithValues: LevelType.allCases.map { $0.databasePath }.map {
              (
                $0,
                [
                  DBPath.minPercentage: 0.8,
                  DBPath.userPercentage: 0
                ]
              )
            }
          )
        )
      }
    )
  }

  private func decodeUserProgress(snapshot: DataSnapshot) -> NetworkResult<[LevelType: MinAndUserProgress]> {
    if let snapshotDict = snapshot.value as? [String: [String: Double]] {
      let mappingDict = LevelType.makeDatabasePathMappingDict()
      var resultDict: [LevelType: MinAndUserProgress] = [:]
      snapshotDict.forEach { pair in
        if let snapshotValue = snapshotDict[pair.key],
           let minAndUserProgress = MinAndUserProgress(snapshotValue),
           let levelType = mappingDict[pair.key] {
          resultDict[levelType] = minAndUserProgress
        }
      }
      return .success(resultDict)
    }
    return .failure(.decoding)
  }
}

extension DataSnapshot {
  func decode<T: Decodable>(_ type: T.Type) -> T? {
    guard let value = value else {
      return nil
    }

    return try? FirebaseDecoder().decode(T.self, from: value)
  }
}
