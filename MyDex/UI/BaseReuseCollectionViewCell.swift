//
//  BaseReuseCollectionViewCell.swift
//  MyDex
//
//  Created by Eric Dockery on 3/30/21.
//  Copyright © 2021 Eric Dockery. All rights reserved.
//

import UIKit

protocol Reuse {
    var onReuse: (() -> Void) { get  set}
}

class BaseReuseCollectionViewCell: UICollectionViewCell, Reuse {
    
    var onReuse: (() -> Void) = {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
      }
}
