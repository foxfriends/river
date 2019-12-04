//
//  ZooListCoordinator.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import UIKit
import RxSwift
import RxCocoa

struct ZooListCoordinator: RootCoordinator {
  @Relay(deferred: API.default.request(API.ListAllZoos()).map { $0.zoos })
  private var zooList = List<Zoo>()

  func makeRootViewController() -> UINavigationController {
    UINavigationController(rootViewController: ZooListViewController.new())
  }

  func begin(_ controller: UINavigationController) -> Observable<Never> {
    let zooListViewController = controller.viewControllers[0] as! ZooListViewController

    return Observable.create { yield in
      return CompositeDisposable(disposables: [
        self.$zooList.inflate(receiver: zooListViewController),
        zooListViewController.zooSelected
          .map(ZooDetailsCoordinator.init(zoo:))
          .flatMapLatest(controller.rx.push())
          .emit()
      ])
    }
  }
}
