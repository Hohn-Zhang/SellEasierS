//
//  SEBasicDataViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEBasicDataViewController: UIViewController {
    
    let dataManager: SEBasicDataManager = SEBasicDataManager()
    
    let tableViewManager: SETableViewManager = SETableViewManager()
    
    @IBOutlet var dataTypeSegment: UISegmentedControl!
    
    @IBOutlet var dataListView: UITableView!
    
    @IBOutlet var editBtn: UIButton!
    
    @IBOutlet var checkAllBtn: UIButton!
    
    @IBOutlet var deleteBtn: UIButton!
    
    @IBOutlet var addNewDataBtn: UIButton!
    
    @IBOutlet var noDataLabel: UILabel!
    
    var loadingView: SELoadingView?
    
    var isAddDetailInfo: Bool = true
    
    var selectDetailInfoModel: SEManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        processBtns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.detaiInfolType = detaiType()
        loadData()
    }
    
    func loadData() {
        loadingView?.showWhileExecutingClosure(executingClosure: { 
            [unowned self] in
            self.dataManager.loadNextPage()
            if self.dataManager.datas.count > 0 {
                self.tableViewManager.datas = self.dataManager.datas
            }
        }, completion: {
            [unowned self] in
            self.refreshListView()
        })
    }
    
    
    fileprivate func initSubView() {
        
        //title
        self.navigationController?.navigationBar.topItem?.title = ctrTitle()
        
        //table view
        configDataManagerAndTableViewManager()
        
        dataListView.tintColor = UIColor.red
        dataListView.delegate = tableViewManager
        dataListView.dataSource = tableViewManager
        dataListView.allowsMultipleSelectionDuringEditing = true
        
        //loading view
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    fileprivate func configDataManagerAndTableViewManager() {
        tableViewManager.didSelectRow = {
            [unowned self] (index:IndexPath)->() in
            if !self.dataListView.isEditing {
                let datas = self.dataManager.datas
                if datas.count > index.row {
                    self.selectDetailInfoModel = datas[index.row]
                    self.isAddDetailInfo = false
                    self.performSegue(withIdentifier: SECommon.SegueName.DataListToDetail, sender: self)
                }
            } else {
                self.processBtns()
            }
        }
        
        tableViewManager.didDeselectRow = {
            [unowned self] (index:IndexPath)->() in
            if self.dataListView.isEditing && (self.dataListView.indexPathsForSelectedRows == nil || self.dataListView.indexPathsForSelectedRows!.count == 0) {
                self.processBtns()
            }
        }
        
        tableViewManager.cellClassName = "SEDetailTableViewCell"
        
        tableViewManager.configCellCallBack = {
            [unowned self] (cell: UITableViewCell,item:Any) -> () in
            
            let model = item as? SEManagedObject

            var titleStr: String
            switch self.detaiType() {
            case SECommon.DetailType.company,SECommon.DetailType.product:
                titleStr = "名称:"
            case SECommon.DetailType.seller:
                titleStr = "姓名:"
            }

            if cell.isKind(of: SEDetailTableViewCell.self) && model != nil {
                let tempCell = cell as! SEDetailTableViewCell
                tempCell.nameLabel.text = titleStr
                tempCell.infoLabel.text = model?.name
            }
        }
    }
    
    fileprivate func refreshListView() {
        if tableViewManager.datas.count > 0{
            dataListView.isHidden = false
            noDataLabel.isHidden = true
            dataListView.reloadData()
        } else {
            dataListView.isHidden = true
            noDataLabel.isHidden = false
        }
    }
    
    fileprivate func processBtns() {
        if dataListView.isEditing {
            editBtn.setTitle("取消", for: UIControlState())
            checkAllBtn.isHidden = false
            if dataListView.indexPathForSelectedRow != nil {
                deleteBtn.isHidden = false
            } else {
                deleteBtn.isHidden = true
            }
        } else {
            editBtn.setTitle("编辑", for: UIControlState())
            checkAllBtn.isHidden = true
            deleteBtn.isHidden = true
        }
    }
    
    fileprivate func ctrTitle()->String {
        switch dataTypeSegment.selectedSegmentIndex {
        case 0:
            return "单位"
        case 1:
            return "负责人"
        case 2:
            return "产品"
        default:
            return "单位"
        }
    }
    
    fileprivate func detaiType() -> SECommon.DetailType {
        switch dataTypeSegment.selectedSegmentIndex {
        case 0:
            return SECommon.DetailType.company
        case 1:
            return SECommon.DetailType.seller
        case 2:
            return SECommon.DetailType.product
        default:
            return SECommon.DetailType.company
        }
    }
    
    @IBAction func deleteBtnAction(_ sender: AnyObject) {
        if dataListView.isEditing {
            if dataListView.indexPathsForSelectedRows != nil {
                dataListView.beginUpdates()

                var deleteData: [SEManagedObject] = []
                for indexPath in dataListView.indexPathsForSelectedRows! {
                    let model = dataManager.datas[indexPath.row]
                    SEDataBaseManager.sharedInstance.deleteObject(model, complete: nil)
                    deleteData.append(model)
                }
                for model in deleteData {
                    let index = dataManager.datas.index(of: model)
                    if index != nil {
                        dataManager.datas.remove(at: index!)
                    }
                }
                tableViewManager.datas = dataManager.datas
                dataListView.deleteRows(at: dataListView.indexPathsForSelectedRows!, with: UITableViewRowAnimation.fade)
                dataListView.endUpdates()
            }
        }
    }
    
    @IBAction func checkAllBtnAction(_ sender: AnyObject) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        
        let btnTitle = btn.isSelected ? "全不选" : "全选"
        btn.setTitle(btnTitle, for: UIControlState.normal)
       
        let datas = dataManager.datas
        guard datas.count > 0 else {
            return
        }
        
        for i in 0...dataManager.datas.count - 1 {
            let indexPath = IndexPath(row: i, section: 0)
            if btn.isSelected {
                dataListView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            } else {
                dataListView.deselectRow(at: indexPath, animated: false)
            }
        }
        processBtns()
    }
    
    @IBAction func editBtnAction(_ sender: AnyObject) {
        dataListView.isEditing = !dataListView.isEditing
        dataListView.reloadData()
        processBtns()
    }
    
    @IBAction func addNewDataBtnAction(_ sender: AnyObject) {
        isAddDetailInfo = true
        self.performSegue(withIdentifier: SECommon.SegueName.DataListToDetail, sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChanged(_ sender: AnyObject) {
        self.navigationController?.navigationBar.topItem?.title = ctrTitle()
        dataManager.detaiInfolType = detaiType()
        loadData()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SECommon.SegueName.DataListToDetail:
            let ctr = segue.destination as! SEDetailViewController
            ctr.detailType = detaiType()
            ctr.isNew = isAddDetailInfo
            if !isAddDetailInfo && selectDetailInfoModel != nil {
                ctr.detailInfoModel = selectDetailInfoModel
            }
        default:
            break
        }
    }
}
