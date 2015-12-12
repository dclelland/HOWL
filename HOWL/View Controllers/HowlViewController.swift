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
    
    // MARK: - View controllers
    
    var leftViewController: FlipViewController? {
        if let leftViewControllerView = leftView?.subviews.first {
            return childViewControllers.filter { $0.view == leftViewControllerView }.first as? FlipViewController
        }
        
        return nil
    }
    
    var rightViewController: FlipViewController? {
        if let rightViewControllerView = rightView?.subviews.first {
            return childViewControllers.filter { $0.view == rightViewControllerView }.first as? FlipViewController
        }
        
        return nil
    }

}

extension UIViewController {
    
    var howlViewController: HowlViewController? {
        return self.parentViewController as? HowlViewController
    }
    
}
