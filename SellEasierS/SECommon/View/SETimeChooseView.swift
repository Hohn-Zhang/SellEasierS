//
//  SETimeChooseView.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

//class SETimeChooseViewV1: UIView {
//    var originalDate:NSDate!
//    let finishChooseBlock: ((chooseDate:NSDate)->())?
//    @IBOutlet var baseView: UIView!
//    @IBOutlet var timePiker: UIDatePicker!
//    
//    override func awakeFromNib() {
//        self.frame = SECommon.Macro.screenSize
//        self.tag = 16080501
//        baseView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.baseView.frame.size.height)
//        timePiker.datePickerMode = UIDatePickerMode.Date
//    }
//    
//    func show() {
//        if (originalDate != nil) {
//            timePiker.date = originalDate;
//        }
//        UIView.animateWithDuration(0.3) { 
//            baseView.frame = CGRectMake(0, self.frame.size.height - baseView.frame.size.height, self.frame.size.width, self.baseView.frame.size.height)
//        }
//    }
//    
//    func dismiss() {
//        UIView.animateWithDuration(0.3) { 
//            baseView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.baseView.frame.size.height)
//        }
//        
//        if self.isFirstResponder() {
//            self.resignFirstResponder()
//        }
//        self.performSelector(#selector(removeFromSuperview), withObject: nil, afterDelay: 0.3)
//    }
//    
//    @IBAction func doneAction(sender: AnyObject) {
//        if (finishChooseBlock != nil) {
//            finishChooseBlock(timePiker.date)
//        }
//        dismiss()
//    }
//    @IBAction func cancelAction(sender: AnyObject) {
//        dismiss()
//    }
//}
