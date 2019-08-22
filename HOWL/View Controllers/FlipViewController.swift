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
        case .presentingFrontView:
            flip(fromView: frontView, toView: backView)
        case .presentingBackView:
            flip(fromView: backView, toView: frontView)
        }
    }
    
    private func flip(fromView: UIView, toView: UIView) {
        view.addSubview(toView)
        
        toView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft], completion: nil)
    }
    
    // MARK: - State
    
    enum State {
        case presentingFrontView
        case presentingBackView
    }
    
    var state: State? {
        if frontView?.superview != nil {
            return .presentingFrontView
        }
        
        if backView?.superview != nil {
            return .presentingBackView
        }
        
        return nil
    }
    
    // MARK: - View controllers
    
    var frontViewController: UIViewController? {
        return children.filter { $0.view == frontView?.subviews.first }.first
    }
    
    var backViewController: UIViewController? {
        return children.filter { $0.view == backView?.subviews.first }.first
    }

}

// MARK: - Reverse access

extension UIViewController {
    
    var flipViewController: FlipViewController? {
        return parent as? FlipViewController
    }
    
}
