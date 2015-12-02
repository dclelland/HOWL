//
//  FlipViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 2/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import SnapKit

class FlipViewController: UIViewController {
    
    @IBOutlet var frontView: UIView?
    @IBOutlet var backView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView?.removeFromSuperview()
    }
    
    func flip() {
        guard let frontView = frontView, let backView = backView, let state = state else {
            return
        }
        
        switch state {
        case .PresentingFrontView:
            self.flip(fromView: frontView, toView: backView, options: [.TransitionFlipFromLeft])
        case .PresentingBackView:
            self.flip(fromView: backView, toView: frontView, options: [.TransitionFlipFromRight])
        }
    }
    
    private func flip(fromView fromView: UIView, toView: UIView, options: UIViewAnimationOptions) {
        view.addSubview(toView)
        
        toView.snp_makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: options, completion: nil)
    }
    
    // MARK: - State
    
    enum State {
        case PresentingFrontView
        case PresentingBackView
    }
    
    var state: State? {
        if frontView?.superview != nil {
            return .PresentingFrontView
        }
        
        if backView?.superview != nil {
            return .PresentingBackView
        }
        
        return nil
    }

}

extension UIViewController {
    var flipViewController: FlipViewController? {
        if let flipViewController = self.parentViewController as? FlipViewController {
            return flipViewController
        }
        return nil
    }
}