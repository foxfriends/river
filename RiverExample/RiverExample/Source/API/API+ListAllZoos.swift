//
//  ListAllZoos.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation
import Moya

extension API where Backend == DefaultBackend {
  struct ListAllZoos: DefaultRequestable {
    // NOTE: this struct cannot be named "Response" directly because the Swift runtime fails to demangle the name...
    struct Response_: Decodable {
      let zoos: List<Zoo>
    }
    typealias Response = Response_

    var path: String { "zoo_list.toml" }

    var sampleData: Data {
      """
      [[zoos]]
      id = "zoo:yto"
      name = "Toronto Zoo"
      [[zoos.animals]]
      id = "animal:simba@zoo:yto"
      name = "Simba"
      species = "lion"
      popularity = 0.9
      [[zoos.animals]]
      id = "animal:mufasa@zoo:yto"
      name = "Mufasa"
      species = "lion"
      popularity = 0.75
      [[zoos.animals]]
      id = "animal:scar@zoo.yto"
      name = "Scar"
      species = "lion"
      popularity = 0.05
      """.data(using: .utf8)!
    }
  }
}
