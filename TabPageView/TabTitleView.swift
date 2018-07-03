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
    
    private var titleArr : [String]?
    
    private var titleViewList: [UIView]?
    
    private var callback : ((_ index: Int) ->())?
    
    private var currentIndex : Int = 0
    
    convenience init(frame: CGRect, titleArr: [String], callback: @escaping (_ index: Int) ->()){
        self.init(frame: frame)
        self.callback = callback
        self.titleArr = titleArr
        for index in 0...titleArr.count - 1 {
            let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: frame.height - 3))
            
            view.text = titleArr[index]
            view.sizeToFit()
            if titleViewList == nil{
                titleViewList = Array()
            }
            titleViewList?.append(view)
        }
        if let firstTitleView = titleViewList?[0]{
            scrollBar = UIView(frame: CGRect(x: 0, y: frame.height - 3, width: firstTitleView.frame.width, height: 3))
            scrollBar?.backgroundColor = UIColor.blue
            addSubview(scrollBar!)
        }
        
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout!.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: collectionLayout!)
        collectionView?.backgroundColor = UIColor.white
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
        if let count = titleArr?.count {
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
    func setOffset(index: Int){
        var offsetX = CGFloat()
        offsetX = 0
        if let viewList = titleViewList, index > 0{
            for index in 0...index - 1{
                offsetX += viewList[index].bounds.width
                offsetX += collectionLayout!.minimumInteritemSpacing
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            
            self.scrollBar!.frame = CGRect(x:offsetX, y:self.scrollBar!.frame.origin.y, width:self.titleViewList![index].frame.width, height:self.scrollBar!.frame.height)
            
        })
        currentIndex = index
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex != indexPath.row {
            setOffset(index: indexPath.row)
            callback!(indexPath.row)
            currentIndex = indexPath.row
        }
    }
}
