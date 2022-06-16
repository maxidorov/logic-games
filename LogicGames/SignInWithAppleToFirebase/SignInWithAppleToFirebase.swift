//
//  SignInWithAppleToFirebase.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 16/15/21.
//

import UIKit
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

final class SignInWithApple: UIViewRepresentable {
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    ASAuthorizationAppleIDButton(type: .default, style: .white)
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}

enum SignInWithAppleToFirebaseResponse {
  case success
  case error
}

final class SignInWithAppleToFirebase: UIViewControllerRepresentable {
  private var appleSignInDelegates: SignInWithAppleDelegates! = nil
  private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())?
  private var currentNonce: String?

  init(_ onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())? = nil) {
    self.onLoginEvent = onLoginEvent
  }

  func makeUIViewController(context: Context) -> UIViewController {
    UIHostingController(
      rootView: BaseBottomButton(
        .bottomButton,
        title: " Sign in with Apple",
        action: self.showAppleLogin
      )
    ) as UIViewController
  }
  
  func updateUIViewController(_ uiView: UIViewController, context: Context) { }

  private func showAppleLogin() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    performSignIn(using: [request])
  }

  private func performSignIn(using requests: [ASAuthorizationRequest]) {
    guard let currentNonce = self.currentNonce else {
      return
    }

    appleSignInDelegates = SignInWithAppleDelegates(
      window: nil,
      currentNonce: currentNonce,
      onLoginEvent: self.onLoginEvent
    )

    let authorizationController = ASAuthorizationController(authorizationRequests: requests)
    authorizationController.delegate = appleSignInDelegates
    authorizationController.presentationContextProvider = appleSignInDelegates
    authorizationController.performRequests()
  }

  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if length == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }

  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()

    return hashString
  }
}
