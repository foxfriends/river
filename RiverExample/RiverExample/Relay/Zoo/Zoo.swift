//
//  Zoo.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import RxSwift
import RxCocoa
import Convoy

struct Zoo: Codable, Identifiable {
  let id: String
  let name: String
  let animals: List<Animal>
}

// MARK: - ZooProvider
extension Zoo: ZooProvider {
  var zooId: Zoo.ID { id }
  var zooName: String { name }
  var zooAnimals: List<Animal> { animals }
}

// MARK: - RelayCompatible
extension Zoo: RelayCompatible {
  static func relay(initial: Zoo, current: Observable<Zoo>) -> Observable<Zoo> {
    ConvoyDispatcher.default.rx.receive(Update<Zoo>.self, id: initial.id)
  }
}
