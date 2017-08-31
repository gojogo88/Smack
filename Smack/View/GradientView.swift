//
//  GradientView.swift
//  Smack
//
//  Created by Jonathan Go on 2017/08/31.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

@IBDesignable  //so we can see it in storyboard
class GradientView: UIView {

    //s@IBInspectable o we can change dynamically in storyboard
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    //called whenever we change any of the variables (topColor and bottomColor)
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
