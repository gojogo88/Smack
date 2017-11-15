//
//  CIrcleImage.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/04.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

@IBDesignable
class CIrcleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

}
