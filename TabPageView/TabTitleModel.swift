//
//  TabTitleModel.swift
//  TabPageView
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation

public struct TabTitleModel{
    public var titleName: String
    public var image: UIImage
    public init(_ titleName: String, _ image: UIImage) {
        self.titleName = titleName
        self.image = image
    }
}
