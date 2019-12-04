//
//  AnimalTableViewCell.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-12-03.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit
import RxCocoa

class AnimalTableViewCell: ReusableTableViewCell, Dequeueable {
  @IBOutlet private var animalNameLabel: UILabel!
  @IBOutlet private var animalPopularityLabel: UILabel!
}

// MARK: - AnimalReceiver
extension AnimalTableViewCell: AnimalReceiver {
  var animalId: Binder<Animal.ID> { Binder.discard(self) }
  var animalSpecies: Binder<Species> { Binder.discard(self) }

  var animalName: Binder<String> {
    Binder(animalNameLabel) { label, name in
      label.text = name
    }
  }

  var animalPopularity: Binder<Double> {
    Binder(animalPopularityLabel) { label, popularity in
      label.text = "\(popularity)"
    }
  }
}
