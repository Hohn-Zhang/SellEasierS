//
//  SEHourGlass.swift
//  SellEasierS
//
//  Created by huan on 16/9/20.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
class SELoadingView: UIView {

    fileprivate var color: UIColor
    fileprivate var size: CGSize
    
    fileprivate var executClosure: (()->())?
    
    fileprivate var replicatorLayer:CAReplicatorLayer?
    
    required public init?(coder aDecoder: NSCoder) {
        self.color = UIColor.black
        self.size = CGSize(width: 40, height: 40)
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, color: UIColor = UIColor.black, size: CGSize = CGSize(width: 40, height: 40)) {
        self.color = color
        self.size = size
        super.init(frame: frame)
    }
    
    func show() {
        layer.sublayers = nil
        setup(layer, size: size, color: color)
    }
    
    func dismiss() {
        layer.sublayers = nil
    }
    
    func showWhileExecutingClosure(executingClosure:(()->())?,completion:(()->())?) {
        show()
        
        if executingClosure != nil {
            executClosure = executingClosure
            let queue = DispatchQueue.global(qos:.userInteractive)
            queue.async(execute: { 
                self.executClosure!()
                
                // Update UI
                DispatchQueue.main.async(execute: {
                    [unowned self] in
                    self.executClosure = nil
                    completion!()
                    self.dismiss()
                })
            })
        }
    }
    
    fileprivate func setup(_ layer: CALayer, size: CGSize, color: UIColor) {
        
        let dotNum: CGFloat = 10
        let diameter: CGFloat = size.width / 10
        
        let dot = CALayer()
        let frame = CGRect(
            x: (layer.bounds.width - diameter) / 2 + diameter * 2,
            y: (layer.bounds.height - diameter) / 2,
            width: diameter,
            height: diameter
        )
        
        dot.backgroundColor = color.cgColor
        dot.cornerRadius = diameter / 2
        dot.frame = frame
        
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer!.frame = layer.bounds
        replicatorLayer!.instanceCount = Int(dotNum)
        replicatorLayer!.instanceDelay = 0.1
        
        let angle = (2.0 * M_PI) / Double(replicatorLayer!.instanceCount)
        
        replicatorLayer!.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        
        layer.addSublayer(replicatorLayer!)
        replicatorLayer!.addSublayer(dot)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.4
        scaleAnimation.duration = 0.5
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        dot.add(scaleAnimation, forKey: "scaleAnimation")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = -2.0 * M_PI
        rotationAnimation.duration = 6.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        replicatorLayer!.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
