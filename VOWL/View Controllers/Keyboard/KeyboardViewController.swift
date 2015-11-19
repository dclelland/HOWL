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
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath? {
        return keyboard.pathForKeyAtIndex(indexPath.item, inRow: indexPath.section, withBounds: collectionView.bounds)
    }
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return keyboard.numberOfRows()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboard.numberOfKeysInRow(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("keyboardViewCell", forIndexPath: indexPath) as! KeyboardViewCell
        
        let key = keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section)
        
        if let key = key {
            cell.textLabel?.text = String(key.pitch)
        }
        
        let path = keyboard.pathForKeyAtIndex(indexPath.item, inRow: indexPath.section, withBounds: collectionView.bounds)
        
        if let path = path, let layer = cell.layer as? CAShapeLayer {
            path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
            
            layer.path = path.CGPath
            layer.fillColor = UIColor(white: 0.2, alpha: 1.0).CGColor
            layer.strokeColor = UIColor.blackColor().CGColor
            layer.lineWidth = CGFloat(M_SQRT2)
        }
        
        return cell
    }

}
