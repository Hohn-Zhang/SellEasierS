//
//  SEInfoValueTypeViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SEInfoValueTypeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var valueTypeListView: UITableView!
    
    var selectIndexRow: Int = 0
    
    var chooseTypeCallBack:((_ valueType: SECommon.ValueType) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择类型"
        
        self.valueTypeListView.delegate = self
        self.valueTypeListView.dataSource = self
        
        self.valueTypeListView.selectRow(at: IndexPath(row: selectIndexRow, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        if chooseTypeCallBack != nil {
            chooseTypeCallBack!(SECommon.ValueType(rawValue: selectIndexRow)!)
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //video是ValueType枚举中最后一个元素，它的rawValue则决定着个数
        return SECommon.ValueType.video.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView .cellForRow(at: indexPath) as? SEValueTypeCell
        if cell != nil {
            cell?.checkImageView.isHidden = false
            selectIndexRow = indexPath.row
            backAction(cell!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView .cellForRow(at: indexPath) as? SEValueTypeCell
        if cell != nil {
            cell?.checkImageView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valueTypeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SEValueTypeCell
        if cell == nil {
            let nibViews = Bundle.main.loadNibNamed("SEValueTypeCell", owner: nil, options: nil)
            if let view = nibViews?.first as? SEValueTypeCell{
                cell = view
            }
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell!.checkImageView.isHidden = selectIndexRow != indexPath.row
        cell?.typeLabel.text = SETool.valueTypeStrWithType(SECommon.ValueType(rawValue: indexPath.row)!)
        return cell!
    }
    
}
