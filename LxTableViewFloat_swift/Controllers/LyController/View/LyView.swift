//
//  LyView.swift
//  LxTableViewFloat_swift
//
//  Created by JackYe on 2019/6/20.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class LyView: UIView {

    public typealias VM = LyViewModel
    public weak var vm: VM?
    
    var style: ActivityStyle = .actDetailStyle
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    let ColorBackgroundColor = UIColor(named: "#f6f6f6")
    
    var canScroll: Bool = true
    
    init(frame: CGRect,vm: VM) {
        super.init(frame: frame)
        
        self.vm = vm
        
        setupViews()
        setupLayout()
        
        //锁定第一个
        self.changeChildVC(self.firstController, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        initNotify()
        addSubview(self.tableView)
    }
    
    func setupLayout() {
        
        tableView.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
        }
    }
    
    func initNotify() {
        
        NotificationCenter.default.addObserver(self,selector: #selector(scrollOutNotify(notification:)),
                                               name: NSNotification.Name(rawValue: Notify.kcenterWebOutTopNotify.rawValue),
                                               object: nil)
    }
    
    @objc func scrollOutNotify(notification:Notification) {
        
        self.canScroll = true
    }
    
    
    //MARK: - UI
    lazy var tableView: LyTableView! = { [unowned self] in
        
        let tv = LyTableView(frame: UIScreen.main.bounds, style: .plain)
        tv.delegate = self
        tv.dataSource = self
//        tv.separatorStyle  = .none
        tv.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tv.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
        tv.backgroundColor = UIColor(named: "#f6f6f6")
        tv.shouldRecognizeSimultaneously = true
        tv.scrollsToTop = false
        return tv
        }()
    
    lazy var sliderView: WJSliderView = { [weak self] in
        
        let view = WJSliderView.init(frame: CGRect.init(x: 0, y: 8, width: kScreenWidth, height: 50), titleArray: ["活动详情","行程准备","费用说明"])
        view?.font = UIFont.systemFont(ofSize: 14)
        view?.delegate = self
        view?.defaultTextColor = .black
        view?.selectionTextColor = UIColor(named: "#38cecd")
        return view!
        }()

    lazy var contentScrollView: UIScrollView = {
        
        let view = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.delegate = self
        view.backgroundColor = UIColor.white
        view.alwaysBounceHorizontal           = true
        view.alwaysBounceVertical             = false
        view.showsVerticalScrollIndicator     = false
        view.showsHorizontalScrollIndicator   = false
        view.bounces                          = false  // 是否反弹
        view.isPagingEnabled                  = true
        return view
    }()
    
    lazy var firstController: LxViewController = {
        
        let controller = LxViewController()
        controller.style = .actDetailStyle
        return controller
    }()
    
    lazy var secondController: LxViewController = {
        
        let controller = LxViewController()
        controller.style = .readyStyle
        return controller
    }()
    
    lazy var thirdController: LxViewController = {
        
        let controller = LxViewController()
        controller.style = .explainStyle
        return controller
    }()
    
    
    //MARK: - Method
    func vcFilter( _ vc: UIViewController) -> Bool {
        
        
        var isContains: Bool = false
        
        for obj in self.vm!.vc!.childViewControllers {
            if obj == vc {
                isContains = true
                break
            }
        }
        if isContains == true { return true }
        return false
    }
    
    //动态加载控制器
    func changeChildVC(_ childVC: UIViewController, _ index: Int) {
        
        
        switch index {
        case 0:
            self.style = .actDetailStyle
            break
        case 1:
            self.style = .readyStyle
            
            break
        case 2:
            self.style = .explainStyle
            break
        default:
            break
        }
        
        if self.vcFilter(childVC) == true { return }
        
        self.vm?.vc!.addChildViewController(childVC)
        
        childVC.view.frame = CGRect(x: kScreenWidth * CGFloat(index), y: 0, width: kScreenWidth, height: kScreenHeight)
        self.contentScrollView.addSubview(childVC.view)
        
        let size = CGSize.init(width: kScreenWidth * 3, height: kScreenHeight)
        self.contentScrollView.contentSize = size
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension LyView: WJSliderViewDelegate {
    
    func wj_sliderViewDidIndex(_ index: Int) {
        
        switch index {
        case 0:
            self.changeChildVC(self.firstController, index)
            break
        case 1:
            self.changeChildVC(self.secondController, index)
            break
        case 2:
            self.changeChildVC(self.thirdController, index)
            break
        default:
            break
        }
        
        let point = CGPoint.init(x: CGFloat(index) * self.bounds.size.width, y: self.contentScrollView.contentOffset.y)
        self.contentScrollView.setContentOffset(point, animated: true)
    }
}

extension LyView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.contentScrollView {
            
            let f = scrollView.contentOffset.x / self.bounds.size.width
            self.sliderView.indexProgress = f
            let index = floor((scrollView.contentOffset.x - self.bounds.size.width / 5) / self.bounds.size.width + 1)
            
            switch index {
            case 0:
                self.changeChildVC(self.firstController, Int(index))
                break
            case 1:
                self.changeChildVC(self.secondController, Int(index))
                break
            case 2:
                self.changeChildVC(self.thirdController, Int(index))
                break
            default:
                break
            }
            
        } else if scrollView == self.tableView {
            
            let tabOffsetY = self.tableView.rect(forSection: 2).origin.y
            
            let offsetY = scrollView.contentOffset.y
            
            //            Logger.log(offsetY)
            
            if offsetY >= tabOffsetY {
                
                //                Logger.log("滑动到顶端")
                scrollView.contentOffset = CGPoint.init(x: 0, y: tabOffsetY)
                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Notify.kcenterWebOnTopNotify.rawValue), object: nil)
                self.canScroll = false
            } else {
                
                if self.canScroll == false {
                    //                    Logger.log("离开顶端")
                    scrollView.contentOffset = CGPoint.init(x: 0, y: tabOffsetY)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.contentScrollView {
            
            let index = floor((scrollView.contentOffset.x - self.bounds.size.width / 5) / self.bounds.size.width + 1)
            self.sliderView.changeSelectionColor(Int(index))
        }
    }
}

extension LyView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 2:
              let cell = tableView.dequeueReusableCell(UITableViewCell.self, style: .default)
             cell.contentView.addSubview(self.contentScrollView)
            return cell
        default:
            break
        }
         return tableView.dequeueReusableCell(UITableViewCell.self, style: .default)
    }
}

extension LyView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 80
        case 2:
            return kScreenHeight
        default:
           return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 60
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
            view.isUserInteractionEnabled = true
            view.backgroundColor = UIColor.white
            view.addSubview(self.sliderView)
            return view
        }
        
        let  view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 8))
       view.backgroundColor = .lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
