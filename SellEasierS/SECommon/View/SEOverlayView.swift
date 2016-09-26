//
//  SEOverlayView.swift
//  SellEasierS
//
//  Created by huan on 16/9/9.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
protocol SEOverlayViewDelegate {
    func drawSubViewOnOverlayView(_ overlayView:UIView) -> ()
}

class SEOverlayView:UIView,UIGestureRecognizerDelegate {
    var delegate : SEOverlayViewDelegate?
    
    var overlayViewAlpha: CGFloat = 0.3
    
    var overlayViewBackgroundColor: UIColor? = UIColor.black
    
    func show() {
        //在浮层上布局子控件
        if (self.delegate) != nil {
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            
            self.addGestureRecognizer(tapGes)
            tapGes.delegate = self;
            UIApplication.shared.keyWindow?.addSubview(self)
            self.addSubview(self.baseView)
//            if delegate.conformsToProtocol(SEOverlayViewDelegate) {
                self.delegate?.drawSubViewOnOverlayView(self)
//            }
        }
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)

        self.isHidden = false;
    }
    
    func dismiss() {
        self.isHidden = true;
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    lazy var baseView:UIView = {
//        get{
        
            let frame = CGRect(x: 0, y: 0, width: SECommon.Macro.screenWidth, height: SECommon.Macro.screenHeight)
            var view = UIView(frame: frame)
            view.tag = 16072704;
            view.isUserInteractionEnabled = false;
            
            view.backgroundColor = self.overlayViewBackgroundColor;
            view.alpha = self.overlayViewAlpha;
            return view;
//        }
    }()
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.view is SEOverlayView {
            return true
        }
        return false
    }
    
}
