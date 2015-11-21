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
    
    var notes = [UITouch: SynthesizerNote]() {
        didSet {
            self.refreshView()
        }
    }
    
    // MARK: - Life cycle
    
    func refreshView() {
        self.keyboardView?.reloadData()
    }
    
    // MARK: - Note actions
    
    func playNote(withTouch touch: UITouch, frequency: Float) {
        let note = SynthesizerNote(withFrequency: frequency)
        Audio.shared.synthesizer.playNote(note)
        self.notes[touch] = note
    }
    
    func updateNote(withTouch touch: UITouch, frequency: Float) {
        if let note = self.notes[touch] {
            if note.frequency.value != frequency {
                self.stopNote(withTouch: touch)
                self.playNote(withTouch: touch, frequency: frequency)
            }
        } else {
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
        guard let key = self.keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section) else {
            return nil
        }
        
        let path = key.path
        path.applyTransform(collectionView.bounds.denormalizationTransform())
        return path
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
        
        guard let key = self.keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section) else {
            return cell
        }
        
        let path = key.path
        
        path.applyTransform(collectionView.bounds.denormalizationTransform())
        path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
        layer.path = path.CGPath
        
        let notes = self.notes.values.filter { $0.frequency.value == key.frequency() }
        
        if notes.count > 0 {
            let color = UIColor.VOWL.lightColor(withHue: CGFloat(key.pitch) % 12.0 / 12.0)
            layer.fillColor = color.CGColor
        } else {
            let color = UIColor.VOWL.darkGreyColor()
            layer.fillColor = color.CGColor
        }
        
        return cell
    }
    
    // MARK: - Multitouch gesture recognizer delegate
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool {
        return Settings.shared.keyboardSustain
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(self.keyboardView), self.keyboardView!.bounds.normalizationTransform())
        
        if let key = self.keyboard.keyAtLocation(location) {
            self.playNote(withTouch: touch, frequency: key.frequency())
        }
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(self.keyboardView), self.keyboardView!.bounds.normalizationTransform())
        
        if let key = self.keyboard.keyAtLocation(location) {
            self.updateNote(withTouch: touch, frequency: key.frequency())
        } else {
            self.stopNote(withTouch: touch)
        }
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        self.stopNote(withTouch: touch)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        self.stopNote(withTouch: touch)
    }
    
}
