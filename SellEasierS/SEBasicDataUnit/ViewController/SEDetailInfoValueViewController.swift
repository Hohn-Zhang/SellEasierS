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
    
    //跳转进来时必须赋值
    var valueModel: SEDetailInfoValueModel?
    
    @IBOutlet var valueNameLabel: UITextField!
    
    @IBOutlet var valueView: UIView!
    
    @IBOutlet var typeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.valueNameLabel.returnKeyType = UIReturnKeyType.done
        self.valueNameLabel.delegate = self
        
        self.valueNameLabel.text = valueModel!.valueName
        self.title = "数据"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.typeNameLabel.text = SETool.valueTypeStrWithType(SECommon.ValueType(rawValue: valueModel!.valueType.intValue)!)
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
