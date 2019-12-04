//
//  Dequeueable.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit

protocol Dequeueable: AnyObject {
  static var nib: UINib { get }
  static var reuseIdentifier: String { get }
}

extension Dequeueable {
  static var nib: UINib { UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))}
  static var reuseIdentifier: String { String(describing: Self.self) }
}

extension Dequeueable where Self: UITableViewCell {
  static func register(to tableView: UITableView) {
    tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
  }

  static func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> Self {
    tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Self
  }
}
