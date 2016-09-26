//
//  SEBasicStrValueView.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEBasicStrValueView: UIView, UITextViewDelegate {
    
    @IBOutlet var valueTextView: UITextView!
    
    var isNumValue: Bool = false
    
    var keyBoardHeight: CGFloat = 0.0
    
    var didBeginEditingCallBack: ((_ dic:[String:Any]) -> ())?
    
    var didEndEditingCallBack: ((_ dic:[String:Any]) -> ())?
    
    var valueStr: String {
        get{
            return valueTextView.text
        }
        set{
            valueTextView.text = newValue
        }
    }
    
    var placeHolder: String {
        get{
            return isNumValue ? "点击输入数值" : "点击输入内容"
        }
    }
    
    override func awakeFromNib() {
        valueTextView.delegate = self
        valueTextView.returnKeyType = UIReturnKeyType.done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        refreshKeyBoardType()
    }
    
    @objc func keyboardWillShow(aNotification:Notification) {
        let userInfo = aNotification.userInfo
        
        let value: NSValue? = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        if value != nil {
            keyBoardHeight = value!.cgRectValue.size.height
        }
    }
    
    func refreshKeyBoardType() {
        if isNumValue {
            valueTextView.keyboardType = UIKeyboardType.decimalPad
            let topView = numTypeTopView()
            valueTextView.inputAccessoryView = topView
        } else {
            valueTextView.keyboardType = UIKeyboardType.default
            valueTextView.inputAccessoryView = nil
        }
    }
    
    @objc func dismissKeyBoard() {
        valueTextView.resignFirstResponder()
    }
    
    func numTypeTopView() -> UIView {
        let topView = UIToolbar(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: SECommon.Macro.screenWidth, height: 44)))
        topView.barStyle = UIBarStyle.default
        
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyBoard))
        
        topView.setItems([btnSpace,doneBtn], animated: false)
        return topView
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if valueTextView.text == placeHolder {
            valueTextView.text = ""
        }
        if didBeginEditingCallBack != nil {
            didBeginEditingCallBack!(["textView":textView,"keyBoardHeight":keyBoardHeight])
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = placeHolder
        }
        keyBoardHeight = 0
        if didEndEditingCallBack != nil {
            didEndEditingCallBack!(["textView":textView])
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
