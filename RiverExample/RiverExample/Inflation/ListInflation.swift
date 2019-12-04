//
//  ListInflation.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import RxSwift
import RxCocoa

// MARK: - Provider
protocol ListProvider {
  associatedtype ElementType: RelayCompatible
  var listItems: [Relay<ElementType>] { get }
}

// MARK: - Receiver
protocol ListReceiver {
  associatedtype ElementType: RelayCompatible
  var listItems: Binder<[Relay<ElementType>]> { get }
}

// MARK: - Inflation
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: ListProvider {
  typealias Provider = Element

  func inflate<Receiver>(receiver: Receiver) -> Disposable
  where Receiver: ListReceiver, Receiver.ElementType == Provider.ElementType {
    map { $0.listItems }.drive(receiver.listItems)
  }
}

