//
//  KeyboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController {
    
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
            keyboardView?.reloadData()
        }
    }
    
    // MARK: - Note actions
    
    func playNote(withTouch touch: UITouch, frequency: Float) {
        let note = SynthesizerNote(withFrequency: frequency)
        Audio.shared.synthesizer.playNote(note)
        notes[touch] = note
    }
    
    func updateNote(withTouch touch: UITouch, frequency: Float) {
        if let note = notes[touch] {
            if note.frequency.value != frequency {
                stopNote(withTouch: touch)
                playNote(withTouch: touch, frequency: frequency)
            }
        } else {
            playNote(withTouch: touch, frequency: frequency)
        }
    }
    
    func stopNote(withTouch touch: UITouch) {
        if let note = notes[touch] {
            Audio.shared.synthesizer.stopNote(note)
            notes[touch] = nil
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: HoldButton) {
        Settings.shared.keyboardSustain = !Settings.shared.keyboardSustain
        button.selected = Settings.shared.keyboardSustain
        
        if !button.selected {
            multitouchGestureRecognizer?.endTouches()
        }
    }
    
}

// MARK: - Collection view data source

extension KeyboardViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return keyboard.numberOfRows()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboard.numberOfKeysInRow(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("keyboardViewCell", forIndexPath: indexPath) as! KeyboardViewCell
        let layer = cell.layer as! CAShapeLayer
        
        guard let key = keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section) else {
            return cell
        }
        
        let path = key.path
        
        path.applyTransform(collectionView.bounds.denormalizationTransform())
        path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, -path.bounds.minY))
        layer.path = path.CGPath
        
        let keyNotes = notes.values.filter { $0.frequency.value == key.frequency }
        
        if keyNotes.count > 0 {
            let color = UIColor.VOWL.lightColor(withHue: CGFloat(key.pitch) % 12.0 / 12.0)
            layer.fillColor = color.CGColor
        } else {
            let color = UIColor.VOWL.darkGreyColor()
            layer.fillColor = color.CGColor
        }
        
        return cell
    }
    
}

// MARK: - Keyboard view layout delegate

extension KeyboardViewController: KeyboardViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath? {
        guard let key = keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section) else {
            return nil
        }
        
        let path = key.path
        path.applyTransform(collectionView.bounds.denormalizationTransform())
        return path
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension KeyboardViewController: MultitouchGestureRecognizerDelegate {
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool {
        return Settings.shared.keyboardSustain
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(keyboardView), keyboardView!.bounds.normalizationTransform())
        
        if let key = keyboard.keyAtLocation(location) {
            playNote(withTouch: touch, frequency: key.frequency)
        }
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        let location = CGPointApplyAffineTransform(touch.locationInView(keyboardView), keyboardView!.bounds.normalizationTransform())
        
        if let key = keyboard.keyAtLocation(location) {
            updateNote(withTouch: touch, frequency: key.frequency)
        } else {
            stopNote(withTouch: touch)
        }
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        stopNote(withTouch: touch)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        stopNote(withTouch: touch)
    }
    
}
