//
//  AnimalInflation.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import RxSwift
import RxCocoa

// MARK: - Provider
protocol AnimalProvider {
  var animalId: Animal.ID { get }
  var animalName: String { get }
  var animalSpecies: Species { get }
  var animalPopularity: Double { get }
}

// MARK: - Receiver
protocol AnimalReceiver {
  var animalId: Binder<Animal.ID> { get }
  var animalName: Binder<String> { get }
  var animalSpecies: Binder<Species> { get }
  var animalPopularity: Binder<Double> { get }
}

// MARK: - Inflation
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: AnimalProvider {
  func inflate(receiver: AnimalReceiver) -> Disposable {
    CompositeDisposable(disposables: [
      map { $0.animalId }.drive(receiver.animalId),
      map { $0.animalName }.drive(receiver.animalName),
      map { $0.animalSpecies }.drive(receiver.animalSpecies),
      map { $0.animalPopularity }.drive(receiver.animalPopularity),
    ])
  }
}
