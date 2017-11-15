//
//  EditProfileVC.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/06.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    //Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    func setupView() {
        userNameTextField.text = UserDataService.instance.name
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let name = userNameTextField.text , userNameTextField.text != "" else { return }
        
        AuthService.instance.editUserName(name: name) { (success) in
            if success {
                self.performSegue(withIdentifier: UNWIND, sender: nil)
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
