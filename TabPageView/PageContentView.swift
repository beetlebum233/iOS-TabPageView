//
//  PageContentView.swift
//  TabPageView
//
//  Created by apple on 2018/7/2.
//

import UIKit

class PageContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var collectionView : UICollectionView?
    
    private var currentIndex : Int = 0
    
    private var callback : ((_ index: Int) ->())?
    
    private var pageViewList: [UIView]?
    
    convenience init(frame: CGRect, pageViewList: [UIView], callback: @escaping (_ index: Int) ->()){
        self.init(frame: frame)
        self.callback = callback
        self.pageViewList = pageViewList
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = frame.size
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size), collectionViewLayout: collectionLayout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.isPagingEnabled = true
        addSubview(collectionView!)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.bounces = false
        if pageViewList.count > 0{
            for index in 0...pageViewList.count{
                collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "test\(index)")
            }
        }
        
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = pageViewList?.count {
            return count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test\(indexPath.row)", for: indexPath)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        let view = pageViewList![indexPath.row]
        scrollView.addSubview(view)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        
        cell.contentView.addSubview(scrollView)
        
        return cell
    }
    
    // MARK: delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newIndex = Int((collectionView!.contentOffset.x + self.frame.width / 2) / self.frame.width)
        if newIndex != currentIndex{
            callback!(newIndex)
            currentIndex = newIndex
        }
    }
    
    // MARK: methods
    func setOffset(index: Int){
        let point = CGPoint(x: CGFloat(index) * collectionView!.frame.size.width, y:collectionView!.frame.origin.y)
        collectionView?.setContentOffset(point, animated: true)
        currentIndex = index
    }

}
