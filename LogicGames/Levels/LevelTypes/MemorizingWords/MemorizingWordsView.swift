//
//  WordsTagsView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct MemorizingWordsView: View {
  let levelId: Int
  @ObservedObject var viewModel: ObservableViewModel
  @ObservedObject var wordsViewModel: MemorizingWordsViewModel

  @State private var slideShowModeEnabled = false
  @State private var wordSelectedIndex: Int?
  private let gradientConfiguration: GradientConfiguration = .memorizingWordsLevelType
  private let bottomButtonHeight: CGFloat = 70
  private let speechSoundSwitcherViewHeight: CGFloat = 40
  private let padding: CGFloat = 20
  @StateObject private var timerManager = TimerManager(secondsElapsed: 60)
  @State private var canShowAnswersView = true
  @State private var canShowResultView = true
  @State private var speechOn = false
  private let actionTimer = ActionTimer(timeInterval: 2)

  private var selectedWordName: String {
    wordsViewModel.wordsFromLevelId[wordSelectedIndex ?? 0].name
  }

  @Environment(\.presentationMode)
  private var presentationModeBinding: Binding<PresentationMode>

  var body: some View {
    ZStack {
      GradientView(gradientConfiguration)
        .ignoresSafeArea()

      VStack(spacing: padding) {
        VGradientScrollView(gradientConfiguration) {
          VStack {
            HStack {
              StartStopButton(
                state: .constant(timerManager.state.playingState),
                onPlay: timerManager.resume,
                onPause: timerManager.pause
              )
              Spacer()
              TimerView(secondsElapsed: timerManager.secondsElapsed)
              Spacer()
              SlideshowView(size: 56, slideshowModeEnabled: $slideShowModeEnabled)
                .asButton {
                  wordSelectedIndex = slideShowModeEnabled ? nil : 0
                  slideShowModeEnabled.toggle()
                  if slideShowModeEnabled {
                    actionTimer.invalidate()
                    actionTimer.action = {
                      if !timerManager.state.playingState.isPlaying {
                        if wordSelectedIndex != wordsViewModel.wordsFromLevelId.count - 1 {
                          wordSelectedIndex = (wordSelectedIndex ?? 0) + 1
                        } else {
                          slideShowModeEnabled = false
                          wordSelectedIndex = nil
                          actionTimer.invalidate()
                        }
                      }
                    }
                    actionTimer.start()
                  } else {
                    actionTimer.invalidate()
                  }
                }
            }

            TagsContentView(
              wordsViewModel: wordsViewModel,
              isTransparent: slideShowModeEnabled || wordSelectedIndex != nil,
              slideShowModeEnabled: $slideShowModeEnabled,
              wordSelectedIndex: $wordSelectedIndex
            )
          }
        }
        .padding(.horizontal, 20)

        SpeechSoundSwitcherView(speechOn: $speechOn)
          .padding(.horizontal, speechSoundSwitcherViewHeight)

        BaseBottomButton(
          slideShowModeEnabled ? .memorizingWordsBottomButtonOrange : .bottomButton,
          title: "Continue",
          action: timerManager.forceTimeout
        )
          .frame(height: bottomButtonHeight)
          .padding(.horizontal)
          .padding(.bottom, padding)
      }

      if slideShowModeEnabled || wordSelectedIndex != nil {
        MemorizingWordsCardView(
          wordsViewModel: wordsViewModel,
          selectedIndex: Binding(
            get: { wordSelectedIndex ?? 0 },
            set: { wordSelectedIndex = $0 }
          ),
          speechOn: $speechOn
        )
          .padding(.horizontal, 20)
          .aspectRatio(1, contentMode: .fit)
          .offset(y: -50)
      }

      if timerManager.state.playingState.isPlaying {
        MemorizingWordsPauseView(resumeAction: timerManager.resume)
      }
    }
    .hideNavigationBar()
    .onAppear{
      wordsViewModel.levelId = levelId
      wordsViewModel.fetchWordsImages()
      timerManager.start()
    }
    .fullScreenCover(isPresented: .constant(timerManager.timeIsUp && canShowAnswersView)) {
      MemorizingWordsAnswers(
        levelId: levelId,
        viewModel: viewModel,
        wordsViewModel: wordsViewModel,
        canShowResultView: $canShowResultView,
        bottomButtonAction: {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            canShowResultView = false
            canShowAnswersView = false
            presentationModeBinding.wrappedValue.dismiss()
          }
        }
      )
    }
  }
}

struct WordsTagsView_Previews: PreviewProvider {
  static var previews: some View {
    MemorizingWordsView(
      levelId: 1,
      viewModel: viewModelMock,
      wordsViewModel: MemorizingWordsViewModel()
    )
  }
}
