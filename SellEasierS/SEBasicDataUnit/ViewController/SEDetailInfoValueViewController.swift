//
//  SEDetailInfoValueViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/21.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEDetailInfoValueViewController: UIViewController,UITextFieldDelegate {
    
    var unitId: String?
    
    var currentValueType: SECommon.ValueType?
    
    var hasChanged:Bool = false
    
    //跳转进来时必须赋值
    var valueModel: SEDetailInfoValueModel?
    
    var tempValueModel: SEDetailInfoValueModel?
    
    @IBOutlet var valueNameLabel: UITextField!
    
    @IBOutlet var valueView: UIView!
    
    @IBOutlet var typeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempValueModel = valueModel
        self.valueNameLabel.returnKeyType = UIReturnKeyType.done
        self.valueNameLabel.delegate = self
        
        self.valueNameLabel.text = valueModel!.valueName
        self.title = "数据"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.typeNameLabel.text = SETool.valueTypeStrWithType(SECommon.ValueType(rawValue: valueModel!.valueType.intValue)!)
        self.initValueView()
    }
    
    func initValueView() {
        let oldValueView = self.view.viewWithTag(16092601)
        if oldValueView != nil {
            if valueModel?.valueType.intValue != currentValueType?.rawValue {
                oldValueView?.removeFromSuperview()
            }
        }
        currentValueType = SECommon.ValueType(rawValue: valueModel!.valueType.intValue)
        let view = self.getValueView()
        view.frame = CGRect(origin:CGPoint(x:0,y:0),size: self.valueView.frame.size)
        self.valueView.addSubview(view)
//        self.view.addSubview(self.valueView)
    }
    
    func getValueView() -> UIView {
        var tempStr: String

        var tempView:UIView = UIView()
        var setMethod: Selector
        switch valueModel!.valueType.intValue {
        case SECommon.ValueType.basicStr.rawValue,SECommon.ValueType.number.rawValue:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.time.rawValue:
            tempStr = "SETimeValueView"
            setMethod = #selector(setTimeValueView(timeValueView:))
        case SECommon.ValueType.picture.rawValue:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.audio.rawValue:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.video.rawValue:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        default:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        }
        let views = Bundle.main.loadNibNamed(tempStr, owner: nil, options: nil)
        tempView = views!.first as! UIView
        self.perform(setMethod, with: tempView)
        return tempView
    }
    
    func setBasicStrView(basicStrView:UIView) {
        let tempView = basicStrView as! SEBasicStrValueView
        tempView.didBeginEditingCallBack = {
            [unowned self] (dic:[String : Any])->() in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(origin: CGPoint(x:self.view.frame.origin.x,y:-tempView.frame.origin.y + 64), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
                
                let keyBoardHeight = dic["keyBoardHeight"] as! CGFloat
                let textView = dic["textView"] as! UITextView
                textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: SECommon.Macro.screenHeight - 64 - keyBoardHeight)
                
            })
        }
        
        tempView.didEndEditingCallBack = {
            [unowned self] (dic:[String : Any])->() in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height)
                let textView = dic["textView"] as! UITextView
                textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: tempView.frame.size.height - 30)
                
                if textView.text.characters.count > 0 && textView.text != tempView.value(forKey: "placeHolder") as? String {
                    if self.tempValueModel?.valueStr != textView.text {
                        self.hasChanged = true
                        self.tempValueModel?.valueStr = textView.text
                    }
                    
                }
            })
        }
        
        if tempValueModel!.valueStr.characters.count > 0 {
            tempView.valueStr = tempValueModel!.valueStr
        } else {
            tempView.valueStr = tempView.placeHolder
        }
        tempView.refreshKeyBoardType()
    }
    
    func setTimeValueView(timeValueView:UIView) {
        let tempView = timeValueView as! SETimeValueView
        if tempValueModel!.valueStr.characters.count > 0 {
            tempView.date = SETool.dateWithStorageStr(tempValueModel!.valueStr)
        } else {
            tempView.date = Date()
        }
        tempView.didEndEditingCallBack = {
            [unowned self] (dic:[String:Any]) in
            let date = dic["date"] as! Date
            let str = SETool.timeStorageStrWithDate(date)
            if self.tempValueModel?.valueStr != str {
                self.hasChanged = true
            }
            self.tempValueModel?.valueStr = str
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        valueModel!.save()
    }
    
    @IBAction func chooseValueTypeAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.DetailInfoToChooseType, sender: self)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            valueModel!.valueName = textField.text ?? ""
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.DetailInfoToChooseType:
            let ctr = segue.destination as! SEInfoValueTypeViewController

            ctr.selectIndexRow = valueModel!.valueType.intValue
            ctr.chooseTypeCallBack = {
                [unowned self]
                (valueType: SECommon.ValueType) -> ()  in
                self.valueModel!.valueType = NSNumber(value: valueType.rawValue)
            }
        default:
            break
        }
    }
}
