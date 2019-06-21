//
//  LxViewController.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class LxViewController: UIViewController {

    lazy var vm: LxViewModel = LxViewModel(self)
    lazy var v: LxView = LxView.init(frame: CGRect.zero, vm: self.vm)
    
    var style: ActivityStyle = .actDetailStyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }
    
     func setupViews() {
        
        view.addSubview(v)
    }
    
     func setupLayout() {
        
        v.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
