//
//  HoldButton.swift
//  HOWL
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
        
        backgroundColor = UIColor.clearColor()
        
        setTitleColor(UIColor.HOWL.blackColor(), forState: .Normal)
        
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.darkColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Normal)
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Highlighted)
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: [.Highlighted, .Selected])
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.lightColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Selected)
    }

}
