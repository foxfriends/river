//
//  ReusableTableViewCell.swift
//  RiverExample
//
//  Created by Cameron Eldridge on 2019-11-30.
//  Copyright © 2019 cameldridge. All rights reserved.
//

import UIKit
import RxSwift

class ReusableTableViewCell: UITableViewCell {
  private(set) var reuseDisposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()
    reuseDisposeBag = DisposeBag()
  }
}
