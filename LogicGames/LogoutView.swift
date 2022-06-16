//
//  LogoutView.swift
//  LogicGames
//
//  Created by MSP on 12.02.2022.
//

import SwiftUI
import FirebaseAuth

struct LogoutView: View {
  private let viewModel: ObservableViewModel
  private let buttonTitle = "Logout"
  
  @State var showSignInView = false
  
  @Environment(\.presentationMode)
  private var presentationModeBinding: Binding<PresentationMode>
  
  private var topPanel: some View {
    HStack {
      BackButton(.environment(presentationModeBinding))
      Spacer()
    }
    .padding()
  }
  
  private var button: some View {
    ZStack {
      Color.black.opacity(0.1)
        .cornerRadius(50)
        .frame(width: 205, height: 140)

      GradientView(.white)
        .cornerRadius(30)
        .frame(width: 155, height: 90)
      
      Text(buttonTitle)
        .font(.system(size: 20))
        .fontWeight(.bold)
        .foregroundColor(.black)
    }.asButton {
      try? Auth.auth().signOut()
      showSignInView = true
    }
  }
  
  init(viewModel: ObservableViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      GradientView(.onboarding)
        .ignoresSafeArea()
     
      VStack {
        topPanel
        Spacer()
        button
          .offset(y: -44)
        Spacer()
      }
    }
    .hideNavigationBar()
    .fullScreenCover(isPresented: $showSignInView) {
      OnboardingCoordinatorView(viewNumber: 0, viewModel: viewModel)
    }
  }
}

struct LogoutView_Previews: PreviewProvider {
  static var previews: some View {
    LogoutView(viewModel: viewModelMock)
  }
}
