//
//  Binder+Discard.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import RxCocoa

extension Binder {
  static func discard<Target: AnyObject>(_ target: Target) -> Binder<Element> { Binder<Element>(target) { _, _ in } }
}
