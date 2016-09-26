//
//  File.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SETableViewManager : NSObject,UITableViewDelegate,UITableViewDataSource{
    var data : [NSObject] = []
    var didSelectRow: ((_ index:IndexPath)->())? = nil
    var didDeselectRow: ((_ index:IndexPath)->())? = nil
    
    func loadDatas() {}
    
    func refreshManager() {}
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data.count > 0 {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellStr = "cell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellStr)
        if let cell = cell {
            return cell
        }
        return UITableViewCell();
    }
}
