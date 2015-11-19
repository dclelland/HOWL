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
        
        let hue: CGFloat = 0.125
        let cornerRadius: CGFloat = 2.0
        
        self.backgroundColor = UIColor.clearColor()
        
        self.setTitleColor(UIColor.vowl_blackColor(), forState: .Normal)
        
        self.setBackgroundImage(UIImage.image(withColor: UIColor.vowl_darkColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Normal)
        self.setBackgroundImage(UIImage.image(withColor: UIColor.vowl_mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Highlighted)
        self.setBackgroundImage(UIImage.image(withColor: UIColor.vowl_mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: [.Highlighted, .Selected])
        self.setBackgroundImage(UIImage.image(withColor: UIColor.vowl_lightColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Selected)
    }

}
