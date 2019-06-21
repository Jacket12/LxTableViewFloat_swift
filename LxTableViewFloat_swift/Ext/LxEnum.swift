//
//  LxEnum.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import Foundation

/// 通知
///
/// - kcenterWebOnTopNotify: 进入置顶命令
/// - kcenterWebOutTopNotify: 离开置顶命令

public enum Notify: String {
    
    case kcenterWebOnTopNotify   = "kcenterWebOnTopNotify"
    case kcenterWebOutTopNotify  = "kcenterWebOutTopNotify"
}

enum ActivityStyle: String {
    case actDetailStyle = "actDetailStyle"
    case readyStyle = "readyStyle"
    case explainStyle = "explainStyle"
}
