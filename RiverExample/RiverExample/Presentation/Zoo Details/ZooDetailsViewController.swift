//
//  ZooDetailsViewController.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-12-03.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import UIKit
import RxSwift
import RxCocoa

private typealias DataSource = BehaviorRelay<[Species: Relay<Animal>]>

class ZooDetailsViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let dataSource = DataSource(value: [:])

  @IBOutlet private var zooFavouriteAnimalsTableView: UITableView!

  @Emitter private var emitAnimalSelected: (Animal) -> Void
  @Emitter private var emitSpeciesSelected: (Species) -> Void
}

// MARK: - Lifecycle
extension ZooDetailsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    zooFavouriteAnimalsTableView.dataSource = self
    zooFavouriteAnimalsTableView.delegate = self

    AnimalTableViewCell.register(to: zooFavouriteAnimalsTableView)

    dataSource.asDriver()
      .drive(onNext: { [weak zooFavouriteAnimalsTableView] _ in zooFavouriteAnimalsTableView?.reloadData() })
      .disposed(by: disposeBag)
  }
}

// MARK: - ZooReceiver
extension ZooDetailsViewController: ZooReceiver {
  var zooId: Binder<Zoo.ID> { Binder.discard(self) }

  var zooName: Binder<String> {
    Binder(navigationItem) { navigationItem, name in navigationItem.title = name }
  }

  var zooAnimals: Binder<List<Animal>> {
    Binder(dataSource) { relay, animals in
      let kvs = animals.map { animal in (animal.value.species, animal) }
      relay.accept(Dictionary(kvs) { a, b in
        a.value.popularity > b.value.popularity ? a : b
      })
    }
  }
}

// MARK: - UITableViewDataSource
extension ZooDetailsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int { dataSource.value.count }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = AnimalTableViewCell.dequeue(from: tableView, at: indexPath)
    dataSource[indexPath].driver
      .inflate(receiver: cell)
      .disposed(by: cell.reuseDisposeBag)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ZooDetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let animal = dataSource[indexPath]
    emitAnimalSelected(animal.value)
  }
}

// MARK: - FromStoryboard
extension ZooDetailsViewController: FromStoryboard {
  static var storyboard: UIStoryboard { .main }
}

// MARK: - DataSource Methods
extension DataSource {
  subscript (section index: Int) -> Species {
    Array(value.keys)[index]
  }

  subscript (indexPath: IndexPath) -> Relay<Animal> {
    value[Array(value.keys)[indexPath.section]]!
  }
}
