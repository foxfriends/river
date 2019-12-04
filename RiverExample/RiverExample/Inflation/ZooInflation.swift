//
//  ZooInflation.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Provider
protocol ZooProvider {
  var zooId: Zoo.ID { get }
  var zooName: String { get }
  var zooAnimals: List<Animal> { get }
}

// MARK: - Receiver
protocol ZooReceiver: AnyObject {
  var zooId: Binder<Zoo.ID> { get }
  var zooName: Binder<String> { get }
  var zooAnimals: Binder<List<Animal>> { get }
}

// MARK: - Inflater
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: ZooProvider {
  func inflate(receiver: ZooReceiver) -> Disposable {
    CompositeDisposable(disposables: [
      map { $0.zooId }.drive(receiver.zooId),
      map { $0.zooName }.drive(receiver.zooName),
      map { $0.zooAnimals }.drive(receiver.zooAnimals),
    ])
  }
}
