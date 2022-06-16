//
//  ColorsSpeakingView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/16/22.
//

import SwiftUI

struct ColorsSpeakingView: View {
  let levelId: Int
  @ObservedObject var viewModel: ObservableViewModel
  @ObservedObject var colorsViewModel: ColorsViewModel
  
  private let levelType: LevelType = .colors
  private let turnOnAudioSettingsTitle = "Tap here to give access to the microphone and speech recognition"
  private let nextStageAction: Action
  
  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    colorsViewModel: ColorsViewModel,
    nextStageAction: @escaping Action
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.colorsViewModel = colorsViewModel
    self.nextStageAction = nextStageAction
  }
  
  var body: some View {
    ZStack {
      GradientView(.colors)
        .ignoresSafeArea()
      
      if colorsViewModel.audioEngineAvailable {
        VStack {
          ProgressView(
            progress: colorsViewModel.progress,
            gradientConfiguration: .colorsProgress
          )
            .frame(height: 12)
            .padding()
            .padding(.bottom)
          
          ColorsWordsView(
            coloredWords: colorsViewModel.generateColoredWord(levelId: levelId),
            width: screenSize.width - 40
          )
          
          ZStack {
            Color.black
              .opacity(0.1)
              .cornerRadius(20)
              .frame(height: screenSize.height * 0.15)
            
            Text(colorsViewModel.recognizedText)
              .font(.system(size: 16))
              .fontWeight(.medium)
              .foregroundColor(.white.opacity(0.5))
              .multilineTextAlignment(.center)
              .padding()
          }
          .padding()
          
          MicroListeningView(width: screenSize.width * 0.2)
          
          Text("Microphone listening... keep talking")
            .font(.system(size: 16))
            .foregroundColor(.white.opacity(0.5))
            .fontWeight(.medium)
          
          Spacer()
          
          BaseBottomButton(
            .memorizingWordsBottomButtonBlue,
            title: "Completed",
            action: nextStageAction
          )
            .frame(height: 70)
            .padding()
        }
      } else {
        Text(turnOnAudioSettingsTitle)
          .font(.system(size: 32))
          .foregroundColor(.white.opacity(0.5))
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .asButton {
            UIApplication.shared.open(
              URL(string: UIApplication.openSettingsURLString)!,
              options: [:]
            )
          }
      }
    }
    .onAppear {
      colorsViewModel.requestAuthorization()
    }
    .hideNavigationBar()
  }
}

private struct MicroListeningView: View {
  let width: CGFloat
  @State private var pulse = false
  
  var body: some View {
    ZStack {
      Circle()
        .foregroundColor(.white.opacity(0.1))
        .frame(squareDimension: width)
        .scaleEffect(pulse ? 1 : 0.7)
      
      Circle()
        .foregroundColor(.white.opacity(0.1))
        .scaleEffect(pulse ? 1 : 0.6)
        .frame(squareDimension: width * 0.71)
      
      Image(.microListening)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: width * 0.3)
    }
    .animation(.easeInOut(duration: 0.7).repeatForever())
    .onAppear {
      pulse.toggle()
    }
  }
}

struct ColorsSpeakingView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsSpeakingView(
      levelId: 7,
      viewModel: viewModelMock,
      colorsViewModel: ColorsViewModel(),
      nextStageAction: { }
    )
  }
}

struct MicroListeningView_Previews: PreviewProvider {
  static var previews: some View {
    MicroListeningView(width: 200)
      .background(.gray)
      .previewLayout(.sizeThatFits)
  }
}
