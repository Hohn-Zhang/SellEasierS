//
//  File.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SETableViewManager : NSObject,UITableViewDelegate,UITableViewDataSource{
    
    //数据数组
    var datas : [Any] = []
    
    //cell选中处理
    var didSelectRow: ((_ index:IndexPath)->())? = nil
    
    //cell取消选中处理
    var didDeselectRow: ((_ index:IndexPath)->())? = nil
    
    //cell绘制处理
    var configCellCallBack: ((_ cell: UITableViewCell,_ item: Any?)->())? = nil
    
    //cell的class name
    var cellClassName: String = "UITableViewCell"
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectBlock = self.didSelectRow {
            selectBlock(indexPath)
        }
    }
    
    @objc func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let deselectBlock = self.didDeselectRow {
            deselectBlock(indexPath)
        }
    }
    
    func itemAtIndex(indexPath: IndexPath) -> Any? {
        if self.datas.count > 0 && self.datas.count > indexPath.row{
            return self.datas[indexPath.row]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.datas.count > 0 {
            return datas.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellStr = "cell";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellStr)
        if cell == nil {
            let nibViews = Bundle.main.loadNibNamed(cellClassName, owner: nil, options: nil)
            if let view = nibViews?.first as? UITableViewCell {
                cell = view
            } else {
                cell = UITableViewCell()
            }
        }
        
        if configCellCallBack != nil {
            self.configCellCallBack!(cell!, itemAtIndex(indexPath: indexPath))
        }
        return cell!
    }
}
