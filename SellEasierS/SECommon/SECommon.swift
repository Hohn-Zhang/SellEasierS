//
//  SECommon.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
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

class SECommon : NSObject{
    //常用值，相当于宏定义
    struct Macro {
        //app主色调
        static let mainColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        
        //1像素长度
        static let onePixel = 1.0/UIScreen.main.scale
        
        //屏幕尺寸
        static let screenFrame = UIScreen.main.bounds
        static let screenSize = UIScreen.main.bounds.size
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        
        //系统版本判断
        static let iOS7 = Double(UIDevice.current.systemVersion) >= 7.0
        static let iOS8 = Double(UIDevice.current.systemVersion) >= 8.0
        static let iOS9 = Double(UIDevice.current.systemVersion) >= 9.0
        static let iOS10 = Double(UIDevice.current.systemVersion) >= 10.0
    }
    
    enum ValueType: Int {
//        case noneType = 0
        case basicStr = 0         //字符串
        case number               //数字
        //    case SEPercentage,           //百分比
        case time                 //时间
        case picture              //图片
        case audio                //音频
        case video                //视频
    }
    
    enum DetailType:Int {
        case product = 0
        case seller  = 1
        case company = 2
    }
    
    struct RoundType : OptionSet  {
        var rawValue = 0  // 因为RawRepresentable的要求
        static var RoundNone = RoundType(rawValue: 0)
        static var RoundTopLeft = RoundType(rawValue: 1 << 0)
        static var RoundTopRight = RoundType(rawValue: 1 << 1)
        static var RoundBottomLeft = RoundType(rawValue: 1 << 2)
        static var RoundBottomRight = RoundType(rawValue: 1 << 3)
    }
    
    struct HelpOptions : OptionSet {
        var rawValue = 0  // 因为RawRepresentable的要求
        
        static var Call110 = HelpOptions(rawValue: 1 << 0)
        static var Call119 = HelpOptions(rawValue: 1 << 1)
        static var Call120 = HelpOptions(rawValue: 1 << 2)
    }
    
    struct SegueName {
        static let DetailToDetailInfo        = "SEDetailToDetailInfo"
        static let DetailToTemplate          = "SEDetailToTemplate"
        static let DetailInfoToChooseType    = "SEDetailInfoToChooseType"
        static let DataListToDetail          = "SEDataListToDetail"
        static let TemplateListToNewTemplate = "SETemplateListToNewTemplate"
        static let NewTemplateToChooseType   = "SENewTemplateToChooseType"
    }
}
