//
//  FromStoryboard.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit

protocol FromStoryboard: UIViewController {
  static var storyboard: UIStoryboard { get }
  static var storyboardIdentifier: String { get }
}

extension FromStoryboard {
  static var storyboardIdentifier: String { String(describing: Self.self) }

  static func new() -> Self {
    Self.storyboard.instantiateViewController(identifier: storyboardIdentifier) as! Self
  }
}
