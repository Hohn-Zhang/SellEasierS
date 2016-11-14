//
//  SETemplateDetailInfoViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/29.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SETemplateDetailInfoViewController : UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var chooseTypeBtn: UIButton!
    
    var templateValue: SETempTemplateValue?
    
    var saveDataCallBack:((_ data: SETempTemplateValue) -> ())?
    
    var currentValueType: SECommon.ValueType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = templateValue?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentValueType = SECommon.ValueType(rawValue: templateValue!.valueType.intValue)
        chooseTypeBtn.setTitle(SETool.valueTypeStrWithType(currentValueType ?? SECommon.ValueType.basicStr), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func saveAction(_ sender: AnyObject) {
        templateValue?.name = nameTextField.text!
        templateValue?.valueType = NSNumber(value:SETool.valueTypeWithValueTypeStr(str: chooseTypeBtn.title(for: UIControlState.normal)!).rawValue)
        if saveDataCallBack != nil && templateValue != nil {
            saveDataCallBack!(templateValue!)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func chooseTypeAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.NewTemplateToChooseType, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.NewTemplateToChooseType:
            let vc = segue.destination as! SEInfoValueTypeViewController
            vc.chooseTypeCallBack = {
                [unowned self]
                (valueType: SECommon.ValueType) -> ()  in
                self.templateValue?.valueType = NSNumber(value:valueType.rawValue)
            }
        default:
            return
        }
    }
}
