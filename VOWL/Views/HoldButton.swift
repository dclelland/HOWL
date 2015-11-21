//
//  HoldButton.swift
//  VOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class HoldButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let hue: CGFloat = 0.25
        let cornerRadius: CGFloat = 3.0
        
        self.backgroundColor = UIColor.clearColor()
        
        self.setTitleColor(UIColor.VOWL.blackColor(), forState: .Normal)
        
        self.setBackgroundImage(UIImage.image(withColor: UIColor.VOWL.darkColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Normal)
        self.setBackgroundImage(UIImage.image(withColor: UIColor.VOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Highlighted)
        self.setBackgroundImage(UIImage.image(withColor: UIColor.VOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: [.Highlighted, .Selected])
        self.setBackgroundImage(UIImage.image(withColor: UIColor.VOWL.lightColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Selected)
    }

}
