//
//  SETimeValueView.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SETimeValueView: UIView {
    @IBOutlet var timeLabel: UILabel!
    
    var date: Date? {
        didSet {
            self.timeLabel.text = SETool.timeShowStrWithDate(date)
        }
    }
    var didEndEditingCallBack: ((_ dic:[String:Any]) -> ())?
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeTimeAction))
        self.addGestureRecognizer(tap)
    }
    func changeTimeAction() {
        let views = Bundle.main.loadNibNamed("SETimeChooseView", owner: nil, options: nil)
        if views != nil && (views as! [UIView]).count > 0 {
            let view = views!.first as! SETimeChooseView
            SETool.resignAllFirstResponder()
            view.originalDate = self.date
            UIApplication.shared.keyWindow?.addSubview(view)
            view.show()
            view.finishChooseCallBack = {
                [unowned self] (date: Date)->() in
                self.date = date
                if self.didEndEditingCallBack != nil {
                    self.didEndEditingCallBack!(["date":date])
                }
            }
        }
    }
}
