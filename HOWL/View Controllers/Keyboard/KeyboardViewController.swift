//
//  KeyboardViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import MultitouchGestureRecognizer

class KeyboardViewController: UIViewController {
    
    @IBOutlet weak var keyboardView: UICollectionView?
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer?
    
    @IBOutlet weak var holdButton: UIButton? {
        didSet { holdButton?.selected = Settings.keyboardSustain.value }
    }
    
    let keyboard = Keyboard(leftInterval: Settings.keyboardLeftInterval.value, rightInterval: Settings.keyboardRightInterval.value)
    
    var notes = [UITouch: (key: Key, note: SynthesizerNote)]()
    
    var mode: Mode = .Normal {
        didSet { refreshView() }
    }
    
    enum Mode {
        case Normal
        case ShowBackground
    }
    
    // MARK: - Life cycle
    
    func refreshNotes() {
        notes.keys.forEach { touch in
            if let key = keyForTouch(touch) {
                updateNoteForTouch(touch, withKey: key)
            } else {
                stopNoteForTouch(touch)
            }
        }
    }
    
    func refreshView() {
        keyboardView?.reloadData()
    }
    
    // MARK: - Note actions
    
    func playNoteForTouch(touch: UITouch, withKey key: Key) {
        let note = SynthesizerNote(frequency: key.frequency)
        Audio.synthesizer.playNote(note)
        notes[touch] = (key: key, note: note)
    }
    
    func updateNoteForTouch(touch: UITouch, withKey key: Key) {
        if let oldKey = notes[touch]?.key {
            if oldKey != key {
                stopNoteForTouch(touch)
                playNoteForTouch(touch, withKey: key)
            }
        } else {
            playNoteForTouch(touch, withKey: key)
        }
    }
    
    func stopNoteForTouch(touch: UITouch) {
        if let note = notes[touch]?.note {
            Audio.synthesizer.stopNote(note)
            notes[touch] = nil
        }
    }
    
    // MARK: - Button events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func holdButtonTapped(button: UIButton) {
        Settings.keyboardSustain.value = !Settings.keyboardSustain.value
        button.selected = Settings.keyboardSustain.value
        
        if !button.selected {
            multitouchGestureRecognizer?.reset()
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
        let keyNotes = notes.values.filter { $0.key == key }
        
        let hue = CGFloat(key.note) / 12.0
        let saturation = 1.0 - CGFloat(key.pitch - keyboard.centerPitch) / CGFloat(keyboard.centerPitch)
        let brightness = 1.0 - CGFloat(keyboard.centerPitch - key.pitch) / CGFloat(keyboard.centerPitch)
        
        if keyNotes.count > 0 {
            return UIColor.HOWL.lightColor(withHue: hue, saturation: saturation, brightness: brightness)
        }
        
        if mode == .ShowBackground {
            return UIColor.HOWL.darkColor(withHue: hue, saturation: saturation, brightness: brightness)
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
        if let key = keyForTouch(touch) {
            playNoteForTouch(touch, withKey: key)
        }
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        if let key = keyForTouch(touch) {
            updateNoteForTouch(touch, withKey: key)
        } else {
            stopNoteForTouch(touch)
        }
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        stopNoteForTouch(touch)
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        stopNoteForTouch(touch)
        refreshView()
    }
    
    // MARK: Private getters
    
    private func keyForTouch(touch: UITouch) -> Key? {
        let location = CGPointApplyAffineTransform(touch.locationInView(keyboardView), keyboardView!.bounds.normalizationTransform())
        
        return keyboard.keyAtLocation(location)
    }
    
}
