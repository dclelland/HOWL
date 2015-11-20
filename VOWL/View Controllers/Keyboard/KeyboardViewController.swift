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
    
    @IBOutlet weak var holdButton: HoldButton? {
        didSet {
            holdButton?.selected = Settings.shared.keyboardSustain
        }
    }
    
    let keyboard = Keyboard()
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: HoldButton) {
        Settings.shared.keyboardSustain = !Settings.shared.keyboardSustain
        button.selected = Settings.shared.keyboardSustain
    }
    
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
            cell.textLabel?.text = key.name()
        }
        
        let path = keyboard.pathForKeyAtIndex(indexPath.item, inRow: indexPath.section, withBounds: collectionView.bounds)
        
        if let path = path, let layer = cell.layer as? CAShapeLayer {
            path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
            
            layer.path = path.CGPath
            layer.fillColor = UIColor.vowl_darkGreyColor().CGColor
            layer.strokeColor = UIColor.vowl_blackColor().CGColor
            layer.lineWidth = CGFloat(M_SQRT2)
        }
        
        return cell
    }

}
