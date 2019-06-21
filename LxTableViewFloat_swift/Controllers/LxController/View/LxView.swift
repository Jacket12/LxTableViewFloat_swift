//
//  LxView.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class LxView: UIView {

  
    public typealias VM = LxViewModel
    public weak var vm: VM?
  
    let kScreenWidth = UIScreen.main.bounds.width
    
    let kScreenHeight = UIScreen.main.bounds.height
    
    var canScroll: Bool = false
    
    let array: Array = ["标题1","标题2","标题3","标题4","标题5","标题6","标题7","标题8","标题9","标题10","标题11","标题12","标题13","标题14","标题15"]
    
    
    init(frame: CGRect,vm: VM) {
        super.init(frame: frame)
        
        self.vm = vm
        
        initNotify()
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    func setupViews() {
        
          addSubview(self.tableView)
    }
    
    func setupLayout() {
        
          tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(-100)
          }
    }
    
    lazy var tableView: UITableView! = { [unowned self] in
        
        let tv = UITableView(frame: UIScreen.main.bounds, style: .grouped)
       
        tv.delegate = self
        tv.dataSource = self
//        tv.separatorStyle  = .none
        tv.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tv.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
        tv.backgroundColor = UIColor.white
        return tv
        }()
    
    func initNotify() {
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(scrollOnNotify(notification:)),
                                               name: NSNotification.Name(rawValue: Notify.kcenterWebOnTopNotify.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(scrollOutNotify(notification:)),
                                               name: NSNotification.Name(rawValue: Notify.kcenterWebOutTopNotify.rawValue),
                                               object: nil)
    }
    
    @objc func scrollOnNotify(notification: Notification) {
        
        self.canScroll = true
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    @objc func scrollOutNotify(notification: Notification) {
        
        self.canScroll = false
        self.tableView.contentOffset = CGPoint.zero
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    //MARK: - UIScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.tableView {
            
            if self.canScroll == false {
                
                //                Logger.log("进入")
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            let offsetY = scrollView.contentOffset.y
            //            Logger.log(offsetY)
            
            if offsetY <= 0 {
                
                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Notify.kcenterWebOutTopNotify.rawValue), object: nil)
            }
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension LxView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, style: .default)
        let item = self.array[indexPath.row]
        
        cell.textLabel?.text = item
        return cell
    }
}

extension LxView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
