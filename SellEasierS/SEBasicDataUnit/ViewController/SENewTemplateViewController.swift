//
//  SENewTemplateViewController.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SENewTemplateViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var addTemplateDetailBtn: UIButton!
    @IBOutlet var templateDetailList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func saveAction(_ sender: AnyObject) {
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
