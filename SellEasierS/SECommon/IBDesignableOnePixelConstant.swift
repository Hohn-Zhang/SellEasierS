//
//  IBDesignableOnePixelConstant.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class IBDesignableOnePixelConstant: NSLayoutConstraint {
    @IBInspectable var onePixelConstant : CGFloat = 0 {
        didSet {
            self.constant = onePixelConstant * 1.0 / UIScreen.main.scale
        }
    }
}
