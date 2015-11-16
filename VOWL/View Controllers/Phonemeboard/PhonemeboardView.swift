//
//  PhonemeboardView.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol PhonemeboardViewDelegate {
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchDidStart: UITouch)
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchDidUpdate: UITouch)
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchDidEnd: UITouch)
}

class PhonemeboardView: UIControl {
    
    // MARK: Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    // MARK: Touches
    
    

}
