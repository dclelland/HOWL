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
    
    var touches = [UITouch]()
    
    // MARK: Touches
    
    func updateTouches(touches: Set<UITouch>) {
        touches.forEach { (touch) -> () in
            switch touch.phase {
            case .Began:
                self.startTouch(touch)
            case .Moved:
                self.updateTouch(touch)
            case .Stationary:
                self.updateTouch(touch)
            case .Cancelled:
                self.endTouch(touch)
            case .Ended:
                self.endTouch(touch)
            }
        }
        
        self.keyboardView?.reloadData()
    }
    
    func startTouch(touch: UITouch) {
        print("start")
        self.touches.append(touch)
    }
    
    func updateTouch(touch: UITouch) {
        print("update")
    }
    
    func endTouch(touch: UITouch) {
        print("end")
        if let index = self.touches.indexOf(touch) {
            self.touches.removeAtIndex(index)
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: UIButton) {
        print("hold button tapped")
    }
    
    // MARK: - Touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.updateTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        self.updateTouches(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if let touches = touches {
            self.updateTouches(touches)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.updateTouches(touches)
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
            layer.fillColor = UIColor(white: 0.2, alpha: 1.0).CGColor
            layer.strokeColor = UIColor.blackColor().CGColor
            layer.lineWidth = CGFloat(M_SQRT2)
        }
        
        return cell
    }

}
