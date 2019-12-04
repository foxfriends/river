//
//  List.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-28.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import River
import Convoy
import RxConvoy
import RxSwift
import RxCocoa

final class List<ElementType: RelayCompatible> {
  private(set) var items: [Relay<ElementType>]

  init() { items = [] }

  init(_ relayedItems: [Relay<ElementType>]) {
    items = relayedItems
  }

  convenience init(_ items: [ElementType]) {
    self.init(items.map(Relay.init(_:)))
  }

  convenience init<S: Sequence>(sequence items: S) where S.Element == ElementType {
    self.init(Array(items))
  }
}

// MARK: - RelayCompatible
extension List: RelayCompatible where ElementType: Identifiable {
  static func relay(
    initial: List<ElementType>,
    current: Observable<List<ElementType>>
  ) -> Observable<List<ElementType>> {
    Observable
      .merge(
        ConvoyDispatcher.default.rx.receive(Create<ElementType>.self)
          .withLatestFrom(current) { new, current in current.appending(uniqueId: new) },
        ConvoyDispatcher.default.rx.receive(Delete<ElementType>.self)
          .withLatestFrom(current) { removed, current in current.remove(identified: removed) }
      )
  }
}

// MARK: - ListProvider
extension List: ListProvider {
  var listItems: [Relay<ElementType>] { items }
}

// MARK: - Methods
extension List where ElementType: Identifiable {
  func appending(uniqueId element: ElementType) -> List<ElementType> {
    guard !items.contains(where: { $0.value.id == element.id }) else { return self }
    return List(items + [Relay(element)])
  }

  func remove(identified element: ElementType) -> List<ElementType> {
    List(items.filter { $0.value.id != element.id })
  }
}

// MARK: - Collection
extension List: Collection {
  typealias Element = Relay<ElementType>

  @inlinable var startIndex: Int { items.startIndex }
  @inlinable var endIndex: Int { items.endIndex }
  @inlinable func index(after i: Int) -> Int { items.index(after: i) }
  @inlinable subscript(position: Int) -> Element { items[position] }
  @inlinable subscript(bounds: Range<Int>) -> Slice<[Element]> { items[bounds] }
}

// MARK: - Codable
extension List: Codable where ElementType: Codable {
  convenience init(from decoder: Decoder) throws {
    self.init(try [ElementType](from: decoder))
  }

  func encode(to encoder: Encoder) throws {
    try items.encode(to: encoder)
  }
}
