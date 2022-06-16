//
//  Speaker.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/5/22.
//

import AVFoundation

enum Speaker {
  static func speak(_ string: String) {
    let utterance = AVSpeechUtterance(string: string)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
  }
}
