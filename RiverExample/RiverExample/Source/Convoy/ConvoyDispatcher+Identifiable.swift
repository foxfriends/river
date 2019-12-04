//
//  ConvoyDispatcher+Identifiable.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import Foundation
import RxSwift
import RxConvoy
import Convoy

extension Reactive where Base == ConvoyDispatcher {
  /// Set up a receiver for a `Convoy` with an `Identifiable` `Payload`, only handling results
  /// where the values have the same ID
  ///
  /// - Parameter convoy: The type of `Convoy` to receive
  /// - Parameter queue: The `OperationQueue` to handle events on. See
  ///                    `NotificationCenter.addObserver(forName:object:queue)` for details on how this works.
  /// - Parameter handler: The handler callback, which is called whenever a matching `Convoy` is received
  /// - Parameter contents: The received `Contents` that was sent with the `Convoy`
  ///
  /// - Returns: A handle to this receiver, which will remove the receiver when the handle is deallocated (RAII)
  public func receive<C: Convoy>(
    _ convoy: C.Type,
    queue: OperationQueue? = nil,
    id: C.Contents.ID
  ) -> Observable<C.Contents> where C.Contents: Identifiable {
    receive(convoy, queue: queue).filter { $0.id == id }
  }
}
