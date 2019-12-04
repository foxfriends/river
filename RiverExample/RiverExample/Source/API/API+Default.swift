//
//  API+Source.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation

struct DefaultBackend: APIBackend {
  static var baseURL: URL { URL(string: "https://cameldridge.com/dataset/zoo/")! }
}

protocol DefaultRequestable: Requestable where Backend == DefaultBackend {}

extension API where Backend == DefaultBackend {
  static let `default`: API<DefaultBackend> = API(stubClosure: { _ in .immediate })
}
