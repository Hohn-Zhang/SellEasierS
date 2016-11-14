//
//  SETemplateListViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SETemplateListViewController: UIViewController{
    
    var isAddTemplate = false
    
    var selectTemplateModel: SEManagedObject?
    
    var detailType: SECommon.DetailType = SECommon.DetailType.company
    
//    let templateDataManager: SEDetailTemplateDataManager = SEDetailTemplateDataManager()

    var templateModels: [SEManagedObject]?
    
    var chooseTemplateDoneCallBack: ((_ model: SEManagedObject) -> ())?
    
//    let listViewManager = SEDetailTemplateListViewManager()
    
    let tableViewManager = SETableViewManager ()

    var loadingView: SELoadingView?
    
    @IBOutlet var templateListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView?.showWhileExecutingClosure(executingClosure: {
            [unowned self] in
            var entityName = ""
            switch self.detailType {
            case SECommon.DetailType.company:
                entityName = SECompanyTemplate.entityName
            case SECommon.DetailType.product:
                entityName = SEProductTemplate.entityName
            case SECommon.DetailType.seller:
                entityName = SESellerTemplate.entityName
            }
            self.templateModels = SEDataBaseManager.sharedInstance.fetchObject(entityName: entityName, predicate: nil, sortDescriptions: SEDataBaseManager.defaultSortDescriptors, startIndex: 0, pageSize: 20) as! [SEManagedObject]?
            self.tableViewManager.datas = self.templateModels ?? []
        },
        completion: {
            [unowned self] in
            self.templateListView.reloadData()
        })
    }
    
    func initSubView() {
        
        tableViewManager.didSelectRow = {
            [unowned self] (index:IndexPath)->() in
            if self.chooseTemplateDoneCallBack != nil {
                if self.templateModels != nil && index.row < self.templateModels!.count {
                    self.chooseTemplateDoneCallBack!(self.templateModels![index.row])
                    self.navigationController!.popViewController(animated: true)
                }
            }
        }
        
        tableViewManager.cellClassName = "SEDetailTemplateCell"
        
        tableViewManager.configCellCallBack = {
            (cell: UITableViewCell,item:Any) -> () in
            let tempCell = cell as? SEDetailTemplateCell
            let dataModel = item as? SEManagedObject
            guard tempCell != nil && dataModel != nil else {
                return
            }
            if dataModel?.name == nil || dataModel!.name.characters.count == 0 {
                tempCell!.nameLabel.text = "暂无名称"
            } else {
                tempCell!.nameLabel.text = dataModel!.name
            }
        }
       
        templateListView.delegate = tableViewManager
        templateListView.dataSource = tableViewManager
        let ges: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(TableviewCellLongPressed))
        templateListView.addGestureRecognizer(ges)
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //长按事件的手势监听实现方法
    func TableviewCellLongPressed(gestureRecognizer: UILongPressGestureRecognizer) -> () {
        
        // 取得选中的行
        if gestureRecognizer.state ==  UIGestureRecognizerState.ended {
            let point = gestureRecognizer.location(in: templateListView)
            let indexPath = templateListView.indexPathForRow(at: point)
            if (indexPath == nil) {
                return
            } else {
                isAddTemplate = false
                if templateModels != nil && indexPath!.row < templateModels!.count {
                    selectTemplateModel = templateModels![indexPath!.row]
                }
                
                self.performSegue(withIdentifier: SECommon.SegueName.TemplateListToNewTemplate, sender: self)
            }
        }
    }
    
    @IBAction func addNewTemplateAction(_ sender: AnyObject) {
        isAddTemplate = true
        self.performSegue(withIdentifier: SECommon.SegueName.TemplateListToNewTemplate, sender: self)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.TemplateListToNewTemplate:
            let vc = segue.destination as! SETemplateDetailViewController
            if !isAddTemplate && selectTemplateModel != nil {
                vc.templateModel = selectTemplateModel!
            }
            vc.detailType = self.detailType
        default:
            return
        }
    }
}
