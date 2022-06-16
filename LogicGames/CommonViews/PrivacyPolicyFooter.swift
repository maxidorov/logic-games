//
//  PrivacyPolicyFooter.swift
//  LogicGames
//
//  Created by MSP on 22.02.2022.
//

import SwiftUI
import ApphudSDK

struct PrivacyPolicyFooter: View {
  @Environment(\.openURL) var openURL
  
  private var separator: some View {
    Rectangle()
      .foregroundColor(.white)
      .frame(width: 1, height: 10)
  }
  
  var body: some View {
    GeometryReader { geo in
      let size = CGSize(
        width: geo.size.width / 3,
        height: geo.size.height
      )
      
      ZStack {
        HStack(spacing: 0) {
          Text("Privacy Policy")
            .privacyStyled(size: size)
            .asButton {
              openURL(URL(string: "https://LogicGames-app.web.app/privacy.txt")!)
            }
          
          Text("Restore")
            .privacyStyled(size: size)
            .asButton {
              Apphud.restorePurchases { _, _, _ in }
            }
          
          Text("Terms of use")
            .privacyStyled(size: size)
            .asButton {
              openURL(URL(string: "https://LogicGames-app.web.app/terms.txt")!)
            }
        }
        
        HStack {
          Spacer()
          separator
          Spacer()
          separator
          Spacer()
        }
      }
    }
  }
}

extension Text {
  func privacyStyled(size: CGSize) -> some View {
    self
      .foregroundColor(.white)
      .lineLimit(1)
      .font(.system(size: 10))
      .minimumScaleFactor(0.1)
      .frame(width: size.width, height: size.height)
  }
}

struct PrivacyPolicyFooter_Previews: PreviewProvider {
  static var previews: some View {
    PrivacyPolicyFooter()
      .background(.gray)
      .previewLayout(.fixed(width: 300, height: 50))
  }
}
