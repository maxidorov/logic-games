//
//  SignInWithAppleDelegates.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 16/15/21.
//

import UIKit
import AuthenticationServices
import Firebase

class SignInWithAppleDelegates: NSObject {
  private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())?
  private weak var window: UIWindow!
  private var currentNonce: String?

  init(
    window: UIWindow?,
    currentNonce: String,
    onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())? = nil
  ) {
    self.window = window
    self.currentNonce = currentNonce
    self.onLoginEvent = onLoginEvent
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  func firebaseLogin(credential: ASAuthorizationAppleIDCredential) {
    guard let nonce = currentNonce else {
      fatalError("Invalid state: A login callback was received, but no login request was sent.")
    }
    guard let appleIDToken = credential.identityToken else {
      print("Unable to fetch identity token")
      return
    }
    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
      return
    }

    let credential = OAuthProvider.credential(
      withProviderID: "apple.com",
      idToken: idTokenString,
      rawNonce: nonce
    )

    Auth.auth().signIn(with: credential) { (authResult, error) in
      switch error {
      case .some:
        self.onLoginEvent?(.error)
      case .none:
        self.onLoginEvent?(.success)
      }
    }
  }

  private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
    let userData = AuthUserData(
      email: credential.email!,
      name: credential.fullName!,
      identifier: credential.user
    )

    let keychain = UserDataKeychain()
    do {
      try keychain.store(userData)
    } catch {
      // TODO: error handling
    }

    firebaseLogin(credential: credential)
  }

  private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
    firebaseLogin(credential: credential)
  }


  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
        registerNewAccount(credential: appleIdCredential)
      } else {
        signInWithExistingAccount(credential: appleIdCredential)
      }
    default:
      break
    }
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    onLoginEvent?(.error)
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    window
  }
}
