//
//  SEDetailViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SEDetailViewController: UIViewController {
    
    open var isNew:Bool = true
    
    open var detailInfoModel: SEDetailInfoModel?
    
    open var detailType:SECommon.DetailType?
    
    let listViewManager: SEDetailListViewManager = SEDetailListViewManager()
    
    var loadingView: SELoadingView?
    //模版label
    @IBOutlet var templateNameLabel: UILabel!
    
    @IBOutlet var chooseTemplateBtn: UIButton!
    
    @IBOutlet var templateNameTextField: UITextField!
    
    
    @IBOutlet var detailListView: UITableView!
    
    @IBOutlet var addInfoBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ctrTitle()
        initSubView()
    }
    
    func ctrTitle() -> String {
        switch detailType! {
        case SECommon.DetailType.company:
            return isNew ? "添加单位" : "单位详情"
        case SECommon.DetailType.seller:
            return isNew ? "添加负责人" : "负责人详情"
        case SECommon.DetailType.product:
            return isNew ? "添加产品" : "产品详情"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //如果是已有数据则不允许修改模版
        self.templateNameLabel.isHidden = !isNew
        self.templateNameTextField.isHidden = !isNew
        self.chooseTemplateBtn.isHidden = !isNew
        
        loadingView!.showWhileExecutingClosure(
            executingClosure:{
            [unowned self] in
                self.listViewManager.data.removeAll()
                if self.isNew {
                    self.detailInfoModel = SEDetailInfoModel()
                    
                }
                if self.detailInfoModel != nil {
                    self.listViewManager.unitId = self.detailInfoModel!.unitId
                    self.listViewManager.loadDatas()
                }
            }
            ,completion:{
                [unowned self] in
                self.refreshSubView()
            })
    }
    
    fileprivate func initSubView() {
        
        detailListView.delegate = listViewManager
        detailListView.dataSource = listViewManager
        
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    func refreshSubView() {
        if isNew && listViewManager.detailTemplateModel != nil {
            templateNameTextField.text = listViewManager.detailTemplateModel?.templateName
        }
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
            print("")
        case SECommon.SegueName.DetailToDetailInfo:
            var valueModel: SEDetailInfoValueModel
            if isNew {
                valueModel = SEDetailInfoValueModel(name: "", unitId: detailInfoModel!.unitId, sortOrder:listViewManager.data.count, valueType: 0)
            } else {
//              TODO????
                valueModel = SEDetailInfoValueModel(name: "", unitId: detailInfoModel!.unitId, sortOrder:listViewManager.data.count, valueType: 0)
            }
            segue.destination .setValue(valueModel, forKey: "valueModel")
        default:
            print("")
        }
    }
}
