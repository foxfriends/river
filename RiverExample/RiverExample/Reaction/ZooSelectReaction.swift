//
//  ZooSelectReaction.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-12-02.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ZooSelectEmitter {
  var zooSelected: Signal<Zoo> { get }
}

protocol ZooSelectReceiver {
  func receive(zooSelected: Zoo)
}
