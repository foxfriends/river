//
//  AnyTargetType.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation
import Moya

struct AnyTargetType<Backend: APIBackend>: TargetType {
  var baseURL: URL { Backend.baseURL }
  let path: String
  let method: Moya.Method
  let sampleData: Data
  let task: Task
  let headers: [String: String]?

  init<Request: Requestable>(_ request: Request) where Request.Backend == Backend {
    path = request.path
    method = request.method
    sampleData = request.sampleData
    task = request.task
    headers = request.headers
  }
}
