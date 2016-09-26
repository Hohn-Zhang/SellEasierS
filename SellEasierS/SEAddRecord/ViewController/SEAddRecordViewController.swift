//
//  SEAddRecordViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEAddRecordViewController: UIViewController {
    
    @IBOutlet var addSellNoteBtn: UIButton!
    
    @IBOutlet var editStockBtn: UIButton!
    @IBOutlet var addMemoBtn: UIButton!
    
    @IBOutlet var listView: UITableView!
    
    @IBOutlet var companyView: UICollectionView!
    
    @IBOutlet var showAllBtn: UIButton!
    
    @IBOutlet var noDataLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
