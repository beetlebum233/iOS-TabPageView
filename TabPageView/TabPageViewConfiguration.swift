//
//  TabPageViewConfiguration.swift
//  TabPageView
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation

public struct TabPageViewConfiguration{
    public var titleHeight: CGFloat = CGFloat(50)
    public var tabTitleConf: TabTitleConfiguration = TabTitleConfiguration()
    public var pageViewConf: PageViewConfiguration = PageViewConfiguration()
    
    public init(){
        
    }
    
    public init(titleHeight: CGFloat, needScrollView: Bool, baseLineColor: UIColor, titleBackgroundColor: UIColor, textColor: UIColor){
        self.titleHeight = titleHeight
        self.pageViewConf.needScrollView = needScrollView
        self.tabTitleConf.baseLineColor = baseLineColor
        self.tabTitleConf.titleBackgroundColor = titleBackgroundColor
        self.tabTitleConf.textColor = textColor
    }
}

public struct TabTitleConfiguration{
    public var baseLineColor: UIColor = UIColor.blue
    public var titleBackgroundColor: UIColor = UIColor.white
    public var textColor: UIColor = UIColor.black
    
    init(){
        
    }
}

public struct PageViewConfiguration{
    public var needScrollView: Bool = false
    
    init(){
        
    }
}
