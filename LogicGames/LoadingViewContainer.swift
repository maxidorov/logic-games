//
//  LoadingViewContainer.swift
//  LogicGames
//
//  Created by MSP on 20.02.2022.
//

import SwiftUI

struct LoadingViewContainer: View {
  enum Stage {
    case loading
    case loaded
  }
  
  @ObservedObject var viewModel: ObservableViewModel
  @State var stage: Stage = .loading
  
  var body: some View {
    switch stage {
    case .loading:
      LoadingView(
        viewModel: viewModel,
        onLoadAction: {
          withAnimation {
            stage = .loaded
          }
        }
      )
        .transition(.opacity)
    case .loaded:
      LevelsView(viewModel: viewModel)
        .transition(.opacity)
    }
  }
}

struct LoadingViewContainer_Previews: PreviewProvider {
  static var previews: some View {
    LoadingViewContainer(viewModel: viewModelMock)
  }
}
