//
//  ZooDetailsCoordinator.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-12-03.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import UIKit
import RxSwift
import RxCocoa

struct ZooDetailsCoordinator: PushCoordinator {
  @Relay var zoo: Zoo

  func makeRootViewController() -> ZooDetailsViewController {
    return ZooDetailsViewController.new()
  }

  func begin(_ controller: ZooDetailsViewController) -> Observable<Never> {
    Observable.create { yield in
      CompositeDisposable(disposables: [
        self.$zoo.inflate(receiver: controller),
      ])
    }
  }
}
