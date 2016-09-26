//
//  SETool.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
//import SECommon

class SETool {
    class func timeShowStrWithDate(_ date:Date?) -> String? {
        let calendar = Calendar.current
        let unitFlags:NSCalendar.Unit = [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.hour , NSCalendar.Unit.minute , NSCalendar.Unit.second]
        guard let date = date else {
            return nil
        }
        let dateComponent = (calendar as NSCalendar).components(unitFlags, from: date)
        var timeStr:String = ""
        if dateComponent.year! > 0 {
            timeStr += String(describing: dateComponent.year)
            timeStr += "年"
        }
        if dateComponent.month! > 0 {
            timeStr += String(describing: dateComponent.month)
            timeStr += "月"
        }
        if dateComponent.day! > 0 {
            timeStr += String(describing: dateComponent.day)
            timeStr += "日"
        }
        return timeStr
    }
    
    class func timeStorageStrWithDate(_ date:Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.locale = Locale(identifier: "zh_CN")
        return df.string(from: date)
    }
    
    class func dateWithStorageStr(_ storageStr:String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.locale = Locale(identifier: "zh_CN")
        return df.date(from: storageStr)
    }
    
    class func timeShowStrWithStorageStr(_ storageStr:String) -> String? {
        return SETool.timeShowStrWithDate(SETool.dateWithStorageStr(storageStr))
    }
    
    class func callPhone(_ phoneNum:String) {
        guard !phoneNum.isEmpty else {
            return
        }
        UIApplication.shared.openURL(URL(string: "tel://"+phoneNum)!)
    }
    
    class func creatImage(_ imageSize:CGSize,radius:CGFloat,fillColor:UIColor?,roundType:SECommon.RoundType,strokeColor:UIColor?,strokeLineWidth:CGFloat) -> UIImage {
        
        let tempRadius = radius * 2 //半径
        
        let originsize = CGSize(width: imageSize.width * 2, height: imageSize.height * 2)  //大小
        
        let originRect = CGRect(x: 0, y: 0, width: originsize.width, height: originsize.height)  //矩形
        
        UIGraphicsBeginImageContext(originsize) //开辟图像ImageContext---传大小
        
        let ctx = UIGraphicsGetCurrentContext()
        
        //设置填充背景色。
        ctx?.setFillColor(UIColor.clear.cgColor)
        
        //路径构造
        let path = CGMutablePath()
        
        //起点
        var offset:CGFloat = 0.0
        if roundType.contains(SECommon.RoundType.RoundTopLeft) {
            offset += tempRadius
        }
        path.move(to: CGPoint(x: originRect.origin.x, y: originRect.origin.y + offset))
        
        //左线--左下点
        if roundType.contains(SECommon.RoundType.RoundBottomLeft) {
            
            //左线
            path.addLine(to: CGPoint(x: originRect.origin.x, y: originRect.origin.y + originRect.size.height - tempRadius))
            
            //左下圆角
            path.addArc(center: CGPoint(x: originRect.origin.x + tempRadius, y: originRect.origin.y + originRect.size.height - tempRadius), radius: tempRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI / 2), clockwise: true)
        } else {
            //左线
            path.addLine(to: CGPoint(x: originRect.origin.x, y: originRect.origin.y + originRect.size.height))
        }
        
        //底线--右下点
        if roundType.contains(SECommon.RoundType.RoundBottomRight) {
            //底线
            path.addLine(to: CGPoint(x: originRect.origin.x + originRect.size.width-tempRadius, y: originRect.origin.y + originRect.size.height))
            
            //右下圆角--右下圆点
            
            path.addArc(center: CGPoint(x: originRect.origin.x + originRect.size.width - tempRadius, y: originRect.origin.y + originRect.size.height - tempRadius), radius: tempRadius, startAngle: CGFloat(M_PI / 2), endAngle: 0.0, clockwise: true)
        } else {
            //底线
            path.addLine(to: CGPoint(x: originRect.origin.x + originRect.size.width, y: originRect.origin.y + originRect.size.height))
        }
        
        //右线--右上点
        if roundType.contains(SECommon.RoundType.RoundTopRight) {
            //右线
            path.addLine(to: CGPoint(x: originRect.origin.x + originRect.size.width, y: originRect.origin.y + tempRadius))
            
            //右上圆角--右上圆点
            path.addArc(center: CGPoint(x: originRect.origin.x + originRect.size.width - tempRadius, y: originRect.origin.y + tempRadius), radius: tempRadius, startAngle: 0.0, endAngle: CGFloat(-M_PI / 2), clockwise: true)
        } else {
            //右线
            path.addLine(to: CGPoint(x: originRect.origin.x + originRect.size.width, y: originRect.origin.y))
        }
        
        //上线--左上点
        if roundType.contains(SECommon.RoundType.RoundTopLeft){
            //上线
            path.addLine(to: CGPoint(x: originRect.origin.x + tempRadius, y: originRect.origin.y))
            
            //左上圆角--左上圆点
            path.addArc(center: CGPoint(x: originRect.origin.x + tempRadius, y: originRect.origin.y + tempRadius), radius: tempRadius, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI), clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: originRect.origin.x, y: originRect.origin.y))
        }
        
        //闭合
        path.closeSubpath()
        
        //填充色设置
        if let fillColor = fillColor {
            fillColor.setFill()
            ctx?.addPath(path)//Context加入Path
            ctx?.saveGState()
            ctx?.fillPath()//填充颜色
            ctx?.restoreGState()
        }
        
        if let strokeColor = strokeColor {
            strokeColor.setStroke()
            ctx?.setLineWidth(strokeLineWidth * 2.0)
            ctx?.setLineCap(CGLineCap.round)
            ctx?.addPath(path) //Context加入Path
            ctx?.strokePath()
        }
        
        let desImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return desImage!

    }
    
    class func colorWithHexCode(_ hexCode:String) -> UIColor {
        
        var cString = hexCode.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        // strip 0X if it appears
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        }
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }

        // Separate into r, g, b substrings
        var range = NSRange(location: 0, length: 2)
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        // Scan values
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    class func uuid() -> String {
        let puuid = CFUUIDCreate( nil )
        let uuidString = CFUUIDCreateString( nil, puuid )
        let result = CFStringCreateCopy( nil, uuidString) as String
//        CFRelease(puuid)
//        CFRelease(uuidString)
        return result
    }
    
    class func valueTypeStrWithType(_ valueType:SECommon.ValueType) -> String {
        var tempStr:String = ""
        switch valueType {

        case SECommon.ValueType.basicStr://字符串
            tempStr = "基础信息"

        case SECommon.ValueType.number://数字
            tempStr = "数值"

            //        case SEPercentage://百分比
            //            tempStr = @"百分比"
        case SECommon.ValueType.time://时间
            tempStr = "时间"
        case SECommon.ValueType.picture://图片
            tempStr = "图片"
        case SECommon.ValueType.audio://音频
            tempStr = "音频"
        case SECommon.ValueType.video://视频
            tempStr = "视频"
        }
        return tempStr
    }
    
    class func resignAllFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    class func JSONStrWithDic(_ dic:Dictionary<String,String>) -> String? {
        if JSONSerialization.isValidJSONObject(dic) {
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted) {
                let jsonStr = String(data: data, encoding: String.Encoding.utf8)
                if let jsonStr = jsonStr {
                    return jsonStr
                }
            }
        }
        return nil
    }
    
    class func dicWithJSONStr(_ jsonStr:String) ->Dictionary<String,String>? {
        if let data = jsonStr.data(using: String.Encoding.utf8) {
            
            if let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) {
                return dic as? Dictionary<String, String>
            }
        }
        return nil
    }
}


