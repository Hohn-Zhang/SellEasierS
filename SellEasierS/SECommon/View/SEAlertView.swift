//
//  File.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

//class SEAlertView: UIView,UIAlertViewDelegate {
//    static var block:((isOk:Bool,textField:UITextField)->())?
//    func show(title title:String,message:String,hasTextField:Bool,okTitle:String,cancelTitle:String,showCtr:UIViewController,okOrcancelBlock:((isOk:Bool,textField:UITextField)->())) {
//        block = okOrCancelBlock;
//        if SECommon.Macro.iOS8 {
//            
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyleAlert)
//            if (hasTextField) {
//                // Add the text field for the secure text entry.
//                alertController.addTextFieldWithConfigurationHandler(){
//                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTextFieldTextDidChangeNotification()), name: UITextFieldTextDidChangeNotification, object: textField)
//                }
//            }
//            
//            
//            // Create the actions.
//            if !cancelTitle.isEmpty {
//                let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyleCancel, handler: { (action:UIAlertAction) in
//                    block(false,textField)
//                    NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alertController.textFields.firstObject)
//                })
//                alertController.addAction(cancelAction)
//            }
//            
//            if (okTitle && okTitle.length > 0) {
//                let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyleDefault, handler: { (action:UIAlertAction) in
//                    block(true,textField)
//                    
//                    NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alertController.textFields.firstObject)
//                })
//                alertController.addAction(okAction)
//            }
//            
//            showCtr.presentViewController(alertController, animated: true, completion: nil)
//        } else {
//            let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelTitle, otherButtonTitles: okTitle,nil)
//
//            if (hasTextField) {
//                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//            } else {
//                alertView.alertViewStyle = UIAlertViewStyleDefault;
//            }
//            alertView.show()
//        }
//
//    }
//    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        let isOk = buttonIndex == 0 ? true : false;
////        if (block) {
//            block(isOk,alertView.textFieldAtIndex(0));
////        }
//    }
//    
//    func handleTextFieldTextDidChangeNotification(sender:AnyObject) {
//        
//    }
//}
