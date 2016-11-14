//
//  SEDetailViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEDetailViewController: UIViewController {

    
    open var isNew: Bool = true  //是否是新建数据
    
    open var detailInfoModel: SEManagedObject?    //数据model

    

    private var tempName: String = ""
    private var tempValues: [SETempValue] = []
    
    open var detailType:SECommon.DetailType = SECommon.DetailType.product   //数据类型
    
    var currentTemplateModel: SEManagedObject? {
        willSet{
            if currentTemplateModel != nil {
                templateHasChanged = newValue != currentTemplateModel
            }
        }
    }
    
    var templateHasChanged: Bool = false
    
    let tableViewManager: SETableViewManager = SETableViewManager()
    
//    let infoValueDataManager: SEDetaiValueDataManager = SEDetaiValueDataManager()

//    let templateDataManager: SEDetailTemplateDataManager = SEDetailTemplateDataManager()
    
    
    fileprivate var selectInfoValueModel: SETempValue?   //选中的数据详情
    
    var loadingView: SELoadingView? //加载动画view
    //模版label
    @IBOutlet fileprivate var templateNameLabel: UILabel!   //“模版”label
    
    @IBOutlet fileprivate var chooseTemplateBtn: UIButton!  //选择模版按钮
    
    @IBOutlet fileprivate var templateNameTextField: UITextField!   //模版名称显示框
    
    @IBOutlet fileprivate var detailListView: UITableView!  //数据列表
    
    @IBOutlet fileprivate var addInfoBtn: UIButton!     //添加新数据的按钮
    
    fileprivate var ctrTitle: String {
        get{
            switch detailType {
            case SECommon.DetailType.company:
                return isNew ? "添加单位" : tempName
            case SECommon.DetailType.seller:
                return isNew ? "添加负责人" : tempName
            case SECommon.DetailType.product:
                return isNew ? "添加产品" : tempName
            }
        }
    }       //控制器的标题
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()

        self.title = ctrTitle

        initSubView()

        if self.isNew {
            loadingView!.showWhileExecutingClosure(
                executingClosure:{
                    if self.isNew {
                        if self.currentTemplateModel == nil {
                            var templateEntityName = ""
                            switch self.detailType {
                            case SECommon.DetailType.company:
                                templateEntityName = SECompanyTemplate.entityName
                            case SECommon.DetailType.seller:
                                templateEntityName = SESellerTemplate.entityName
                            case SECommon.DetailType.product:
                                templateEntityName = SEProductTemplate.entityName
                            }
                            let templateDatas = SEDataBaseManager.sharedInstance.fetchObject(entityName: templateEntityName, predicate: nil, sortDescriptions: nil, startIndex: 0, pageSize: 1)

                            if templateDatas != nil && templateDatas!.count > 0 {
                                self.currentTemplateModel = templateDatas!.first as! SEManagedObject?
                            }
                        }
                        self.initDataByTemplate()
                    }

            }
                ,completion:{
                    self.refreshTemplateViews()
            })
        }

    }

    func initData() {
        if detailInfoModel != nil {
            tempName = detailInfoModel!.name
            var values: Set<SEValue>?
            switch detailType {
            case SECommon.DetailType.company:
                values = (detailInfoModel as! SECompany).values
            case SECommon.DetailType.seller:
                values = (detailInfoModel as! SESeller).values
            case SECommon.DetailType.product:
                values = (detailInfoModel as! SEProduct).values
            }
            if values != nil && values!.count > 0 {
                for value in values! {
                    var tempValue = SETempValue()
                    tempValue.name = value.name
                    tempValue.value = value.value
                    tempValue.valueType = value.valueType.intValue
                    tempValue.updateTime = value.updateTime
                    tempValue.sort = tempValues.count > 0 ? tempValues.count - 1 : 0
                    tempValues.append(tempValue)
                }
                tempValues.sort(by: { (value1: SETempValue, value2: SETempValue) -> Bool in
                    return value1.sort >= value2.sort
                })
            }
        }
    }

    func initDataByTemplate() {
        if currentTemplateModel != nil {
            tempValues.removeAll()
            var values: Set<SETemplateValue>?
            switch detailType {
            case SECommon.DetailType.company:
                values = (currentTemplateModel as! SECompanyTemplate).values
            case SECommon.DetailType.seller:
                values = (currentTemplateModel as! SESellerTemplate).values
            case SECommon.DetailType.product:
                values = (currentTemplateModel as! SEProductTemplate).values
            }
            if values != nil && values!.count > 0 {
                for value in values! {
                    var tempValue = SETempValue()
                    tempValue.name = value.name
                    tempValue.value = ""
                    tempValue.valueType = SECommon.ValueType.basicStr.rawValue
                    tempValue.updateTime = Date()
                    tempValue.sort = tempValues.count > 0 ? tempValues.count - 1 : 0
                    tempValues.append(tempValue)
                }
                tempValues.sort(by: { (value1: SETempValue, value2: SETempValue) -> Bool in
                    return value1.sort >= value2.sort
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if templateHasChanged {
            refreshTemplateViews()
            templateHasChanged = false
        }
    }
    
    //刷新模版相关的views
    fileprivate func refreshTemplateViews() {
        //如果是已有数据则不允许修改模版
        self.templateNameLabel.isHidden = !isNew
        self.templateNameTextField.isHidden = !isNew
        self.chooseTemplateBtn.isHidden = !isNew
        if isNew && currentTemplateModel != nil {
            templateNameTextField.text = currentTemplateModel!.name
        }
    }
    
    //初始化子控件及数据
    fileprivate func initSubView() {
        
        tableViewManager.didSelectRow = {
            [unowned self] (index:IndexPath)->() in
            if index.row < self.tempValues.count {
                self.selectInfoValueModel = self.tempValues[index.row]
            }
            self.performSegue(withIdentifier: SECommon.SegueName.DetailToDetailInfo, sender: self)
        }
        tableViewManager.cellClassName = "SEDetailTableViewCell"
        
        tableViewManager.configCellCallBack = {
            (cell: UITableViewCell,item:Any) -> () in
            let tempCell = cell as? SEDetailTableViewCell
            let value = item as? SETempValue
            if tempCell != nil && value != nil {
                tempCell!.nameLabel.text = value?.name
                tempCell!.infoLabel.text = value?.value
            }
        }
        
        detailListView.delegate = tableViewManager
        detailListView.dataSource = tableViewManager
        
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
    }
    
    @IBAction func chooseTemplateAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.DetailToTemplate, sender: self)
    }
    
    @IBAction func addNewDataAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SECommon.SegueName.DetailToDetailInfo, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.DetailToTemplate:
            let vc = segue.destination as! SETemplateListViewController
            vc.detailType = detailType
            if currentTemplateModel != nil {
                vc.selectTemplateModel = currentTemplateModel
            }
            vc.chooseTemplateDoneCallBack = {
                [unowned self]
                (model: SEManagedObject) -> () in
                self.currentTemplateModel = model
            }
        case SECommon.SegueName.DetailToDetailInfo:
            var valueModel: SETempValue
            if selectInfoValueModel == nil {

            } else {
                valueModel = self.selectInfoValueModel!
                self.selectInfoValueModel = nil
            }
//            segue.destination.setValue(valueModel, forKey: "valueModel")
        default:
            print("")
        }
    }
}
