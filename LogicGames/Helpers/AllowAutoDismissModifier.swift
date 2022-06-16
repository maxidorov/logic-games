//
//  AllowAutoDismissModifier.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 12/16/21.
//

import SwiftUI

struct MbModalHackView: UIViewControllerRepresentable {
  var dismissable: () -> Bool = { false }

  func makeUIViewController(
    context: UIViewControllerRepresentableContext<MbModalHackView>
  ) -> UIViewController {
    MbModalViewController(dismissable: self.dismissable)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension MbModalHackView {
  private final class MbModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    let dismissable: () -> Bool

    init(dismissable: @escaping () -> Bool) {
      self.dismissable = dismissable
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
      super.didMove(toParent: parent)

      setup()
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      dismissable()
    }

    private func setup() {
      guard let rootPresentationViewController = rootParent.presentationController,
            rootPresentationViewController.delegate == nil
      else {
        return
      }

      rootPresentationViewController.delegate = self
    }
  }
}

extension UIViewController {
  fileprivate var rootParent: UIViewController {
    if let parent = self.parent {
      return parent.rootParent
    }
    return self
  }
}

extension View {
  func allowAutoDismiss(_ dismissable: @escaping () -> Bool) -> some View {
    background(MbModalHackView(dismissable: dismissable))
  }

  func allowAutoDismiss(_ dismissable: Bool) -> some View {
    background(MbModalHackView(dismissable: { dismissable }))
  }
}
