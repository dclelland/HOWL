//
//  PhonemeboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class PhonemeboardViewController: UIViewController {
    
    @IBOutlet weak var phonemeboardView: PhonemeboardView?
    
    let phonemeboard = Phonemeboard()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
