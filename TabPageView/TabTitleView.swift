//
//  TabTitleView.swift
//  TabPageView
//
//  Created by apple on 2018/7/2.
//

import UIKit

class TabTitleView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var collectionView: UICollectionView?
    
    private var collectionLayout: UICollectionViewFlowLayout?
    
    private var scrollBar: UIView?
    
    private var titleList : [TabTitleModel]?
    
    private var titleViewList: [UIView]?
    
    private var callback : ((_ index: Int) ->())?
    
    private var currentIndex : Int = 0
    
    private var conf : TabTitleConfiguration?
    
    convenience init(frame: CGRect, titleList: [TabTitleModel], conf: TabTitleConfiguration, callback: @escaping (_ index: Int) ->()){
        self.init(frame: frame)
        self.conf = conf
        self.callback = callback
        self.titleList = titleList
        for index in 0...titleList.count - 1 {
            let view = UIView()
            let imageView = UIImageView(image: titleList[index].image)
            var imageWidth: CGFloat
            if conf.iconWidth != nil{
                imageWidth = conf.iconWidth!
            }else{
                imageWidth = frame.height - 3
            }
            let labelView = UILabel(frame: CGRect(x: imageWidth, y: 0, width: 100, height: imageWidth))
            imageView.layer.masksToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth)
                        
            labelView.text = titleList[index].titleName
            labelView.textColor = conf.textColor
            labelView.sizeToFit()
            labelView.frame = CGRect(origin: labelView.frame.origin, size: CGSize(width: labelView.frame.width, height: imageWidth))
            labelView.textAlignment = NSTextAlignment.center
            view.addSubview(imageView)
            view.addSubview(labelView)
            
            view.frame = CGRect(x: 0, y: 0, width: imageWidth + labelView.frame.width, height: imageWidth)
            view.backgroundColor = conf.titleBackgroundColor
            if titleViewList == nil{
                titleViewList = Array()
            }
            titleViewList?.append(view)
        }
        if let firstTitleView = titleViewList?[0]{
            scrollBar = UIView(frame: CGRect(x: 0, y: frame.height - 3, width: firstTitleView.frame.width, height: 3))
            scrollBar?.backgroundColor = conf.baseLineColor
            addSubview(scrollBar!)
        }
        collectionView?.backgroundColor = conf.titleBackgroundColor
        
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout!.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: collectionLayout!)
        collectionView?.isScrollEnabled = true
        addSubview(collectionView!)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "test")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = titleList?.count {
            return count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)

        cell.contentView.addSubview(titleViewList![indexPath.row])
        
        return cell
    }
    
    // MARK: delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if titleViewList != nil{
            return titleViewList![indexPath.row].bounds.size
        }else{
            return CGSize(width: 100, height: 50)
        }
        
    }
    
    // MARK: methods
    func setOffset(offsetRatio: CGFloat){
        var offsetX = CGFloat()
        offsetX = 0
        let index = Int(offsetRatio)
        if index > 0{
            for i in 0...index - 1{
                offsetX += titleViewList![i].bounds.width
                offsetX += collectionLayout!.minimumInteritemSpacing
            }
        }
        offsetX += (titleViewList![index].bounds.width + collectionLayout!.minimumInteritemSpacing) * (offsetRatio - CGFloat(index))
        UIView.animate(withDuration: 0.0, animations: {
            var width: CGFloat
            if index < self.titleViewList!.count - 1{
                width = self.titleViewList![index].frame.width + (self.titleViewList![index + 1].frame.width - self.titleViewList![index].frame.width) * (offsetRatio - CGFloat(index))
            }else{
                width = self.titleViewList![index].frame.width
            }
            
            self.scrollBar!.frame = CGRect(x:offsetX, y:self.scrollBar!.frame.origin.y, width: width, height:self.scrollBar!.frame.height)
            
        })
        currentIndex = index
    }
    
    func setIndex(index: Int){
        var offsetX = CGFloat()
        offsetX = 0
        if let viewList = titleViewList, index > 0{
            for index in 0...index - 1{
                offsetX += viewList[index].bounds.width
                offsetX += collectionLayout!.minimumInteritemSpacing
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            
            self.scrollBar!.frame = CGRect(x:offsetX, y:self.scrollBar!.frame.origin.y, width:self.titleViewList![index].frame.width, height:self.scrollBar!.frame.height)
            
        })
        currentIndex = index
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex != indexPath.row {
            setIndex(index: indexPath.row)
            callback!(indexPath.row)
            currentIndex = indexPath.row
        }
    }
}
