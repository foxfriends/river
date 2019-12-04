//
//  UITableView+Rx+Dequeueable.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base == UITableView {
  func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>(_ cellType: Cell.Type = Cell.self)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable
  where Cell: Dequeueable, Source.Element == Sequence {
    items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
  }
}
