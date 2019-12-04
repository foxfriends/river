//
//  API.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import Moya

class API<Backend: APIBackend>: MoyaProvider<AnyTargetType<Backend>> {
  func request<Request: Requestable>(_ request: Request, callbackQueue: DispatchQueue? = nil) -> Single<Request.Response>
  where Request.Backend == Backend {
    rx.request(AnyTargetType(request), callbackQueue: callbackQueue)
      .map(request.decodeResponse)
  }
}
