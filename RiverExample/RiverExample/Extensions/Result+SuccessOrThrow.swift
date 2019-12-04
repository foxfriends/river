//
//  Result+SuccessOrThrow.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

extension Result {
  func successOrThrow() throws -> Success {
    switch self {
    case let .success(success): return success
    case let .failure(failure): throw failure
    }
  }
}
