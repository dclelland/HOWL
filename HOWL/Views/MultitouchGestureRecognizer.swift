//
//  MultitouchGestureRecognizer.swift
//  HOWL
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

enum MultitouchGestureRecognizerTouchState {
    case Ready
    case Live
    case Sustained
}

class MultitouchGestureRecognizer: UIPanGestureRecognizer {
    
    lazy var touches = [UITouch]()
    
    var touchState: MultitouchGestureRecognizerTouchState {
        if touches.count == 0 {
            return .Ready
        } else if numberOfTouches() > 0 {
            return .Live
        } else {
            return .Sustained
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if (shouldSustainTouches()) {
            endTouches()
        }
        
        updateTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        updateTouches(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        
        updateTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        updateTouches(touches)
    }
    
    // MARK: - Multiple touches
    
    func updateTouches(touches: Set<UITouch>) {
        for touch in touches {
            switch touch.phase {
            case .Began:
                startTouch(touch)
            case .Moved:
                moveTouch(touch)
            case .Stationary:
                moveTouch(touch)
            case .Cancelled:
                cancelTouch(touch)
            case .Ended:
                if shouldSustainTouches() {
                    moveTouch(touch)
                } else {
                    endTouch(touch)
                }
            }
        }
    }
    
    func endTouches() {
        for touch in touches {
            if touch.phase == .Ended {
                endTouch(touch)
            }
        }
    }
    
    // MARK: - Single touches
    
    private func startTouch(touch: UITouch) {
        touches.append(touch)
        multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidBegin: touch)
    }
    
    private func moveTouch(touch: UITouch) {
        multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidMove: touch)
    }
    
    private func cancelTouch(touch: UITouch) {
        if let index = touches.indexOf(touch) {
            touches.removeAtIndex(index)
            multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidCancel: touch)
        }
    }
    
    private func endTouch(touch: UITouch) {
        if let index = touches.indexOf(touch) {
            touches.removeAtIndex(index)
            multitouchDelegate()?.multitouchGestureRecognizer(self, touchDidEnd: touch)
        }
    }
    
    // MARK: - Delegate
    
    private func multitouchDelegate() -> MultitouchGestureRecognizerDelegate? {
        if let multitouchDelegate = delegate as? MultitouchGestureRecognizerDelegate {
            return multitouchDelegate
        }
        
        return nil
    }
    
    private func shouldSustainTouches() -> Bool {
        return multitouchDelegate()?.multitouchGestureRecognizerShouldSustainTouches(self) == true
    }
    
}
