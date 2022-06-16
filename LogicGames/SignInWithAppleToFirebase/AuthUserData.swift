//
//  AuthUserData.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 16/15/21.
//

import Foundation

struct AuthUserData: Codable {
  let email: String
  let name: PersonNameComponents
  let identifier: String

  func displayName(style: PersonNameComponentsFormatter.Style = .default) -> String {
    PersonNameComponentsFormatter.localizedString(from: name, style: style)
  }
}
