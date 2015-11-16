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
        return keyboard.hitPathForKeyAtIndex(indexPath.item, inBounds: collectionView.bounds)
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
        
        if let layer = cell.layer as? CAShapeLayer {
            layer.path = self.collectionView(collectionView, pathForItemAtIndexPath: indexPath).CGPath
            layer.fillColor = self.collectionView(collectionView, colorForItemAtIndexPath: indexPath).CGColor
        }
        
        return cell
    }
    
    // MARK: - Cell configuration
    
    private func collectionView(collectionView: UICollectionView, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath {
        let hitPath = keyboard.hitPathForKeyAtIndex(indexPath.item, inBounds: collectionView.bounds)
        let drawPath = keyboard.drawPathForKeyAtIndex(indexPath.item, inBounds: collectionView.bounds)
        
        drawPath.applyTransform(CGAffineTransformMakeTranslation(-hitPath.bounds.origin.x, -hitPath.bounds.origin.y))
        
        return drawPath
    }
    
    private func collectionView(collectionView: UICollectionView, colorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor {
        return UIColor.orangeColor()
    }

}
