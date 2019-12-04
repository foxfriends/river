//
//  ZooListViewController.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-27.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit
import River
import RxSwift
import RxCocoa

private typealias DataSource = BehaviorRelay<[Relay<Zoo>]>

class ZooListViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let dataSource = DataSource(value: [])

  @IBOutlet private var zooListTableView: UITableView!

  @Emitter private var emitZooSelected: (Zoo) -> Void
}

// MARK: - Lifecycle
extension ZooListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    zooListTableView.dataSource = self
    zooListTableView.delegate = self

    ZooTableViewCell.register(to: zooListTableView)

    dataSource.asDriver()
      .drive(onNext: { [weak zooListTableView] _ in zooListTableView?.reloadData() })
      .disposed(by: disposeBag)
  }
}

// MARK: - ListReceiver
extension ZooListViewController: ListReceiver {
  var listItems: Binder<[Relay<Zoo>]> {
    Binder(dataSource) { relay, items in relay.accept(items) }
  }
}

// MARK: - ZooSelectEmitter
extension ZooListViewController: ZooSelectEmitter {
  var zooSelected: Signal<Zoo> { $emitZooSelected }
}

// MARK: - UITableViewDataSource
extension ZooListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ZooTableViewCell.dequeue(from: tableView, at: indexPath)
    dataSource[indexPath].driver
      .inflate(receiver: cell)
      .disposed(by: cell.reuseDisposeBag)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ZooListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let zoo = dataSource[indexPath]
    emitZooSelected(zoo.value)
  }
}

// MARK: - FromStoryboard
extension ZooListViewController: FromStoryboard {
  static var storyboard: UIStoryboard { .main }
}

// MARK: - DataSource Methods
extension DataSource {
  subscript (indexPath: IndexPath) -> Relay<Zoo> {
    value[indexPath.row]
  }
}
