//
//  Animal.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-12-01.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import RxSwift
import RxCocoa
import Convoy

struct Animal: Codable, Identifiable {
  let id: String
  let name: String
  let species: Species
  let popularity: Double
}

// MARK: - AnimalProvider
extension Animal: AnimalProvider {
  var animalId: String { id }
  var animalName: String { name }
  var animalSpecies: Species { species }
  var animalPopularity: Double { popularity }
}

// MARK: - RelayCompatible
extension Animal: RelayCompatible {
  static func relay(initial: Animal, current: Observable<Animal>) -> Observable<Animal> {
    ConvoyDispatcher.default.rx.receive(Update<Animal>.self, id: initial.id)
  }
}
