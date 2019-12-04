//
//  Requestable.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation
import Moya
import TOMLDecoder

protocol Requestable {
  associatedtype Backend: APIBackend
  associatedtype Response
  func decodeResponse(_ response: Moya.Response) throws -> Response

  var path: String { get }
  var method: Moya.Method { get }
  var headers: [String: String]? { get }

  var bodyParameters: [String: Any] { get }
  var bodyEncoding: ParameterEncoding { get }
  var urlParameters: [String: Any] { get }
  var task: Task { get }

  var sampleData: Data { get }
}

extension Requestable {
  var method: Moya.Method { .get }
  var headers: [String: String]? { nil }

  var task: Task {
    Task.requestCompositeParameters(
      bodyParameters: bodyParameters,
      bodyEncoding: bodyEncoding,
      urlParameters: urlParameters
    )
  }
  var bodyParameters: [String: Any] { [:] }
  var urlParameters: [String: Any] { [:] }
  var bodyEncoding: ParameterEncoding { JSONEncoding.default }
}

extension Requestable where Response: Decodable {
  func decodeResponse(_ response: Moya.Response) throws -> Response {
    try TOMLDecoder().decode(Response.self, from: response.data)
  }
}
