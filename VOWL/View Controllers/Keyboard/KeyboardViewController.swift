//
//  KeyboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UICollectionViewDataSource, KeyboardViewLayoutDelegate, MultitouchGestureRecognizerDelegate {
    
    @IBOutlet weak var keyboardView: UICollectionView?
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer?
    
    @IBOutlet weak var holdButton: HoldButton? {
        didSet {
            holdButton?.selected = Settings.shared.keyboardSustain
        }
    }
    
    let keyboard = Keyboard()
    
    var notes = [UITouch: SynthesizerNote]()
    
    // MARK: - Note actions
    
    func playNote(withTouch touch: UITouch, frequency: Float) {
        let note = SynthesizerNote(withFrequency: frequency)
        Audio.shared.synthesizer.playNote(note)
        self.notes[touch] = note
    }
    
    func updateNote(withTouch touch: UITouch, frequency: Float) {
        if let note = self.notes[touch] where note.frequency.value != frequency {
            self.stopNote(withTouch: touch)
            self.playNote(withTouch: touch, frequency: frequency)
        }
    }
    
    func stopNote(withTouch touch: UITouch) {
        if let note = self.notes[touch] {
            Audio.shared.synthesizer.stopNote(note)
            self.notes[touch] = nil
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: HoldButton) {
        Settings.shared.keyboardSustain = !Settings.shared.keyboardSustain
        button.selected = Settings.shared.keyboardSustain
        
        if !button.selected {
            self.multitouchGestureRecognizer?.endTouches()
        }
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath? {
        return self.collectionView(collectionView, pathForItemAtIndexPath: indexPath)
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
        let layer = cell.layer as! CAShapeLayer
        
        let path = self.collectionView(collectionView, pathForItemAtIndexPath: indexPath)
        
        path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
        
        layer.path = path.CGPath
        layer.fillColor = UIColor.vowl_darkGreyColor().CGColor
        layer.strokeColor = UIColor.vowl_blackColor().CGColor
        layer.lineWidth = CGFloat(M_SQRT2)
        
        return cell
    }
    
    // MARK: - Multitouch gesture recognizer delegate
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool {
        return Settings.shared.keyboardSustain
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(self.keyboardView), self.keyboardView!.bounds.normalizationTransform())
        
        self.playNote(withTouch: touch, frequency: self.frequencyForItemAtLocation(location))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(self.keyboardView), self.keyboardView!.bounds.normalizationTransform())
        
        self.updateNote(withTouch: touch, frequency: self.frequencyForItemAtLocation(location))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        self.stopNote(withTouch: touch)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        self.stopNote(withTouch: touch)
    }
    
    // MARK: Collection view paths
    
    func collectionView(collectionView: UICollectionView, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath {
        let path = self.keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section).path
        
        path.applyTransform(collectionView.bounds.denormalizationTransform())
        
        return path
    }
    
    // MARK: Frequencies
    
    func frequencyForItemAtLocation(location: CGPoint) -> Float {
        for row in 0..<self.keyboard.numberOfRows() {
            for index in 0..<self.keyboard.numberOfKeysInRow(row) {
                let key = self.keyboard.keyAtIndex(index, inRow: row)
                if key.path.containsPoint(location) {
                    return key.frequency()
                }
            }
        }
        
        return 0.0
    }
    
}
