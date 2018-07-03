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
    public func initView(titleList: [String], controllers: [UIViewController], contentView: UIView){
        var pageViewList = Array<UIView>()
        if controllers.count > 0 {
            for controller in controllers{
                pageViewList.append(controller.view)
                addChildViewController(controller)
                controllerList.append(controller)
            }
        }
        tabTitleView = TabTitleView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: CGFloat(50)), titleArr:
            titleList, callback:{
                (index) in
                self.pageContentView?.setOffset(index: index)
        })
        contentView.addSubview(tabTitleView!)
        pageContentView = PageContentView(frame: CGRect(x: 0, y: 50, width: contentView.frame.width, height: contentView.frame.height - CGFloat(50)), pageViewList: pageViewList, callback:{
            (index) in
            self.tabTitleView?.setOffset(index: index)
        })
        contentView.addSubview(pageContentView!)
        
    }


}

