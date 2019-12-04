//
//  ZooTableViewCell.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZooTableViewCell: ReusableTableViewCell, Dequeueable {
  @IBOutlet private var zooNameLabel: UILabel!
}

// MARK: - ZooReceiver
extension ZooTableViewCell: ZooReceiver {
  var zooId: Binder<Zoo.ID> { Binder.discard(self) }
  var zooName: Binder<String> { Binder(zooNameLabel) { label, name in label.text = name } }
  var zooAnimals: Binder<List<Animal>> { Binder.discard(self) }
}
