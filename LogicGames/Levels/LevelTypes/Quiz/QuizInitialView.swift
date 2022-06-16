//
//  QuizView.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/9/22.
//

import SwiftUI

struct QuizInitialView: View {
  let levelId: Int
  @ObservedObject private var viewModel: ObservableViewModel
  @ObservedObject private var quizViewModel: QuizViewModel
  @Binding private var levelTypeState: LevelTypeState
  private let nextStageAction: Action
  
  @StateObject private var alertManager = AlertManager()
  
  @Environment(\.presentationMode)
  private var presentationModeBinding: Binding<PresentationMode>

  init(
    levelId: Int,
    viewModel: ObservableViewModel,
    quizViewModel: QuizViewModel,
    levelTypeState: Binding<LevelTypeState>,
    nextStageAction: @escaping Action
  ) {
    self.levelId = levelId
    self.viewModel = viewModel
    self.quizViewModel = quizViewModel
    self._levelTypeState = levelTypeState
    self.nextStageAction = nextStageAction
  }

  @ViewBuilder
  private var circleForImage: some View {
    Circle()
      .foregroundColor(.black.opacity(0.1))
      .frame(squareDimension: screenSize.width * 0.6)
  }

  @ViewBuilder
  private var backButton: some View {
    BackButton(.action { withAnimation {
      levelTypeState = .menu
    }})
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      GradientView(.quiz)
        .ignoresSafeArea()

      switch quizViewModel.state {
      case .loading:
        VStack {
          HStack {
            backButton
              .padding([.leading, .top])
            Spacer()
          }

          Spacer()

          BarLoadingView()
            .transition(.opacity)

          Spacer()
        }
      case .ready:
        let model = quizViewModel.model
        VStack {
          HStack {
            backButton
              .padding([.leading, .top])
              .animation(nil)
            Spacer()
          }

          Text(model.initial.title)
            .foregroundColor(.white)
            .font(.system(size: 32))
            .fontWeight(.bold)
            .padding(.top)

          Spacer()

          ZStack {
            circleForImage

            switch model.initial.image {
            case let .some(image):
              image
                .resizable()
                .frame(squareDimension: screenSize.width * 0.7)
            case .none:
              SwiftUI.ProgressView()
                .foregroundColor(.white)
                .scaleEffect(3)
            }
          }

          Spacer()

          Text(model.initial.subtitle)
            .foregroundColor(.white.opacity(0.5))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)

          Spacer()

          BaseBottomButton(
            .bottomButton,
            title: "I'm ready",
            action: nextStageAction
          )
          .frame(height: 70)
          .padding([.horizontal, .bottom])
          .opacity(quizViewModel.imagesLoaded ? 1 : 0.2)
          .disabled(!quizViewModel.imagesLoaded)
        }
        .transition(.opacity)
      }
    }
    .animation(.default)
    .hideNavigationBar()
    .uses(alertManager)
    .onAppear {
      quizViewModel.load(levelId: levelId, onError: {
        alertManager.show(dismiss: .error())
      })
    }
  }
}

struct QuizView_Previews: PreviewProvider {
  static var previews: some View {
    QuizInitialView(
      levelId: 1,
      viewModel: viewModelMock,
      quizViewModel: QuizViewModel.makeMock(),
      levelTypeState: .constant(.quiz),
      nextStageAction: { }
    )
  }
}
