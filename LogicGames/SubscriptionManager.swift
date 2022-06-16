//
//  SubscriptionManager.swift
//  LogicGames
//
//  Created by Maxim V. Sidorov on 1/29/22.
//

import StoreKit
import ApphudSDK

enum SubscriptionError: Error {
  case productsNotFound
  case purchase(Error)
}

typealias SubscriptionResult<T> = Result<T, SubscriptionError>

struct SubscriptionProductInfo {
  let readableDescription: String
  let trialPeriod: String

  init(from product: SKProduct) {
    self.readableDescription = product.readableDescription
    self.trialPeriod = product.introductoryPrice?.localizedSubscriptionPeriod ?? ""
  }
}

struct SubscriptionConfig {
  static let freeLevelsCount = 1
}

final class SubscriptionManager: ObservableObject {
  @Published var paywallLoaded = false

  func getSubscriptionProductInfo(completion: @escaping (SubscriptionResult<SubscriptionProductInfo>) -> Void) {
    Apphud.paywallsDidLoadCallback { [weak self] paywalls in
      self?.paywallLoaded = true

      guard
        let paywall = paywalls.first,
        let product = paywall.products.first,
        let skProduct = product.skProduct
      else {
        return completion(.failure(.productsNotFound))
      }

      return completion(.success(SubscriptionProductInfo(from: skProduct)))
    }
  }

  func makePurchase(completion: @escaping (SubscriptionResult<Void>) -> Void) {
    Apphud.paywallsDidLoadCallback { [weak self] paywalls in
      self?.paywallLoaded = true

      guard let paywall = paywalls.first, let product = paywall.products.first else {
        return completion(.failure(.productsNotFound))
      }

      Apphud.purchase(product) { result in
        if let subscription = result.subscription, subscription.isActive(){
          // has active subscription
          return completion(.success(()))
        } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
          // has active non-renewing purchase
          return completion(.success(()))
        } else {
          // handle error or check transaction status.
          if let error = result.error {
            return completion(.failure(.purchase(error)))
          }

          return completion(.success(()))
        }
      }
    }
  }

  func hasActiveSubscription() -> Bool {
    Apphud.hasActiveSubscription()
  }
}

extension SKProduct {
  private static let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  var readableDescription: String {
    let primaryPeriod: String = {
      switch self.subscriptionPeriod?.unit {
      case .day:
        return "day"
      case .week:
        return "week"
      case .month:
        return "month"
      case .year:
        return "year"
      case .none, .some:
        return ""
      }
    }()

    func getRealNumberOfUnitsAndPeriod() -> (Int, String) {
      let numberOfUnits = subscriptionPeriod?.numberOfUnits ?? 0
      if numberOfUnits == 7 && primaryPeriod == "day" {
        return (1, "week")
      }
      return (numberOfUnits, primaryPeriod)
    }

    let (numberOfUnits, period) = getRealNumberOfUnitsAndPeriod()
    let pluralPeriod = numberOfUnits > 1 ? "\(period)s" : period
    let stringNumberOfUnits = (numberOfUnits == 1) ? "" : "\(numberOfUnits) "
    return "\(localizedPrice!) per \(stringNumberOfUnits)\(pluralPeriod)"
  }

  private var localizedPrice: String? {
    let formatter = SKProduct.formatter
    formatter.locale = priceLocale
    return formatter.string(from: price)
  }
}

public extension SKProductDiscount {
  var localizedPrice: String? {
    priceFormatter(locale: priceLocale).string(from: price)
  }

  var localizedSubscriptionPeriod: String {
    let dateComponents: DateComponents

    switch subscriptionPeriod.unit {
    case .day: dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits)
    case .week: dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits)
    case .month: dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
    case .year: dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits)
    @unknown default:
      print("WARNING: SwiftyStoreKit localizedSubscriptionPeriod does not handle all SKProduct.PeriodUnit cases.")
      dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
    }

    return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full) ?? ""
  }

  private func priceFormatter(locale: Locale) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currency
    return formatter
  }
}
