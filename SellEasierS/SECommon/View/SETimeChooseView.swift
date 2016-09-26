//
//  SETimeChooseView.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SETimeChooseView: UIView {
    @IBOutlet var baseView: UIView!

    @IBOutlet var datePickerView: UIDatePicker!
    
    var finishChooseCallBack:((Date)->())?
    var originalDate: Date?
    override func awakeFromNib() {
        self.frame = SECommon.Macro.screenFrame
        self.tag = 16080501
        baseView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.baseView.frame.size.height)
        datePickerView.datePickerMode = UIDatePickerMode.date
    }
    
    func show() {
        if originalDate != nil {
            datePickerView.date = originalDate!;
        }
        UIView.animate(withDuration: 0.3) { 
            self.baseView.frame = CGRect(x: 0, y: self.frame.size.height - self.baseView.frame.size.height, width: self.frame.size.width, height: self.baseView.frame.size.height)
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3) { 
            self.baseView.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.baseView.frame.size.height)
        }

        if self.isFirstResponder {
            self.resignFirstResponder()
        }
        self.perform(#selector(removeFromSuperview), with: nil, afterDelay: 0.3)
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        if finishChooseCallBack != nil {
            finishChooseCallBack!(datePickerView.date)
        }
        dismiss()
    }
}
