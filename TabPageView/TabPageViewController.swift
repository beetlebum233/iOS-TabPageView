//
//  ViewController.swift
//  TabPageViewer
//
//  Created by apple on 2018/7/2.
//

import UIKit

open class TabPageViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: properties
    
    private var pageContentView: PageContentView?
    
    private var tabTitleView: TabTitleView?
    
    private var controllerList: [UIViewController] = Array()

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: methods
    public func initView(titleList: [TabTitleModel], controllers: [UIViewController], contentView: UIView){
        self.initView(titleList: titleList, controllers: controllers, contentView: contentView, configuration: TabPageViewConfiguration())
    }
    
    public func initView(titleList: [TabTitleModel], controllers: [UIViewController], contentView: UIView, configuration: TabPageViewConfiguration){
        var pageViewList = Array<UIView>()
        if controllers.count > 0 {
            for controller in controllers{
                pageViewList.append(controller.view)
                addChildViewController(controller)
                controllerList.append(controller)
            }
        }
        tabTitleView = TabTitleView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: configuration.titleHeight), titleList:
            titleList, conf: configuration.tabTitleConf, callback:{
                (index) in
                self.pageContentView?.setPage(index: index)
        })
        contentView.addSubview(tabTitleView!)
        pageContentView = PageContentView(frame: CGRect(x: 0, y: configuration.titleHeight, width: contentView.frame.width, height: contentView.frame.height - configuration.titleHeight), pageViewList: pageViewList, conf: configuration.pageViewConf, callback:{
            (offset) in
            self.tabTitleView?.setOffset(offsetRatio: offset)
        })
        contentView.addSubview(pageContentView!)
    }
}



