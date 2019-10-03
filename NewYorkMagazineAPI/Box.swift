//
//  Box.swift
//  NewYorkMagazineAPI
//
//  Created by Hollie Fang on 2019/10/2.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
