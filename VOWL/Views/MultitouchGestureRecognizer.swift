//
//  MultitouchGestureRecognizer.swift
//  VOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol MultitouchGestureRecognizerDelegate: UIGestureRecognizerDelegate {
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch)
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch)
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch)
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch)
    
}

class MultitouchGestureRecognizer: UIPanGestureRecognizer {
    
    lazy var touches = [UITouch]()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if (self.shouldSustainTouches()) {
            self.endTouches()
        }
        
        self.updateTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        self.updateTouches(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        
        self.updateTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        self.updateTouches(touches)
    }
    
    // MARK: - Multiple touches
    
    func updateTouches(touches: Set<UITouch>) {
        for touch in touches {
            switch touch.phase {
            case .Began:
                self.startTouch(touch)
            case .Moved:
                self.moveTouch(touch)
            case .Stationary:
                self.moveTouch(touch)
            case .Cancelled:
                self.cancelTouch(touch)
            case .Ended:
                if !self.shouldSustainTouches() {
                    self.endTouch(touch)
                }
            }
        }
    }
    
    func endTouches() {
        for touch in self.touches {
            if touch.phase == .Ended {
                self.endTouch(touch)
            }
        }
    }
    
    // MARK: - Single touches
    
    private func startTouch(touch: UITouch) {
        self.touches.append(touch)
        self.multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidBegin: touch)
    }
    
    private func moveTouch(touch: UITouch) {
        self.multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidMove: touch)
    }
    
    private func cancelTouch(touch: UITouch) {
        if let index = self.touches.indexOf(touch) {
            self.touches.removeAtIndex(index)
            self.multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidCancel: touch)
        }
    }
    
    private func endTouch(touch: UITouch) {
        if let index = self.touches.indexOf(touch) {
            self.touches.removeAtIndex(index)
            self.multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidEnd: touch)
        }
    }
    
    // MARK: - Delegate
    
    private func multitouchDelegate() -> MultitouchGestureRecognizerDelegate? {
        if let multitouchDelegate = self.delegate as? MultitouchGestureRecognizerDelegate {
            return multitouchDelegate
        }
        
        return nil
    }
    
    private func shouldSustainTouches() -> Bool {
        return self.multitouchDelegate()?.multitouchGestureRecognizerShouldSustainTouches(self) == true
    }
    
}
