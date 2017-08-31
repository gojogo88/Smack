//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Jonathan Go on 2017/08/31.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
