//
//  UIColorExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit

extension UIColor {
    
    class var blackAndWhiteColor : UIColor? { return UIColor(named: "BlackAndWhiteColor")}
    class var customWhiteAndBlackColor : UIColor? { return UIColor(named: "CustomWhiteAndBlackColor")}
    class var customWhiteAndCustomBlackColor : UIColor? { return UIColor(named: "CustomWhiteAndCustomBlackColor")}
    class var customWhiteAndLightGrayColor : UIColor? { return UIColor(named: "CustomWhiteAndLightGrayColor")}
    class var lightGrayAndWhiteColor : UIColor? { return UIColor(named: "LightGrayAndWhiteColor")}
    class var whiteAndBlackColor : UIColor? { return UIColor(named: "WhiteAndBlackColor")}
    class var whiteAndCustomBlackColor : UIColor? { return UIColor(named: "WhiteAndCustomBlackColor")}
    
    class var signatureColor : UIColor? { return UIColor(named: "signatureColor") } //signatureColor
    class var customRedColor : UIColor? { return UIColor(named: "CustomRedColor") }
    class var customBlueColor : UIColor? { return UIColor(named: "CustomBlueColor") }
 
    
    //주어진 색상의 밝기를 계산하고, 밝기에 맞게 대조되는 색상을 리턴해주는 작업.
    func customContrastingColor() -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        
        return brightness > 0.7 ? UIColor.darkGray : UIColor.white
    }
}
