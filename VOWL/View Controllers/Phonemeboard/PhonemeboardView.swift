//
//  PhonemeboardView.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol PhonemeboardViewDelegate {
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchBegan touch: UITouch)
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchMoved touch: UITouch)
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchEnded touch: UITouch)
}

class PhonemeboardView: UIControl {
    
    var delegate: PhonemeboardViewDelegate?
    
    // MARK: Events
    
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
    
    // MARK: Touches
    
    func updateTouches(touches: Set<UITouch>) {
        touches.forEach { (touch) -> () in
            switch touch.phase {
            case .Began:
                self.delegate?.phonemeboardView(self, touchBegan: touch)
            case .Moved:
                self.delegate?.phonemeboardView(self, touchMoved: touch)
            case .Stationary:
                self.delegate?.phonemeboardView(self, touchMoved: touch)
            case .Cancelled:
                self.delegate?.phonemeboardView(self, touchEnded: touch)
            case .Ended:
                self.delegate?.phonemeboardView(self, touchEnded: touch)
            default:
                break
            }
        }
    }

}
