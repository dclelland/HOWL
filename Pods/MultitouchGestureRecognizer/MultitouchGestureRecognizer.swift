//
//  MultitouchGestureRecognizer.swift
//  MultitouchGestureRecognizer
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// Extension of `UIGestureRecognizerDelegate` which allows the delegate to receive messages relating to individual touches. The `delegate` property can be set to a class implementing `MultitouchGestureRecognizerDelegate` and it will receive these messages.
@objc public protocol MultitouchGestureRecognizerDelegate: UIGestureRecognizerDelegate {
    
    /// Called when a touch is started.
    optional func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch)
    
    /// Called when a touch is updates.
    optional func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch)
    
    /// Called when a touch is cancelled.
    optional func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch)
    
    /// Called when a touch is ended.
    optional func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch)
    
}

/// `UIPanGestureRecognizer` subclass which tracks the state of individual touches.
public class MultitouchGestureRecognizer: UIGestureRecognizer {
    
    /// If `sustain` is set to `true`, when touches end they will be retained in `touches` until such time as all touches have ended and a new touch begins.
    /// If `sustain` is switched from `true` to `false`, any currently sustained touches will be ended immediately.
    @IBInspectable public var sustain: Bool = true {
        didSet {
            if (oldValue == true && sustain == false) {
                endTouches()
            }
        }
    }
    
    /// The currently tracked collection of touches. May contain touches after they have ended, if `sustain` is set to `true`.
    public lazy var touches = [UITouch]()
    
    /// The current gesture recognizer state, as it pertains to the `sustain` setting.
    public enum State {
        
        /// All touches are ended, and none are being sustained.
        case Ready
        
        /// One more more touches are currently in progress.
        case Live
        
        /// All touches have ended, but one or more is being retained in the `touches` collection thanks to the `sustain` setting.
        case Sustained
    }
    
    /// The current multitouch gesture recognizer state.
    public var multitouchState: State {
        if touches.count == 0 {
            return .Ready
        } else if touches.filter({ $0.phase != .Ended }).count > 0 {
            return .Live
        } else {
            return .Sustained
        }
    }
    
    // MARK: - Delegate
    
    internal var multitouchDelegate: MultitouchGestureRecognizerDelegate? {
        return delegate as? MultitouchGestureRecognizerDelegate
    }
    
    // MARK: - Overrides
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        if (sustain) {
            endTouches()
        }
        updateTouches(touches)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        updateTouches(touches)
    }
    
    public override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        updateTouches(touches)
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        updateTouches(touches)
    }
    
    // MARK: - Multiple touches
    
    private func updateTouches(touches: Set<UITouch>) {
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
            case .Ended where sustain:
                moveTouch(touch)
            case .Ended:
                endTouch(touch)
            }
        }
    }
    
    private func endTouches() {
        for touch in touches where touch.phase == .Ended {
            endTouch(touch)
        }
    }
    
    // MARK: - Single touches
    
    private func startTouch(touch: UITouch) {
        touches.append(touch)
        multitouchDelegate?.multitouchGestureRecognizer?(self, touchDidBegin: touch)
    }
    
    private func moveTouch(touch: UITouch) {
        multitouchDelegate?.multitouchGestureRecognizer?(self, touchDidMove: touch)
    }
    
    private func cancelTouch(touch: UITouch) {
        if let index = touches.indexOf(touch) {
            touches.removeAtIndex(index)
            multitouchDelegate?.multitouchGestureRecognizer?(self, touchDidCancel: touch)
        }
    }
    
    private func endTouch(touch: UITouch) {
        if let index = touches.indexOf(touch) {
            touches.removeAtIndex(index)
            multitouchDelegate?.multitouchGestureRecognizer?(self, touchDidEnd: touch)
        }
    }
    
}
