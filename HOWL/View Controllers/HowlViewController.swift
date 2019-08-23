//
//  HowlViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 12/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class HowlViewController: UIViewController {
    
    @IBOutlet var leftView: UIView?
    @IBOutlet var rightView: UIView?
    
    @IBOutlet var topLeftView: UIView?
    @IBOutlet var topRightView: UIView?
    @IBOutlet var bottomLeftView: UIView?
    @IBOutlet var bottomRightView: UIView?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        switch traitCollection.horizontalSizeClass {
        case .compact:
            return true
        case .regular:
            return false
        default:
            return false
        }
    }
    
    // MARK: - View controllers
    
    var leftViewController: UIViewController? {
        return children.filter { $0.view == leftView?.subviews.first }.first
    }
    
    var rightViewController: UIViewController? {
        return children.filter { $0.view == rightView?.subviews.first }.first
    }
    
    var topLeftViewController: UIViewController? {
        return children.filter { $0.view == topLeftView?.subviews.first }.first
    }
    
    var topRightViewController: UIViewController? {
        return children.filter { $0.view == topRightView?.subviews.first }.first
    }
    
    var bottomLeftViewController: UIViewController? {
        return children.filter { $0.view == bottomLeftView?.subviews.first }.first
    }
    
    var bottomRightViewController: UIViewController? {
        return children.filter { $0.view == bottomRightView?.subviews.first }.first
    }

}

// MARK: - Reverse access

extension UIViewController {
    
    var howlViewController: HowlViewController? {
        return parent as? HowlViewController
    }
    
}

// MARK: - Howl view controllers

extension HowlViewController {
    
    var phonemeboardViewController: PhonemeboardViewController? {
        if let flipViewController = leftViewController as? FlipViewController {
            return flipViewController.frontViewController as? PhonemeboardViewController
        } else {
            return bottomLeftViewController as? PhonemeboardViewController
        }
    }
    
    var synthesizerViewController: SynthesizerViewController? {
        if let flipViewController = leftViewController as? FlipViewController {
            return flipViewController.backViewController as? SynthesizerViewController
        } else {
            return topRightViewController as? SynthesizerViewController
        }
    }
    
    var keyboardViewController: KeyboardViewController? {
        if let flipViewController = rightViewController as? FlipViewController {
            return flipViewController.frontViewController as? KeyboardViewController
        } else {
            return bottomRightViewController as? KeyboardViewController
        }
    }
    
    var vocoderViewController: VocoderViewController? {
        if let flipViewController = rightViewController as? FlipViewController {
            return flipViewController.backViewController as? VocoderViewController
        } else {
            return topLeftViewController as? VocoderViewController
        }
    }
}
