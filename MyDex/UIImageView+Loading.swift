//
//  UIImageView+Loading.swift
//  MyDex
//
//  Created by Eric Dockery on 3/30/21.
//  Copyright © 2021 Eric Dockery. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(at url: URL) {
    ImageLoader.shared.load(url, for: self)
  }

  func cancelImageLoad() {
    ImageLoader.shared.cancel(for: self)
  }
}
