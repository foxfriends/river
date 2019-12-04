//
//  Species.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

enum Species: String, Codable {
  case lion
  case giraffe
  case penguin
  case hippopotamus
  case rhinoceros
  case elephant

  var name: String {
    switch self {
    case .lion: return "Lion"
    case .giraffe: return "Giraffe"
    case .penguin: return "Penguin"
    case .hippopotamus: return "Hippopotamus"
    case .rhinoceros: return "Rhinoceros"
    case .elephant: return "Elephant"
    }
  }
}
