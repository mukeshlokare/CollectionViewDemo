//
//  ViewController.swift
//  CollectionViewPagging
//
//  Created by webwerks on 30/08/17.
//  Copyright © 2017 smart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var isfirstTimeTransform = Bool()
    let ANIMATION_SPEED = 0.2
    let TRANSFORM_CELL_VALUE = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
    
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isfirstTimeTransform = true

        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if indexPath.row == 0 && isfirstTimeTransform {
            // make a bool and set YES initially, this check will prevent fist load transform
            isfirstTimeTransform = false
        }
        else {
            cell?.transform = TRANSFORM_CELL_VALUE
            // the new cell will always be transform and without animation
        }
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if pageNumber == 3 {
            
            print("Last Index")
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      
        let pageWidth: Float = 200 + 30
        // width + space
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
     
        
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        
        
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        
      
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: Int(newTargetOffset), y: 0), animated: true)
        var index: Int = Int(newTargetOffset / pageWidth)
      
        if index == 0 {
            // If first index
            var cell: UICollectionViewCell? = collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = CGAffineTransform.identity
            })
            pageNumber = index;
            cell = collectionView?.cellForItem(at: IndexPath(item: index + 1, section: 0))
        }else{
           
            var cell: UICollectionViewCell? = collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = CGAffineTransform.identity
            })
           
            
            index -= 1
            pageNumber = index;
            // left
            cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = self.TRANSFORM_CELL_VALUE
            })
            
            
            index += 1
            index += 1
            pageNumber = index;
            
            // right
            cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = self.TRANSFORM_CELL_VALUE
            })
        }
    }
}


extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{

}

