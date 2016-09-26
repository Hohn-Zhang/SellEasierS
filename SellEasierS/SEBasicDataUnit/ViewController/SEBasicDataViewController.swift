//
//  SEBasicDataViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SEBasicDataViewController: UIViewController {
    
    var listViewManager : SEBasicDataListViewManager = SEBasicDataListViewManager()
    
    @IBOutlet var dataTypeSegment: UISegmentedControl!
    
    @IBOutlet var dataListView: UITableView!
    
    @IBOutlet var editBtn: UIButton!
    
    @IBOutlet var checkAllBtn: UIButton!
    
    @IBOutlet var deleteBtn: UIButton!
    
    @IBOutlet var addNewDataBtn: UIButton!
    
    @IBOutlet var noDataLabel: UILabel!
    
    var loadingView: SELoadingView?
    
    var isAddDetailInfo: Bool = true
    
    var selectDetailInfoModel: SEDetailInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        processBtns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        loadingView!.showWhileExecutingClosure(executingClosure:{
            [unowned self] in
            self.listViewManager.loadDatas()
            }
            ,completion:{
                [unowned self] in
                self.refreshListView()
            })
    }
    
    
    fileprivate func initSubView() {
        self.navigationController?.navigationBar.topItem?.title = ctrTitle()
        
        listViewManager.didSelectRow = {
            (index:IndexPath)->() in
            if self.listViewManager.data.count > index.row {
                self.selectDetailInfoModel = self.listViewManager.data[index.row] as? SEDetailInfoModel
            }
        }
        
        dataListView.delegate = listViewManager
        dataListView.dataSource = listViewManager
        listViewManager.detaiInfolType = detaiType()
        
        loadingView = SELoadingView(frame: CGRect(origin: CGPoint(x:self.view.center.x-30,y:self.view.center.y-30), size: CGSize(width: 60, height: 60)), color: UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0), size: CGSize(width: 60, height: 60))
        self.view.addSubview(loadingView!)
    }
    
    func refreshListView() {
        if listViewManager.data.count > 0{
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
    }
    
    @IBAction func checkAllBtnAction(_ sender: AnyObject) {
    }
    
    @IBAction func editBtnAction(_ sender: AnyObject) {
        dataListView.isEditing = !dataListView.isEditing
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
        listViewManager.detaiInfolType = detaiType()
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
