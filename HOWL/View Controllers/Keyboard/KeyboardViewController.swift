//
//  KeyboardViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy

class KeyboardViewController: UIViewController {
    
    @IBOutlet weak var keyboardView: UICollectionView?
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer?
    
    @IBOutlet weak var holdButton: ToolbarButton? {
        didSet { holdButton?.selected = Settings.keyboardSustain.value }
    }
    
    let keyboard = Keyboard()
    
    var notes = [UITouch: SynthesizerNote]() {
        didSet { keyboardView?.reloadData() }
    }
    
    // MARK: - Note actions
    
    func playNote(withTouch touch: UITouch, frequency: Float) {
        let note = SynthesizerNote(withFrequency: frequency)
        Audio.synthesizer.playNote(note)
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
            Audio.synthesizer.stopNote(note)
            notes[touch] = nil
        }
    }
    
    // MARK: - Button events
    
    @IBAction func flipButtonTapped(button: ToolbarButton) {
        flipViewController?.flip()
    }
    
    @IBAction func holdButtonTapped(button: ToolbarButton) {
        Settings.keyboardSustain.value = !Settings.keyboardSustain.value
        button.selected = Settings.keyboardSustain.value
        
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
        
        layer.path = self.collectionView(collectionView, pathForCellAtIndexPath: indexPath, withKey: key).CGPath
        layer.fillColor = self.collectionView(collectionView, colorForCellAtIndexPath: indexPath, withKey: key).CGColor
        
        return cell
    }
    
    // MARK: - Private getters
    
    private func collectionView(collectionView: UICollectionView, pathForCellAtIndexPath indexPath: NSIndexPath, withKey key: Key) -> UIBezierPath {
        return key.path.makePath { make in
            make.translation(tx: -key.path.bounds.minX, ty: -key.path.bounds.minY)
            make.transform(collectionView.bounds.denormalizationTransform())
        }
    }
    
    private func collectionView(collectionView: UICollectionView, colorForCellAtIndexPath indexPath: NSIndexPath, withKey key: Key) -> UIColor {
        let keyNotes = notes.values.filter { $0.frequency.value == key.frequency }
        
        if keyNotes.count > 0 {
            return UIColor.HOWL.lightColor(withHue: CGFloat(key.pitch) % 12.0 / 12.0)
        } else {
            return UIColor.HOWL.darkGreyColor()
        }
    }
    
}

// MARK: - Keyboard view layout delegate

extension KeyboardViewController: KeyboardViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath? {
        guard let key = keyboard.keyAtIndex(indexPath.item, inRow: indexPath.section) else {
            return nil
        }
        
        return key.path.makePath { make in
            make.transform(collectionView.bounds.denormalizationTransform())
        }
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension KeyboardViewController: MultitouchGestureRecognizerDelegate {
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool {
        return Settings.keyboardSustain.value
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
