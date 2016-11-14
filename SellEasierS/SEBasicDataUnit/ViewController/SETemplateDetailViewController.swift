//
//  SETemplateDetailViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SETemplateDetailViewController: UIViewController,UITextFieldDelegate {
    
    var isNew = true

    var detailType: SECommon.DetailType = SECommon.DetailType.company
    
    let tableViewManager: SETableViewManager = SETableViewManager()

    var templateModel: SEManagedObject?

    var tempTemplateValues: [SETempTemplateValue] = []

    var selectTemplateValue: SETempTemplateValue?

    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addTemplateDetailBtn: UIButton!
    @IBOutlet var templateDetailList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = isNew ? "创建模版" : "模版详情"
        initData()
        initSubView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        templateDetailList.reloadData()
    }

    func initData() {
        if templateModel != nil {
            var templateValues: Set<SETemplateValue>?
            switch detailType {
            case SECommon.DetailType.company:
                let model = templateModel as! SECompanyTemplate
                templateValues = model.values
            case SECommon.DetailType.seller:
                let model = templateModel as! SESellerTemplate
                templateValues = model.values
            case SECommon.DetailType.product:
                let model = templateModel as! SEProductTemplate
                templateValues = model.values
            }

            if templateValues != nil && templateValues!.count > 0 {
                tempTemplateValues.removeAll()
                for value in templateValues! {
                    var tempValue: SETempTemplateValue = SETempTemplateValue()
                    tempValue.name = value.name
                    tempValue.valueType = value.valueType
                    tempValue.updateTime = value.updateTime
                    tempTemplateValues.append(tempValue)
                }
            }
        } else if isNew {
            var tempValue: SETempTemplateValue = SETempTemplateValue()
            tempValue.name = "名称:"
            tempValue.valueType = NSNumber(value: SECommon.ValueType.basicStr.rawValue)
            tempValue.updateTime = Date()
            tempTemplateValues.append(tempValue)
        }
    }


    func initSubView() {
        tableViewManager.didSelectRow = {
            [unowned self] (index:IndexPath)->() in
            if self.tempTemplateValues.count > index.row {
                self.selectTemplateValue = self.tempTemplateValues[index.row]
                self.performSegue(withIdentifier: SECommon.SegueName.GoToTemplateDetailInfoVC, sender: self)
            }
        }
        
        tableViewManager.cellClassName = "SEDetailTemplateCell"
        
        tableViewManager.configCellCallBack = {
            (cell: UITableViewCell,item:Any) -> () in
            let tempCell = cell as? SEDetailTemplateCell
            let model = item as? SETempTemplateValue
            guard tempCell != nil && model != nil else {
                return
            }
            
            tempCell?.nameLabel.text = model?.name
            tempCell?.valueTypeLabel.text = SETool.valueTypeStrWithType(SECommon.ValueType(rawValue: model!.valueType.intValue)!)
        }

        templateDetailList.delegate = tableViewManager
        templateDetailList.dataSource = tableViewManager
        
        nameTextField.delegate = self
        if templateModel != nil && templateModel!.name.characters.count > 0 {
            nameTextField.text = templateModel!.name
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func saveAction(_ sender: AnyObject) {

        
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func addDataAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.GoToTemplateDetailInfoVC, sender: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            
            textField.resignFirstResponder()
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SECommon.SegueName.GoToTemplateDetailInfoVC {
            var info: SETempTemplateValue
            if selectTemplateValue == nil { //新加的数据
                info = SETempTemplateValue()
            } else {
                info = selectTemplateValue!
            }
            let vc = segue.destination as! SETemplateDetailInfoViewController
            vc.templateValue = info
            vc.saveDataCallBack = {
                [unowned self]
                (data : SETempTemplateValue) -> () in
                if self.selectTemplateValue == nil {
                    self.tempTemplateValues.append(data)
                }
            }
        }
    }
    
    
}
