//
//  SEDetailInfoValueViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/21.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEDetailInfoValueViewController: UIViewController,UITextFieldDelegate {
    
    var unitId: String? //所属detail id
    
    var currentValueType: SECommon.ValueType? //数值类型
    
    var hasChanged:Bool = false {
        didSet {
            let rightView = SETool.findRightBarItemView(self.navigationController!.navigationBar)
            guard rightView != nil else {
                return
            }
            if self.hasChanged {
                rightView!.isHidden = false
            } else {
                rightView!.isHidden = true
            }
        }
    } //标记数据是否变化
    
    var loadingView: SELoadingView?

    var valueModel: SETempValue? //外部传进来的数据

    @IBOutlet var valueNameLabel: UITextField!  //数值名
    
    @IBOutlet var valueView: UIView!    //数值展示view
    
    @IBOutlet var typeNameLabel: UILabel!  //数值类型名
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置数值名的输入键盘
        self.valueNameLabel.returnKeyType = UIReturnKeyType.done
        self.valueNameLabel.delegate = self
        
        self.valueNameLabel.text = valueModel?.name
        
        self.title = "数据"
        
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //转换类型名
        self.typeNameLabel.text = SETool.valueTypeStrWithType(SECommon.ValueType(rawValue: valueModel!.valueType)!)
        
        self.initValueView()
    }

    //初始化数值展示及编辑的view
    func initValueView() {
        //如果本次展示的类型和之前旧有的不是同一种类型需要将之前的移除掉
        let oldValueView = self.view.viewWithTag(16092601)
        if oldValueView != nil {
            if valueModel?.valueType != currentValueType?.rawValue {
                oldValueView?.removeFromSuperview()
            }
        }
        //获取当前数值类型
        currentValueType = SECommon.ValueType(rawValue: valueModel!.valueType)
        let view = self.getValueView()
        view.frame = CGRect(origin:CGPoint(x:0,y:0),size: self.valueView.frame.size)
        self.valueView.addSubview(view)
    }
    
    //获取数值展示view
    func getValueView() -> UIView {
        var tempStr: String = "SEBasicStrValueView"

        var tempView:UIView = UIView()
        var setMethod: Selector = #selector(setBasicStrView(basicStrView:))
        let tempType = SECommon.ValueType(rawValue: valueModel!.valueType)
        switch tempType! {
        case SECommon.ValueType.basicStr,SECommon.ValueType.number:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.time:
            tempStr = "SETimeValueView"
            setMethod = #selector(setTimeValueView(timeValueView:))
        case SECommon.ValueType.picture:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.audio:
            tempStr = "SEBasicStrValueView"
            setMethod = #selector(setBasicStrView(basicStrView:))
        case SECommon.ValueType.video:
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
                    if self.valueModel?.value != textView.text {
                        self.hasChanged = true
                        self.valueModel?.value = textView.text
                    }
                    
                }
            })
        }
        
        if valueModel!.value.characters.count > 0 {
            tempView.valueStr = valueModel!.value
        } else {
            tempView.valueStr = tempView.placeHolder
        }
        tempView.refreshKeyBoardType()
    }
    
    func setTimeValueView(timeValueView:UIView) {
        let tempView = timeValueView as! SETimeValueView
        if valueModel!.value.characters.count > 0 {
            tempView.date = SETool.dateWithStorageStr(valueModel!.value)
        } else {
            tempView.date = Date()
        }
        tempView.didEndEditingCallBack = {
            [unowned self] (dic:[String:Any]) in
            let date = dic["date"] as! Date
            let str = SETool.timeStorageStrWithDate(date)
            if self.valueModel!.value != str {
                self.hasChanged = true
            }
            self.valueModel!.value = str
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        back()
    }
    
    func back() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        SETool.resignAllFirstResponder()
        loadingView?.showWhileExecutingClosure(executingClosure: {

            self.hasChanged = false
        },
        completion: {
            self.back()
        })
    }
    
    @IBAction func chooseValueTypeAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.DetailInfoToChooseType, sender: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != valueModel!.name {
            hasChanged = true
            valueModel!.name = textField.text ?? ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            valueModel!.name = textField.text ?? ""
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.DetailInfoToChooseType:
            let ctr = segue.destination as! SEInfoValueTypeViewController

            ctr.selectIndexRow = valueModel!.valueType
            ctr.chooseTypeCallBack = {
                [unowned self]
                (valueType: SECommon.ValueType) -> ()  in
                self.valueModel!.valueType = valueType.rawValue
            }
        default:
            break
        }
    }
}
