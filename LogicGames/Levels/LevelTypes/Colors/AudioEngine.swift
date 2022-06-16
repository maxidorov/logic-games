//
//  AudioEngine.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/24/22.
//

import Foundation
import Speech

final class AudioEngine: NSObject {
  @Published var available = false
  @Published var recognizedText = ""
  
  var previewText = "Go ahead, I'm listening..."
  
  var isRunning: Bool {
    engine.isRunning
  }

  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
  private let engine = AVAudioEngine()

  override init() {
    super.init()
    speechRecognizer.delegate = self
  }

  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
      OperationQueue.main.addOperation {
        switch authStatus {
        case .authorized:
          self?.available = true
          completion(true)
        case .denied, .restricted, .notDetermined:
          self?.available = false
          completion(false)
        @unknown default:
          break
        }
      }
    }
  }

  func startRecording() throws {
    guard !engine.isRunning else {
      return
    }

    recognitionTask?.cancel()
    recognitionTask = nil

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    let inputNode = engine.inputNode

    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let recognitionRequest = recognitionRequest else {
      fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
    }

    recognitionRequest.shouldReportPartialResults = true
    recognitionRequest.requiresOnDeviceRecognition = false

    recognitionTask = speechRecognizer.recognitionTask(
      with: recognitionRequest
    ) { [weak self] result, error in
      guard let self = self else {
        return
      }

      var isFinal = false
      if let result = result {
        self.recognizedText = result.bestTranscription.formattedString.split(separator: " ")
          .map { String(describing: $0).capitalized }
          .map { $0 == "Read" ? "Red" : $0 }
          .joined(separator: " ")
        isFinal = result.isFinal
      }

      if error != nil || isFinal {
        self.engine.stop()
        inputNode.removeTap(onBus: 0)
        self.recognitionRequest = nil
        self.recognitionTask = nil
      }
    }

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(
      onBus: 0,
      bufferSize: 1024,
      format: recordingFormat
    ) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      self.recognitionRequest?.append(buffer)
    }

    engine.prepare()
    try engine.start()

    recognizedText = previewText
  }

  func stopRecording() {
    recognitionTask?.cancel()
    recognitionTask = nil
    engine.stop()
  }
}

extension AudioEngine: SFSpeechRecognizerDelegate {
  func speechRecognizer(
    _ speechRecognizer: SFSpeechRecognizer,
    availabilityDidChange available: Bool
  ) {
    self.available = available
  }
}
