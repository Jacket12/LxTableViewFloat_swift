//
//  LyViewController.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit
import SnapKit

class LyViewController: UIViewController {

    lazy var vm: LyViewModel = LyViewModel(self)
    lazy var v: LyView = LyView.init(frame: CGRect.zero, vm: self.vm)

    override func viewDidLoad() {
        super.viewDidLoad()

       self.title = "滑动悬停"
        
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
