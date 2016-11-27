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
    
    @IBOutlet weak var keyboardView: UICollectionView!
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer! {
        didSet {
            multitouchGestureRecognizer.sustain = Settings.keyboardSustain.value
        }
    }
    
    @IBOutlet weak var flipButton: UIButton?
    
    @IBOutlet weak var holdButton: UIButton? {
        didSet {
            holdButton?.isSelected = Settings.keyboardSustain.value
        }
    }
    
    let keyboard: Keyboard = {
        if case .phone = UIDevice.current.userInterfaceIdiom {
            return Keyboard(width: 4, height: 5, leftInterval: Settings.keyboardLeftInterval.value, rightInterval: Settings.keyboardRightInterval.value)
        } else {
            return Keyboard(width: 5, height: 5, leftInterval: Settings.keyboardLeftInterval.value, rightInterval: Settings.keyboardRightInterval.value)
        }
    }()
    
    var notes = Dictionary<UITouch, (key: Key, note: Synthesizer.Note)>()
    
    var mode: Mode = .normal {
        didSet {
            reloadView()
        }
    }
    
    enum Mode {
        case normal
        case showBackground
    }
    
    // MARK: - Overrides
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Audio.didStartNotification, object: nil, queue: nil) { notification in
            self.reloadSynthesizer()
        }
    }
    
    // MARK: - Life cycle
    
    func updateSynthesizer() {
        notes.keys.forEach { touch in
            if let key = key(for: touch) {
                updateNote(for: touch, with: key)
            } else {
                stopNote(for: touch)
            }
        }
    }
    
    func reloadSynthesizer() {
        notes.keys.forEach { touch in
            if let key = key(for: touch) {
                stopNote(for: touch)
                playNote(for: touch, with: key)
            } else {
                stopNote(for: touch)
            }
        }
    }
    
    func stopSynthesizer() {
        notes.keys.forEach { touch in
            stopNote(for: touch)
        }
    }
    
    func reloadView() {
        keyboardView.reloadData()
    }
    
    // MARK: - Note actions
    
    func playNote(for touch: UITouch, with key: Key) {
        if let note = Audio.client?.synthesizer.note(with: key.pitch.frequency) {
            Audio.client?.synthesizer.play(note)
            notes[touch] = (key: key, note: note)
        }
    }
    
    func updateNote(for touch: UITouch, with key: Key) {
        if let oldKey = notes[touch]?.key {
            if oldKey != key {
                stopNote(for: touch)
                playNote(for: touch, with: key)
            }
        } else if (touch.phase != .ended) {
            playNote(for: touch, with: key)
        }
    }
    
    func stopNote(for touch: UITouch) {
        if let note = notes[touch]?.note {
            Audio.client?.synthesizer.stop(note)
            notes[touch] = nil
        }
    }
    
    // MARK: - Button events
    
    @IBAction func flipButtonTapped(_ button: UIButton) {
        flipViewController?.flip()
        
        if !Settings.keyboardSustain.value {
            stopSynthesizer()
            reloadView()
        }
    }
    
    @IBAction func holdButtonTapped(_ button: UIButton) {
        let sustain = !Settings.keyboardSustain.value
        
        holdButton?.isSelected = sustain
        Settings.keyboardSustain.value = sustain
        multitouchGestureRecognizer.sustain = sustain
    }
    
    // MARK: Private getters
    
    fileprivate func key(for touch: UITouch) -> Key? {
        guard let keyboardView = keyboardView else {
            return nil
        }
        
        let location = touch.location(in: keyboardView).ilerp(rect: keyboardView.bounds)
        
        return keyboard.key(at: location)
    }

}

// MARK: - Collection view data source

extension KeyboardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keyboard.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboard.numberOfKeys(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyboardViewCell", for: indexPath) as! KeyboardViewCell
        let layer = cell.layer as! CAShapeLayer
        
        guard let key = keyboard.key(at: indexPath.item, in: indexPath.section) else {
            return cell
        }
        
        layer.path = self.collectionView(collectionView, pathForCellAt: indexPath, with: key).cgPath
        layer.fillColor = self.collectionView(collectionView, colorForCellAt: indexPath, with: key).cgColor
        
        return cell
    }
    
    // MARK: - Private getters
    
    private func collectionView(_ collectionView: UICollectionView, pathForCellAt indexPath: IndexPath, with key: Key) -> UIBezierPath {
        return UIBezierPath.make(key.path) { path in
            path.translate(tx: -key.path.bounds.minX, ty: -key.path.bounds.minY)
            path.scale(sx: collectionView.bounds.width, sy: collectionView.bounds.height)
            path.translate(tx: collectionView.bounds.minX, ty: collectionView.bounds.minY)
        }
    }
    
    private func collectionView(_ collectionView: UICollectionView, colorForCellAt indexPath: IndexPath, with key: Key) -> UIColor {
        let keyNotes = notes.values.filter { $0.key == key }
        
        let hue = CGFloat(key.pitch.note.rawValue) / 12.0
        let saturation = 1.0 - CGFloat(key.pitch.number - keyboard.centerPitch.number) / CGFloat(keyboard.centerPitch.number)
        let brightness = 1.0 - CGFloat(keyboard.centerPitch.number - key.pitch.number) / CGFloat(keyboard.centerPitch.number)
        
        if keyNotes.count > 0 {
            return .protonomeLight(hue: hue, saturation: saturation, brightness: brightness)
        }
        
        if mode == .showBackground {
            return .protonomeDark(hue: hue, saturation: saturation, brightness: brightness)
        } else {
            return .protonomeDarkGray
        }
    }
    
}

// MARK: - Keyboard view layout delegate

extension KeyboardViewController: KeyboardViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: IndexPath) -> UIBezierPath? {
        guard let key = keyboard.key(at: indexPath.item, in: indexPath.section) else {
            return nil
        }
        
        return UIBezierPath.make(key.path) { path in
            path.scale(sx: collectionView.bounds.width, sy: collectionView.bounds.height)
            path.translate(tx: collectionView.bounds.minX, ty: collectionView.bounds.minY)
        }
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension KeyboardViewController: MultitouchGestureRecognizerDelegate {
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        if let key = key(for: touch) {
            playNote(for: touch, with: key)
        }
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        if let key = key(for: touch) {
            updateNote(for: touch, with: key)
        } else {
            stopNote(for: touch)
        }
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        stopNote(for: touch)
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        stopNote(for: touch)
        reloadView()
    }
    
}
