//
//  BaseViewModel.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import Foundation
import UIKit

class BaseViewModel<T: UIViewController> {
    
    weak var vc: T?
    
    init(_ context: T?) {
        self.vc = context
        
    }
}
