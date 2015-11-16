//
//  KeyboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UICollectionViewDataSource, KeyboardViewLayoutDelegate {
    
    @IBOutlet weak var keyboardView: UICollectionView?
    
    let keyboard = Keyboard()
    
    // MARK: - Collection view delegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath {
        return keyboard.pathForKeyAtIndex(indexPath.item, inBounds: collectionView.bounds)
    }
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboard.numberOfKeys()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("keyboardViewCell", forIndexPath: indexPath) as! KeyboardViewCell
        let path = keyboard.pathForKeyAtIndex(indexPath.item, inBounds: collectionView.bounds)
        
        path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
        
        if let layer = cell.layer as? CAShapeLayer {
            layer.path = path.CGPath
            layer.fillColor = UIColor.orangeColor().CGColor
            layer.strokeColor = UIColor.init(white: 0.2, alpha: 1.0).CGColor
            layer.lineWidth = CGFloat(M_SQRT2)
        }
        
        return cell
    }

}
