//
//  Images.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/13/21.
//

import SwiftUI

enum ImagesName: String {
  case LogicGamesLogo = "logic-games-logo"
  case stick = "stick"
  case stickBack = "stick-back"

  case level1 = "level-1"
  case level2 = "level-2"
  case level3 = "level-3"
  case level4 = "level-4"

  case curveLevelBackLeft = "curve-level-back-left"
  case curveLevelBackRight = "curve-level-back-right"
  case curveLevelBackCompleteLeft = "curve-level-back-complete-left"
  case curveLevelBackCompleteRight = "curve-level-back-complete-right"

  case levelTypeColors = "colors-icon"
  case levelTypeMathLearning = "math-learning-icon"
  case levelTypeMemorizingWords = "memorizing-words-icon"
  case levelTypeQuiz = "quiz-icon"

  case onboardingFirstView = "onboarding-first-view"
  case onboardingSecondView1 = "onboarding-second-view-1"
  case onboardingSecondView2 = "onboarding-second-view-2"
  case onboardingSecondView3 = "onboarding-second-view-3"
  case onboardingThirdView = "onboarding-third-view"
  case onboardingFourthView = "onboarding-fourth-view"

  case timer = "timer"

  case arrowLeft = "arrow-left"
  case arrowRight = "arrow-right"

  case soundOn = "sound-on"

  case confetti = "confetti"
  
  case resultViewLevelPassed = "result-view-level-passed"
  case resultViewLevelFailed = "result-view-level-failed"

  case headVoice = "head-voice"
  case micro = "micro"
  case microListening = "micro-listening"
}

extension Image {
  init(_ imageName: ImagesName) {
    self.init(imageName.rawValue)
  }
}
